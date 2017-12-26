//
//  FFGamePackageViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGamePackageViewController.h"

@interface FFGamePackageViewController ()

@end

@implementation FFGamePackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initDataSource {
    [super initDataSource];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


- (void)refreshNewData {
    [FFPackageModel packageWithGameID:self.gameID Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
            syLog(@"game package ==== %@",content);
            [self.tableView reloadData];
        }

        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    [self refreshNewData];
}


@end
