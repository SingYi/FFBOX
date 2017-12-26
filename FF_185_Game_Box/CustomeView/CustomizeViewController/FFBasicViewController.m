//
//  FFBasicViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/3.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicViewController.h"

#define CELL_IDE @"FFCustomizeCell"


@interface FFBasicViewController ()<UITableViewDelegate, UITableViewDataSource>





@end



@implementation FFBasicViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}


#pragma mark - method
- (void)refreshNewData {

}

- (void)loadMoreData {

}


#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    [cell setValue:@3 forKey:@"selectionStyle"];

    [cell setValue:self.showArray[indexPath.row] forKey:@"dict"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id cell = [tableView cellForRowAtIndexPath:indexPath];

    Class FFFpackageCell = NSClassFromString(@"FFpackageCell");
    if ([cell isKindOfClass:FFFpackageCell]) {
        return;
    }

    UIImageView *imageView = [cell valueForKey:@"gameLogo"];
    NSDictionary *dict = self.showArray[indexPath.row];

    Class FFGameViewController = NSClassFromString(@"FFGameViewController");

    id vc = [FFGameViewController performSelector:@selector(sharedController)];
    if (dict[@"gamename"]) {
        [vc setValue:dict[@"gamename"] forKey:@"gameName"];
    }

    if (dict[@"gameName"]) {
        [vc setValue:dict[@"gameName"] forKey:@"gameName"];
    }

    if (dict[@"id"]) {
        [vc setValue:dict[@"id"] forKey:@"gameID"];
    } else {
        return;
    }

    if (imageView) {
        [vc setValue:imageView.image forKey:@"gameLogo"];
    }


    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:vc animated:YES];
    SHOW_TABBAR;
    SHOW_PARNENT_TABBAR;
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
    }
    return _tableView;
}



- (NSMutableArray *)showArray {
    if (!_showArray) {
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}







@end










