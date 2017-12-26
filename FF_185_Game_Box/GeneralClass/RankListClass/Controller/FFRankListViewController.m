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



@property (nonatomic, strong) UISearchBar *searchBar;
/** 应用按钮(左边按钮) */
@property (nonatomic, strong) UIBarButtonItem *downLoadBtn;
/** 消息按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *messageBtn;
/** 取消按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;




@end


@implementation FFRankListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showNavigationButton];
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

    self.navigationItem.titleView = self.searchBar;

    [self showNavigationButton];
}


#pragma mark - searchDeleagete
//即将开始搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self hideNavigationButton];
    [FFSearchShowControllerViewController showSearchControllerWith:self];
    return YES;
}

//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![searchBar.text isEqualToString:@""]) {
            [FFSearchModel addSearchHistoryWithKeyword:searchBar.text];
            HIDE_TABBAR;
            HIDE_PARNENT_TABBAR;
            [self.navigationController pushViewController:[FFSearchResultController resultControllerWithKeyWord:searchBar.text] animated:YES];
            SHOW_TABBAR;
            SHOW_PARNENT_TABBAR;
        }
    });
}

#pragma mark - search show delegate
- (void)FFSearchShowControllerViewController:(FFSearchShowControllerViewController *)controller didSelectRow:(id)info {
    [self.searchBar resignFirstResponder];
}

- (void)setGameType:(NSString *)gameType {
    self.rankListModel.gameType = gameType;
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

- (void)clickCancelBtn {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [FFSearchShowControllerViewController hideSearchController];
    [self showNavigationButton];
}

/** 我的应用 */
- (void)clickDownloadBtn {
    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:[ControllerManager shareManager].myAppViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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

//- (UISearchController *)searchController {
//    if (!_searchController) {
//        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//        _searchController.delegate = self;
//        _searchController.hidesNavigationBarDuringPresentation = NO;
//        _searchController.dimsBackgroundDuringPresentation = NO;
//        _searchController.searchBar.barTintColor = NAVGATION_BAR_COLOR;
//        _searchController.searchBar.placeholder = @"搜索游戏";
//        _searchController.searchBar.delegate = self;
//        _searchController.searchBar.tintColor = [UIColor whiteColor];
//
//        for (id subView in [_searchController.searchBar subviews][0].subviews) {
//            if ([subView isKindOfClass:[UIButton class]]) {
//                [subView setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//                break;
//            }
//        }
//
//        UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
//        if (searchField) {
//            [searchField setTintColor:[UIColor grayColor]];
//            [searchField setValue:[UIColor blackColor] forKey:@"backgroundColor"];
//
//            searchField.backgroundColor = [UIColor whiteColor];
//
//        }
//    }
//    return _searchController;
//}

- (UIBarButtonItem *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homePage_download"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickDownloadBtn)];
    }
    return _downLoadBtn;
}

- (UIBarButtonItem *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homePage_message"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickMessageBtn)];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"homePage_message"] forState:UIControlStateNormal];
        button.bounds = CGRectMake(0, 0, button.currentImage.size.width, button.currentImage.size.height);
        [button addTarget:self action:@selector(clickMessageBtn) forControlEvents:UIControlEventTouchDown];
        // 添加角标
        _messageBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
        _messageBtn.badgeBGColor = [UIColor redColor];
    }
    return _messageBtn;
}

- (UIBarButtonItem *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickCancelBtn)];
    }
    return _cancelBtn;
}


- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];

        _searchBar.barTintColor = NAVGATION_BAR_COLOR;
        _searchBar.tintColor = [UIColor grayColor];
        _searchBar.placeholder = @"搜索游戏";
        _searchBar.delegate = self;

        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
        }

    }
    return _searchBar;
}



@end





