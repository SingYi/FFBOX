//
//  FFTodayOpenServerViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFTodayOpenServerViewController.h"

@interface FFTodayOpenServerViewController ()

@end

@implementation FFTodayOpenServerViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.bounds.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
    //今日开服
    self.model.serverType = @"1";
    [self tableViewBegainRefreshing];
}




@end
