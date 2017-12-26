//
//  FFNewGameController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFNewGameController.h"
#import "FFRankListModel.h"
#import "FFCustomizeCell.h"
#import "FFGameViewController.h"

#define CELL_IDE @"FFCustomizeCell"

@interface FFNewGameController ()<UITableViewDelegate>

/**时间数组*/
@property (nonatomic, strong) NSArray<NSString *> * timeArray;

/**游戏数组*/
@property (nonatomic, strong) NSMutableDictionary * dataDictionary;

@property (nonatomic, strong) FFRankListModel *rankModel;

@end

@implementation FFNewGameController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
    [super initDataSource];
    self.rankModel.gameType = @"0";
    [self tableViewBegainRefreshData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)refreshNewData {
    WeakSelf;
    [self.rankModel loadNewRankListWithCompletion:^(NSDictionary *content, BOOL success) {

        if (success) {
            weakSelf.showArray = [content[@"data"] mutableCopy];
            [self clearUpData:weakSelf.showArray];

        } else {

        }

        if (weakSelf.showArray && weakSelf.showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)loadMoreData {
    WeakSelf;
    [self.rankModel loadMoreRankListWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *dataArray = content[@"data"];
            if (dataArray.count > 0) {
                [weakSelf.showArray addObjectsFromArray:dataArray];
                [self clearUpData:weakSelf.showArray];
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {

            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (NSMutableArray *)clearUpData:(NSMutableArray *)array {

    NSMutableSet *set = [NSMutableSet set];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];


    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *timeStr = obj[@"addtime"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        timeStr = [formatter stringFromDate:date];

        NSMutableArray *array = dict[timeStr];
        if (array == nil) {
            array = [NSMutableArray array];
        }
        [array addObject:obj];

        [dict setObject:array forKey:timeStr];

        [set addObject:timeStr];

    }];


    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
    self.timeArray = [set sortedArrayUsingDescriptors:sortDesc];


    self.dataDictionary = [dict mutableCopy];

    [self.timeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *array = self.dataDictionary[obj];
        [self.dataDictionary setObject:array forKey:obj];
    }];

    return [array mutableCopy];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];

    label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    label.text = [NSString stringWithFormat:@"   %@",self.timeArray[section]];

    return label;
}

#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.timeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataDictionary[self.timeArray[section]];
    return array.count;
}

- (FFCustomizeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFCustomizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];

    NSArray *array = self.dataDictionary[self.timeArray[indexPath.section]];

    cell.dict = array[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    FFCustomizeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = cell.dict;

    [FFGameViewController sharedController].gameName = dict[@"gamename"];
    [FFGameViewController sharedController].gameLogo = cell.gameLogo.image;
    [FFGameViewController sharedController].gameID = dict[@"id"];
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:[FFGameViewController sharedController] animated:YES];
    SHOW_TABBAR;
    SHOW_PARNENT_TABBAR;
}



#pragma mark - getter
- (FFRankListModel *)rankModel {
    if (!_rankModel) {
        _rankModel = [FFRankListModel new];
    }
    return _rankModel;
}


@end




