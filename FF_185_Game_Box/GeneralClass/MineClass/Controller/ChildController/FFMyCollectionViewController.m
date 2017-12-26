//
//  FFMyCollectionViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyCollectionViewController.h"
#import "FFUserModel.h"
#import "FFGameViewController.h"

#define CELL_IDE @"FFCustomizeCell"

@interface FFMyCollectionViewController ()<UITableViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation FFMyCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的收藏";
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshNewData {
    _currentPage = 1;
    [FFUserModel myCollectionGameWithPage:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary *content, BOOL success) {
        if (success) {

            syLog(@"my collectino == %@",content);

            NSArray *array = content[@"data"];
            self.showArray = [array mutableCopy];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    _currentPage++;
    [FFUserModel myCollectionGameWithPage:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *array = content[@"data"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id cell = [tableView cellForRowAtIndexPath:indexPath];

    UIImageView *imageView = [cell valueForKey:@"gameLogo"];
    NSDictionary *dict = self.showArray[indexPath.row];

    FFGameViewController *vc  = [FFGameViewController sharedController];

    if (dict[@"id"]) {
        vc.gameID = dict[@"id"];
    } else {
        return;
    }

    if (imageView) {
        vc.gameLogo = imageView.image;
    }

    if (dict[@"gamename"]) {
        vc.gameName = dict[@"gamename"];
    }

    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:vc animated:YES];
}




@end




