//
//  FFHomeViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFHomeViewController.h"
#import "FFHomeViewSelectView.h"
#import "FFSearchShowControllerViewController.h"

#import "FFRecommentController.h"
#import "FFNewGameController.h"
#import "FFHotGameController.h"
#import "FFClassifyController.h"
#import "FFRaidersViewController.h"

#import "FFMyNewsViewController.h"
#import "FFLoginViewController.h"

#import "SYKeychain.h"
#import "UIBarButtonItem+FFSubscript.h"
//#import <PTFakeTouch/PTFakeTouch.h>

@interface FFHomeViewController ()<FFOpenServerSelectViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, FFSearchShowDelegate>

@property (nonatomic, strong) NSArray *childeTitles;
/** 选择视图 */
@property (nonatomic, strong) FFHomeViewSelectView *selectView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, strong) UIViewController *lastController;

@property (nonatomic, strong) FFRecommentController     *hRecommentController;
@property (nonatomic, strong) FFNewGameController       *hNewGamesController;
@property (nonatomic, strong) FFHotGameController       *hHotGamesController;
@property (nonatomic, strong) FFClassifyController      *hClassifyController;
@property (nonatomic, strong) FFRaidersViewController   *hradiersViewController;
@property (nonatomic, strong) NSArray<UIViewController *> *hChildControllers;

@property (nonatomic, strong) UISearchBar *searchBar;
/** 应用按钮(左边按钮) */
@property (nonatomic, strong) UIBarButtonItem *downLoadBtn;
/** 消息按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *messageBtn;
/** 取消按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;

@end

@implementation FFHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showNavigationButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self showNavigationButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    _hChildControllers = [@[self.hRecommentController,self.hNewGamesController,self.hradiersViewController,self.hClassifyController] copy];

    [self addChildViewController:_hChildControllers[0]];
    [self.scrollView addSubview:_hChildControllers[0].view];
    [_hChildControllers[0] didMoveToParentViewController:self];
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVGATION_BAR_COLOR;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchBar;
    [self showNavigationButton];


    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
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


#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    //设置选择视图的浮标
    [self.selectView reomveLabelWithX:(x / scrollView.contentSize.width * kSCREEN_WIDTH)];

    CGFloat index = x / kSCREEN_WIDTH;
    NSInteger afterIndex = index * 10000;
    NSInteger i = afterIndex / 10000;
    NSInteger other = afterIndex % 10000;

    if (i < _hChildControllers.count - 1 && other != 0) {
        [self hAddChildViewController:_hChildControllers[i]];
        [self hAddChildViewController:_hChildControllers[i + 1]];
    } else if (other == 0) {
        if (i > 0) {
            [self hChildControllerRemove:_hChildControllers[i - 1]];
            if (i != _hChildControllers.count - 1) {
                [self hChildControllerRemove:_hChildControllers[i + 1]];
            }
        } else {
            [self hAddChildViewController:_hChildControllers[0]];
            [self hChildControllerRemove:_hChildControllers[i + 1]];
        }
    }

    NSArray *array = self.childViewControllers;
    if (array.count == 1) {
        self.lastController = array[0];
    } else {
        self.lastController = nil;
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.selectView.userInteractionEnabled = NO;
    _isAnimation = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.selectView.userInteractionEnabled = YES;
    _isAnimation = NO;
}


- (void)hAddChildViewController:(UIViewController *)controller {
    [self addChildViewController:controller];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)hChildControllerRemove:(UIViewController *)controller {
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

#pragma mark - select View delegate
- (void)FFOpenServerSelectView:(FFHomeViewSelectView *)selectView didSelectBtnAtIndexPath:(NSInteger)idx {
    if (_isAnimation || self.lastController == _hChildControllers[idx]) {
        return;
    }

    if (self.lastController != nil) {
        [self hAddChildViewController:_hChildControllers[idx]];
        [self hChildControllerRemove:self.lastController];
    } else {
        [self hAddChildViewController:_hChildControllers[idx]];
    }

    self.lastController = _hChildControllers[idx];

    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:NO];
}

#pragma mark - set frame
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.selectView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 44);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.selectView.frame) - self.tabBarController.tabBar.frame.size.height);
    [self.scrollView setContentSize:CGSizeMake(kSCREEN_WIDTH * self.childeTitles.count, self.scrollView.frame.size.height)];

    self.hRecommentController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);;
    self.hNewGamesController.view.frame = CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
    self.hradiersViewController.view.frame = CGRectMake(kSCREEN_WIDTH * 2, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
    self.hClassifyController.view.frame = CGRectMake(kSCREEN_WIDTH * 3, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
}

#pragma mark - getter
- (NSArray *)childeTitles {
    if (!_childeTitles) {
        _childeTitles = @[@"推荐",@"新游",@"攻略",@"分类"];
    }
    return _childeTitles;
}

- (FFHomeViewSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFHomeViewSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, 44) WithBtnArray:self.childeTitles];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}


- (FFRecommentController *)hRecommentController {
    if (!_hRecommentController) {
        _hRecommentController = [[FFRecommentController alloc] init];
    }
    return _hRecommentController;
}

- (FFNewGameController *)hNewGamesController {
    if (!_hNewGamesController) {
        _hNewGamesController = [[FFNewGameController alloc] init];
    }
    return _hNewGamesController;
}

- (FFHotGameController *)hHotGamesController {
    if (!_hHotGamesController) {
        _hHotGamesController = [[FFHotGameController alloc] init];
    }
    return _hHotGamesController;
}

- (FFClassifyController *)hClassifyController {
    if (!_hClassifyController) {
        _hClassifyController = [[FFClassifyController alloc] init];
    }
    return _hClassifyController;
}

- (FFRaidersViewController *)hradiersViewController {
    if (!_hradiersViewController) {
        _hradiersViewController = [[FFRaidersViewController alloc] init];
    }
    return _hradiersViewController;
}

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









