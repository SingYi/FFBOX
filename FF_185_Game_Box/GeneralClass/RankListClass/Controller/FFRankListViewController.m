//
//  FFRankListViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRankListViewController.h"
#import "FFSearchShowControllerViewController.h"

#import "FFMyNewsViewController.h"
#import "FFLoginViewController.h"

#import "FFCustomizeCell.h"

#import "FFRankListModel.h"
#import "FFViewFactory.h"

#import "UIBarButtonItem+FFSubscript.h"


#define CELL_IDE @"FFCustomizeCell"

@interface FFRankListViewController ()<UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, FFSearchShowDelegate>

//数据模型
@property (nonatomic, strong) FFRankListModel *rankListModel;

/** 搜索 */
@property (nonatomic, strong) UISearchController *searchController;

/** 消息按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *messageBtn;
/** 取消按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;




@end


@implementation FFRankListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT - self.tabBarController.tabBar.frame.size.height);
}


- (void)initDataSource {
    [super initDataSource];
    [self setGameType:@"2"];
    [self setGameDiscCount:@"1"];
    [self tableViewBegainRefreshData];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVGATION_BAR_COLOR;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


}


#pragma mark - search show delegate
- (void)setGameType:(NSString *)gameType {
    self.rankListModel.gameType = gameType;
}

- (void)setGameDiscCount:(NSString *)discount {
    syLog(@"设置 discount 类型 === %@",discount);
    self.rankListModel.discount = discount;
}

- (void)tableViewBegainRefreshData {
    [self.tableView.mj_header beginRefreshing];
}


- (void)refreshNewData {
    WeakSelf;
    [self.rankListModel loadNewRankListWithCompletion:^(NSDictionary *content, BOOL success) {

        if (success) {
            weakSelf.showArray = [content[@"data"] mutableCopy];
            [weakSelf.tableView reloadData];
        } else {

        }

        if (weakSelf.showArray && weakSelf.showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    WeakSelf;
    [self.rankListModel loadMoreRankListWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *dataArray = content[@"data"];
            if (dataArray.count > 0) {
                [weakSelf.showArray addObjectsFromArray:dataArray];
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

#pragma mark - responds
- (void)showNavigationButton {
    if (SSKEYCHAIN_UID) {
        self.navigationItem.rightBarButtonItem = self.messageBtn;
        [self setMessageButtonSubscript];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setMessageButtonSubscript {
    [FFSearchModel UnreadMessagesWithUid:SSKEYCHAIN_UID Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSString *string = [NSString stringWithFormat:@"%@",content[@"data"]];
            if (string.integerValue != 0) {
                self.messageBtn.badgeValue = string;
            } else {
                self.messageBtn.badgeValue = @"";
            }
        } else {
            self.messageBtn.badgeValue = @"";
        }
    }];
}


- (void)hideNavigationButton {
    self.navigationItem.rightBarButtonItem = self.cancelBtn;
}



/** 我的消息 */
- (void)clickMessageBtn {
    HIDE_TABBAR;
    if (SSKEYCHAIN_UID) {
        [self.navigationController pushViewController:[FFMyNewsViewController sharedController] animated:YES];
    } else {
        [self.navigationController pushViewController:[FFLoginViewController new] animated:YES];
    }
    SHOW_TABBAR;
}


#pragma mark - getter
- (FFRankListModel *)rankListModel {
    if (!_rankListModel) {
        _rankListModel = [[FFRankListModel alloc] init];
    }
    return _rankListModel;
}



@end





