//
//  FFInviteRankListViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/27.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFInviteRankListViewController.h"
#import "FFSelectHeaderView.h"

#import "FFTodayInviteListViewController.h"
#import "FFYesterDayListViewController.h"

#import "UIAlertController+FFAlertController.h"

#import "FFInviteModel.h"

@interface FFInviteRankListViewController () <FFSelectHeaderViewDelegate>

@property (nonatomic, strong) FFSelectHeaderView *headerView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FFTodayInviteListViewController *todayListViewController;
@property (nonatomic, strong) FFYesterDayListViewController *yesterdayListViewController;

@property (nonatomic, assign) NSUInteger today_view_x;
@property (nonatomic, assign) NSUInteger yesterday_view_x;

@end

@implementation FFInviteRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initDataSource];
    [self initUserInterface];
}


- (void)initDataSource {
    _today_view_x = 0;
    _yesterday_view_x = 1;
    self.headerView.headerTitleArray = @[@"今日排行",@"昨日排行"];
    [[FFInviteModel sharedModel] setCompletion:^(BOOL success, First_list_enum listEnum) {

        if (success) {
            self.todayListViewController.showArray = [FFInviteModel sharedModel].todayList.mutableCopy;
            self.yesterdayListViewController.showArray = [FFInviteModel sharedModel].yesterDayList.mutableCopy;

            if (listEnum == TodayFirst) {
                self.headerView.headerTitleArray = @[@"今日排行",@"昨日排行"];
                self.today_view_x = 0;
                self.yesterday_view_x = 1;
            } else {
                self.headerView.headerTitleArray = @[@"昨日排行",@"今日排行"];
                self.today_view_x = 1;
                self.yesterday_view_x = 0;
            }
            self.todayListViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.today_view_x, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
            self.yesterdayListViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.yesterday_view_x, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
        } else {
            [UIAlertController showAlertMessage:@"刷新失败" dismissTime:0.7 dismissBlock:nil];
        }
        [self.todayListViewController.tableView.mj_header endRefreshing];
        [self.yesterdayListViewController.tableView.mj_header endRefreshing];
        [self.yesterdayListViewController.tableView reloadData];
        [self.todayListViewController.tableView reloadData];

    }];



    [self addChildViewController:self.todayListViewController];
    [self addChildViewController:self.yesterdayListViewController];

//    [[FFInviteModel sharedModel] refreshList];
    [self.todayListViewController.tableView.mj_header beginRefreshing];




    [[FFInviteModel sharedModel] setRewardBlock:^(BOOL success) {
        if (success) {
            [UIAlertController showAlertMessage:@"领取成功" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:@"领取失败,请刷新后尝试" dismissTime:0.7 dismissBlock:nil];
        }
    }];


}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"排行榜";
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.todayListViewController.view];
    [self.scrollView addSubview:self.yesterdayListViewController.view];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.headerView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 60);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame));
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * 2, kSCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame));
    self.todayListViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.today_view_x, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
    self.yesterdayListViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.yesterday_view_x, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
}

#pragma mark - header view delegate
- (void)FFSelectHeaderView:(FFSelectHeaderView *)view didSelectTitleWithIndex:(NSUInteger)idx {
    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0)];
}

#pragma mark - getter
- (FFSelectHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFSelectHeaderView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 60)];
        _headerView.delegate = self;
        _headerView.lineColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _headerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FFTodayInviteListViewController *)todayListViewController {
    if (!_todayListViewController) {
        _todayListViewController = [[FFTodayInviteListViewController alloc] init];
    }
    return _todayListViewController;
}

- (FFYesterDayListViewController *)yesterdayListViewController {
    if (!_yesterdayListViewController) {
        _yesterdayListViewController = [[FFYesterDayListViewController alloc] init];
    }
    return _yesterdayListViewController;
}




@end














