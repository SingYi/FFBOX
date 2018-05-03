//
//  HomeClassifyController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFClassifyController.h"
#import "FFClassifyTableCell.h"
#import "FFGameViewController.h"
#import "FFClassifyDetailController.h"

#import "FFViewFactory.h"
#import "FFClassifyModel.h"

#define CELL_IDE @"FFClassifyTableCell"

#define BTNTAG 1700
#define SECTIONTAG 2700

@interface FFClassifyController () <UITableViewDelegate, UITableViewDataSource, FFClassifyTableCellDelegate>

/** 分类详情 */
@property (nonatomic, strong) FFClassifyDetailController *classifyDetailController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *showArray;

/** 分类数组 */
@property (nonatomic, strong) NSMutableArray *classifyArray;

/** 头部视图 */
@property (nonatomic, strong) UIView *headerView;


@property (nonatomic, strong) FFClassifyModel *model;


@end

@implementation FFClassifyController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initUserInterface {
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"分类";
}

- (void)initDataSource {
    [self setPlatform:@"1"];
    [self refrehTableView];
}

- (void)setPlatform:(NSString *)platform {
    _platform = platform;
    syLog(@"classify  set platfor ==== %@",platform);
    self.model.platform = platform;
}

- (void)refrehTableView {
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)RefreshTheData {
    WeakSelf;
    [self.model loadNewClassifyWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            self.classifyArray = [content[@"data"][@"class"] mutableCopy];
            NSArray *array = content[@"data"][@"classData"];
            _showArray = [NSMutableArray array];

            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *list = obj[@"list"];
                if (list.count == 0 || list == nil) {

                } else {
                    [_showArray addObject:obj];
                }
            }];

            [self.tableView reloadData];
        } else {
            self.classifyArray = nil;
            _showArray = nil;
        }

        if (_showArray && _showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }


        if (weakSelf.classifyArray.count > 0) {
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        } else {
            weakSelf.tableView.tableHeaderView = nil;
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

- (void)loadMoreData {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFClassifyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.delegate = self;
    cell.array = _showArray[indexPath.section][@"list"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, kSCREEN_WIDTH, 26)];
    label.backgroundColor = RGBCOLOR(247, 247, 247);
    NSString *string = _showArray[section][@"className"];

    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame  = CGRectMake(kSCREEN_WIDTH - 75, 5, 60, 20);
    [button setTitle:@"更多>" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = SECTIONTAG + section;
    [button addTarget:self action:@selector(respondstoSectionBtn:) forControlEvents:(UIControlEventTouchUpInside)];

    label.text = [NSString stringWithFormat:@"     %@",string];

    [view addSubview:label];
    [view addSubview:button];
    return view;
}

#pragma mark - cellDelegate
- (void)FFClassifyTableCell:(FFClassifyTableCell *)cell clickGame:(NSDictionary *)dict {
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [FFGameViewController sharedController].gameName = dict[@"gamename"];
    [FFGameViewController sharedController].gameLogo = dict[@"gameLogo"];
    [FFGameViewController sharedController].gameID = dict[@"id"];
    [self.navigationController pushViewController:[FFGameViewController sharedController] animated:YES];
    SHOW_TABBAR;
    SHOW_PARNENT_TABBAR;
}

#pragma makr - setter
- (void)setClassifyArray:(NSMutableArray *)classifyArray {
    if (classifyArray) {
        _classifyArray = classifyArray;
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:_classifyArray.count];

        [_classifyArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *string = obj[@"name"];
            [titleArray addObject:string];
        }];

        CGFloat height = titleArray.count / 4.f;
        NSInteger height1 = height;

        if (height > height1) {
            height1++;
        }

        self.headerView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH / 4 * height1);

        self.headerView.backgroundColor = RGBCOLOR(247, 247, 247);

        [_classifyArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {

            NSString *title = obj[@"name"];

            //            背景视图
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 4 * (idx % 4), kSCREEN_WIDTH / 4 * (idx / 4), kSCREEN_WIDTH / 4, kSCREEN_WIDTH / 4 )];
            view.backgroundColor = RGBCOLOR(247, 247, 247);

            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];

            button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 8);
            button.center = CGPointMake(kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 9);

            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,obj[@"logo"]]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"image_downloading"]];

            button.tag = idx + BTNTAG;

            [button addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];

            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 20);
            label.center = CGPointMake(kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 24 * 5);

            label.text = title;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];

            [view addSubview:button];
            [view addSubview:label];
            [self.headerView addSubview:view];
        }];
    } else {
        self.headerView = nil;
    }

}

/** 按钮响应事件 */
- (void)respondsToBtn:(UIButton *)sender {
    HIDE_PARNENT_TABBAR;
    self.classifyDetailController.platform = self.platform;
    self.classifyDetailController.dict = self.classifyArray[sender.tag - BTNTAG];
    [self.navigationController pushViewController:self.classifyDetailController animated:YES];
    SHOW_PARNENT_TABBAR;
}

/** section按钮点击事件 */
- (void)respondstoSectionBtn:(UIButton *)button {
    NSString *classifyId = _showArray[button.tag - SECTIONTAG][@"list"][0][@"tid"];
    NSDictionary *dict = @{@"id":classifyId,@"name":_showArray[button.tag - SECTIONTAG][@"className"]};
    self.classifyDetailController.platform = self.platform;
    self.classifyDetailController.dict = dict;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:self.classifyDetailController animated:YES];
    SHOW_PARNENT_TABBAR;
}

#pragma makr - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [FFViewFactory creatTableView:_tableView WithFrame:CGRectNull WithDelegate:self];

        MJRefreshNormalHeader *customRefreshHeader = [FFViewFactory customRefreshHeaderWithTableView:_tableView WithTarget:self];
        //下拉刷新
        [customRefreshHeader setRefreshingAction:@selector(RefreshTheData)];
        //上拉加载更多
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        _tableView.backgroundColor = [UIColor whiteColor];

        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];

        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);
    }
    return _headerView;
}

- (FFClassifyModel *)model {
    if (!_model) {
        _model = [[FFClassifyModel alloc] init];
    }
    return _model;
}

- (FFClassifyDetailController *)classifyDetailController {
    if (!_classifyDetailController) {
        _classifyDetailController = [[FFClassifyDetailController alloc] init];
    }
    return _classifyDetailController;
}






@end





