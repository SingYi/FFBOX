//
//  FFTomorrowOpenServerViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFTomorrowOpenServerViewController.h"

@interface FFTomorrowOpenServerViewController ()

@end

@implementation FFTomorrowOpenServerViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.bounds.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
    //即将开服
    self.model.serverType = @"2";
    [self tableViewBegainRefreshing];
}



@end
