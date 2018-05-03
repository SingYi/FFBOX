//
//  FFLowDiscountViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/5/3.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFLowDiscountViewController.h"

#define CELL_IDE @"FFCustomizeCell"


@interface FFLowDiscountViewController ()

@end

@implementation FFLowDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"热门";
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
    [self setGameType:@"4"];
    [self setGameDiscCount:@"2"];
    [self tableViewBegainRefreshData];
}

- (void)tableViewBegainRefreshData {
    [self setGameType:@"1"];
    [self setGameDiscCount:@"2"];
    [super tableViewBegainRefreshData];
}

@end





