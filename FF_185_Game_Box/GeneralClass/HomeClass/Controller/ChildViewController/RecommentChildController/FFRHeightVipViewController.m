//
//  FFRHeightVipViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRHeightVipViewController.h"
#import "FFCustomizeCell.h"

#define CELL_IDE @"FFCustomizeCell"

@interface FFRHeightVipViewController ()<UITableViewDelegate>



@end

@implementation FFRHeightVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
//    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"满V游戏";
}

- (void)initDataSource {
//    [super initDataSource];
    BOX_REGISTER_CELL;
    [self setGameType:@"4"];
    [self tableViewBegainRefreshData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}











@end
