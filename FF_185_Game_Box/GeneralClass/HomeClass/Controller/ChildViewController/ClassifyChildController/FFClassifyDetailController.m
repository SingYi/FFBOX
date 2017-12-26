//
//  FFClassifyDetailController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/27.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFClassifyDetailController.h"
#import "FFCustomizeCell.h"
#import "FFClassifyModel.h"
#import "FFGameViewController.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#define CELLIDENTIFIER @"FFCustomizeCell"

@interface FFClassifyDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic, strong) UITableView *tableView;

/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;



@end

@implementation FFClassifyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    _showArray = nil;
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - method
- (void)refreshData {
    _currentPage = 1;
    [FFClassifyModel ClassifyWithID:_dict[@"id"] Page:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success) {
            _showArray = [content[@"data"] mutableCopy];
        } else {
            _currentPage = 0;
            _showArray = nil;
        }
        [self.tableView reloadData];

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    _currentPage++;
    [FFClassifyModel ClassifyWithID:_dict[@"id"] Page:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success) {
            NSMutableArray *array = [content[@"data"] mutableCopy];
            if (array == nil || array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


#pragma mark - tableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFCustomizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];

    cell.dict = _showArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    FFCustomizeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [FFGameViewController sharedController].gameName = cell.dict[@"gamename"];
    [FFGameViewController sharedController].gameLogo = cell.gameLogo.image;
    [FFGameViewController sharedController].gameID = cell.dict[@"id"];
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:[FFGameViewController sharedController] animated:YES];
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    if (dict != nil && ![dict[@"id"] isEqualToString:_dict[@"id"]]) {
        _showArray = nil;
        [self.tableView reloadData];
        _dict = dict;
        self.navigationItem.title = dict[@"name"];
        [self.tableView.mj_header beginRefreshing];
    } else {

    }
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;


        [_tableView registerNib:[UINib nibWithNibName:CELLIDENTIFIER bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];

        _tableView.backgroundColor = [UIColor whiteColor];

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;


        //下拉刷新
        MJRefreshNormalHeader *customRef = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];

        [customRef setTitle:@"数据已加载" forState:MJRefreshStateIdle];
        [customRef setTitle:@"刷新数据" forState:MJRefreshStatePulling];
        [customRef setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        [customRef setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
        [customRef setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];


        //自动更改透明度
        _tableView.mj_header.automaticallyChangeAlpha = YES;

        _tableView.mj_header = customRef;

        //上拉刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}

@end
