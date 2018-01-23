//
//  FFDriveAllInfoViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/11.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveAllInfoViewController.h"
#import "DriveInfoCell.h"
#import "FFDriveDetailInfoViewController.h"


#define CELL_IDE @"DriveInfoCell"

@interface FFDriveAllInfoViewController ()<UITableViewDelegate,UITableViewDataSource,DriveInfoCellDelegate,FFDriveDetailDelegate>


@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) FFDriveDetailInfoViewController *detailController;


@end

@implementation FFDriveAllInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dynamicType = allDynamic;
    [self initDataSource];
    [self initUserInterface];
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor redColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}


- (void)refreshNewData {
    _currentPage = 1;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];

    [FFDriveModel getDynamicWithType:self.dynamicType Page:[NSString stringWithFormat:@"%ld",(unsigned long)_currentPage] Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"get dynamic == %@",content);
        if (success) {
            self.showArray = [content[@"data"] mutableCopy];
        }

        if (self.showArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
            imageView.image = [UIImage imageNamed:@"Community_NoData"];
            self.tableView.backgroundView = imageView;
        } else {
            self.tableView.backgroundView = nil;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    }];
}

- (void)loadMoreData {
    _currentPage ++;
    [FFDriveModel getDynamicWithType:allDynamic Page:[NSString stringWithFormat:@"%ld",(unsigned long)_currentPage] Complete:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"];
            if (array.count > 0 && array != nil) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        if (self.showArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
            imageView.image = [UIImage imageNamed:@"Community_NoData"];
            self.tableView.backgroundView = imageView;
        } else {
            self.tableView.backgroundView = nil;
        }

        
    }];
}

#pragma mark - responds
- (void)respondsToLikeOrDislikeButtonWithDynamicsID:(NSString *)dynamicsID Type:(LikeOrDislike)type index:(NSIndexPath *)indexPath {
    [FFDriveModel userLikeOrDislikeWithDynamicsID:dynamicsID type:type Complete:^(NSDictionary *content, BOOL success) {
        if (success) {
            [self replaceShowArrayDataWith:indexPath type:type];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

- (void)replaceShowArrayDataWith:(NSIndexPath *)indexPath type:(LikeOrDislike)type {
    NSMutableDictionary *dict = [self.showArray[indexPath.row] mutableCopy];
    NSMutableDictionary *dynamics = [dict[@"dynamics"] mutableCopy];
    NSMutableDictionary *user = [dict[@"user"] mutableCopy];
    if (type == like) {
        NSString *like = dynamics[@"likes"];
        [dynamics setObject:[NSString stringWithFormat:@"%ld",(like.integerValue + 1)] forKey:@"likes"];
        [user setObject:@"1" forKey:@"operate"];
    } else {
        NSString *like = dynamics[@"dislike"];
        [dynamics setObject:[NSString stringWithFormat:@"%ld",(like.integerValue + 1)] forKey:@"dislike"];
        [user setObject:@"0" forKey:@"operate"];
    }

    [dict setObject:dynamics forKey:@"dynamics"];
    [dict setObject:user forKey:@"user"];

    [self.showArray replaceObjectAtIndex:indexPath.row withObject:dict];

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}


#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DriveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.delegate = self;
    cell.dict = self.showArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushDetailControllerWith:indexPath Comment:NO];
}

- (void)pushDetailControllerWith:(NSIndexPath *)indexPath Comment:(BOOL)isComment {
    self.detailController.dict = self.showArray[indexPath.row];
    self.detailController.indexPath = indexPath;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:self.detailController animated:YES];
    SHOW_PARNENT_TABBAR;
}

#pragma mark - cell dele gate
- (void)DriveInfoCell:(DriveInfoCell *)cell didClickButtonWithType:(CellButtonType)type {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (type) {
        case likeButton: {
            [self respondsToLikeOrDislikeButtonWithDynamicsID:cell.dynamicsID Type:like index:indexPath];
        }
            break;
        case dislikeButton: {
            [self respondsToLikeOrDislikeButtonWithDynamicsID:cell.dynamicsID Type:dislike index:indexPath];
        }
            break;
        case sharedButton: {

        }
            break;
        case commentButoon: {
            [self pushDetailControllerWith:indexPath Comment:YES];
        }
            break;
        case noonButton: {

        }
            break;

        default:
            break;
    }
}

- (void)DriveInfoCell:(DriveInfoCell *)cell didClickIconWithUid:(NSString *)uid {
    syLog(@"click icon with uid == %@", uid);
}

#pragma mark - detail delegate
- (void)FFDriveDetailController:(FFDriveDetailInfoViewController *)controller replaceDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath {

    syLog(@"点赞????");
    [self.showArray replaceObjectAtIndex:indexPath.row withObject:dict];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [FFViewFactory creatTableView:_tableView WithFrame:CGRectNull WithDelegate:self];

        MJRefreshNormalHeader *customRefreshHeader = [FFViewFactory customRefreshHeaderWithTableView:_tableView WithTarget:self];

        //下拉刷新
        [customRefreshHeader setRefreshingAction:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  @selector(refreshNewData)];
        //上拉加载更多
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        _tableView.tableFooterView = [UIView new];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 2)];
        line.backgroundColor = BACKGROUND_COLOR;
        _tableView.tableHeaderView = line;

        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;

    }
    return _tableView;
}

- (DynamicType)dynamicType {
    return allDynamic;
}

- (FFDriveDetailInfoViewController *)detailController {
    if (!_detailController) {
        _detailController = [[FFDriveDetailInfoViewController alloc] init];
        _detailController.delegate = self;
    }
    return _detailController;
}


@end












