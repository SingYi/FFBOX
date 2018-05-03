//
//  FFHotGameController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFHotGameController.h"

@interface FFHotGameController ()

@end

@implementation FFHotGameController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
    [super initDataSource];
    [self setGameType:@"1"];
    [self setGameDiscCount:@"1"];
    [self tableViewBegainRefreshData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}



@end
