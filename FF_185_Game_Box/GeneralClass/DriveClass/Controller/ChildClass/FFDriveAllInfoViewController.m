//
//  FFDriveAllInfoViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/11.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveAllInfoViewController.h"
#import "DriveInfoCell.h"
#import "FFViewFactory.h"



#define CELL_IDE @"DriveInfoCell"

@interface FFDriveAllInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

/** table View */
@property (nonatomic, strong) UITableView *tableView;

/** table view data source */
@property (nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic, assign) NSUInteger currentPage;



@end

@implementation FFDriveAllInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dynamicType = allDynamic;
    [self initDataSource];
    [self initUserInterface];
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor redColor];
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
    [FFDriveModel getDynamicWithType:self.dynamicType Page:[NSString stringWithFormat:@"%ld",(unsigned long)_currentPage] Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"get dynamic == %@",content);
        if (success) {
            self.showArray = [content[@"data"] mutableCopy];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
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
    }];
}

#pragma mark - responds


#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DriveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [FFViewFactory creatTableView:_tableView WithFrame:CGRectNull WithDelegate:self];

        MJRefreshNormalHeader *customRefreshHeader = [FFViewFactory customRefreshHeaderWithTableView:_tableView WithTarget:self];

        //下拉刷新
        [customRefreshHeader setRefreshingAction:@selector(refreshNewData)];
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


@end












