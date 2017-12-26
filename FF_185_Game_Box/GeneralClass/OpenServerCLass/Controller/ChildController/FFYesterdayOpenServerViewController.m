//
//  FFYesterdayOpenServerViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFYesterdayOpenServerViewController.h"
#import "FFViewFactory.h"


@interface FFYesterdayOpenServerViewController ()

@end

@implementation FFYesterdayOpenServerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
//    [super initDataSource];
    //已经开服
    self.model.serverType = @"3";
    [self tableViewBegainRefreshing];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    BOX_REGISTER_CELL;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
        self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.bounds.size.height);
}

- (void)tableViewBegainRefreshing {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - method
- (void)refreshNewData {
    WeakSelf;
    [self.model loadNewOpenServerWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            weakSelf.showArray = [content[@"data"] mutableCopy];
            [weakSelf.tableView reloadData];
        } else {
//            BOX_MESSAGE(content[@"msg"]);
        }

        if (weakSelf.showArray && weakSelf.showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        syLog(@"%@",content);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    WeakSelf;
    [self.model loadMoreOpenServerWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"];
            if (array.count > 0) {
                [weakSelf.showArray addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

#pragma mark - table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFOpenServerCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];



    cell.dict = self.showArray[indexPath.row];

    return cell;
}


#pragma mark - getter
- (FFOpenServerModel *)model {
    if (!_model) {
        _model = [[FFOpenServerModel alloc] init];
    }
    return _model;
}




@end
