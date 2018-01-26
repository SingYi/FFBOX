//
//  FFDriveMineViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveMineViewController.h"
#import "FFSelectHeaderView.h"
#import "FFMineViewCell.h"


@interface FFDriveMineViewController ()<UITableViewDelegate, UITableViewDataSource, FFSelectHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FFSelectHeaderView *selectHeaderView;


@property (nonatomic, strong) NSMutableArray *selectHeaderTitleArray;

@end

@implementation FFDriveMineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}



- (void)initUserInterface {

}

- (void)initDataSource {
    self.selectHeaderTitleArray = [@[@"开车数",@"粉丝",@"关注"] mutableCopy];
//    [self setFchildControllerWithClassNames:@[@"FFDriveAllInfoViewController",
//                                              @"FFDriveHotInfoViewController",
//                                              @"FFDriveAttentionInfoViewController"]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

#pragma mark - tableview dele gate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFMineViewCell *cell = [FFMineViewCell dequeueReusableCellWithIdentifierWithTableView:tableView];



    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height - kNAVIGATION_HEIGHT - CGRectGetHeight(self.tabBarController.tabBar.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.selectHeaderView;
}

#pragma mark - setter



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        [FFMineViewCell registCellWithTableView:_tableView];
    }
    return _tableView;
}
- (FFSelectHeaderView *)selectHeaderView {
    if (!_selectHeaderView) {
        _selectHeaderView = [[FFSelectHeaderView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 50)];
        _selectHeaderView.delegate = self;
    }
    return _selectHeaderView;
}




@end
