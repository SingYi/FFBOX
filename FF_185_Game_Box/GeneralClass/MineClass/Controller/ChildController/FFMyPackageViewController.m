//
//  FFMyPackageViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyPackageViewController.h"

@interface FFMyPackageViewController ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation FFMyPackageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的礼包";
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView reloadData];
}

- (void)refreshNewData {
    _currentPage = 1;
    NSString *page = [NSString stringWithFormat:@"%ld",_currentPage];
    [FFPackageModel userPackageListWithPage:page Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            self.showArray = [array mutableCopy];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    _currentPage++;
    NSString *page = [NSString stringWithFormat:@"%ld",_currentPage];
    [FFPackageModel userPackageListWithPage:page Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}



@end










