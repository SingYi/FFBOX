//
//  FFOpenServerViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFOpenServerViewController.h"
#import "FFOpenServerSelectView.h"
#import "FFYesterdayOpenServerViewController.h"
#import "FFTodayOpenServerViewController.h"
#import "FFTomorrowOpenServerViewController.h"
#import "FFSearchShowControllerViewController.h"

#import "FFMyNewsViewController.h"
#import "FFLoginViewController.h"

#import "UIBarButtonItem+FFSubscript.h"

#define COLLECTION_CELL_IDE @"OPENSERVERCOLLECTIONCELL"

#define VIEW_FRAME CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height)

@interface FFOpenServerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FFOpenServerSelectViewDelegate, UISearchBarDelegate, FFSearchShowDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) FFOpenServerSelectView *selectView;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) FFYesterdayOpenServerViewController *yesterdayOpenServeController;
@property (nonatomic, strong) FFTodayOpenServerViewController *todayOpenServerController;
@property (nonatomic, strong) FFTomorrowOpenServerViewController *tomorrowOpenserverController;

@property (nonatomic, strong) UISearchBar *searchBar;
/** 应用按钮(左边按钮) */
@property (nonatomic, strong) UIBarButtonItem *downLoadBtn;
/** 消息按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *messageBtn;
/** 取消按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;


@end



@implementation FFOpenServerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showNavigationButton];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletAllnotification) name:@"deletAllnotification" object:nil];
}

- (void)deletAllnotification {
    [self.todayOpenServerController refreshNewData];
    [self.tomorrowOpenserverController refreshNewData];
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVGATION_BAR_COLOR;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchBar;
    [self showNavigationButton];

    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.selectView];
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

#pragma mark - collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_CELL_IDE forIndexPath:indexPath];

    switch (indexPath.row) {
        case 0:
            [cell addSubview:self.todayOpenServerController.view];

            break;
        case 1:
            [cell addSubview:self.tomorrowOpenserverController.view];

            break;
        case 2:
            [cell addSubview:self.yesterdayOpenServeController.view];

            break;

        default:
            break;
    }


//    cell.backgroundColor = [UIColor colorWithRed:indexPath.row * 100 / 255.0 green:1 blue:1 alpha:1];
    cell.backgroundColor = [UIColor whiteColor];


    return cell;
}

#pragma mark - select View delegate
- (void)FFOpenServerSelectView:(FFOpenServerSelectView *)selectView didSelectBtnAtIndexPath:(NSInteger)idx {
    _isSelect = YES;
    [self.collectionView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, self.collectionView.contentOffset.y) animated:YES];
    _isSelect = NO;
}

#pragma mark - srcrllerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (_isSelect) {
        return;
    }
    
    CGFloat x = scrollView.contentOffset.x;

    if (x == 0) {
        return;
    }
    CGSize rect = scrollView.contentSize;
    CGFloat x1 = x / rect.width;
    x = x1 * kSCREEN_WIDTH;

    [self.selectView reomveLabelWithX:x];
}

#pragma mark - set frame
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.selectView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 44);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.selectView.frame) - self.tabBarController.tabBar.frame.size.height);

    CGRect frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.collectionView.frame.size.height);
    self.layout.itemSize = frame.size;

    self.yesterdayOpenServeController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.collectionView.frame.size.height);;
    self.todayOpenServerController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.collectionView.frame.size.height);;
    self.tomorrowOpenserverController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.collectionView.frame.size.height);;

}

#pragma mark - getter
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:COLLECTION_CELL_IDE];

        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];

        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;

    }

    return _collectionView;
}

- (FFOpenServerSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFOpenServerSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, 44) WithBtnArray:@[@"今日开服",@"即将开服",@"已经开服"]];

        _selectView.delegate = self;
    }
    return _selectView;
}

- (FFYesterdayOpenServerViewController *)yesterdayOpenServeController {
    if (!_yesterdayOpenServeController) {
        _yesterdayOpenServeController = [[FFYesterdayOpenServerViewController alloc] init];
        [self addChildViewController:_yesterdayOpenServeController];
        [_yesterdayOpenServeController didMoveToParentViewController:self];
    }
    return _yesterdayOpenServeController;
}

- (FFTodayOpenServerViewController *)todayOpenServerController {
    if (!_todayOpenServerController) {
        _todayOpenServerController = [[FFTodayOpenServerViewController alloc] init];
        [self addChildViewController:_todayOpenServerController];
        [_todayOpenServerController didMoveToParentViewController:self];
    }
    return _todayOpenServerController;
}


- (FFTomorrowOpenServerViewController *)tomorrowOpenserverController {
    if (!_tomorrowOpenserverController) {
        _tomorrowOpenserverController = [[FFTomorrowOpenServerViewController alloc] init];
        [self addChildViewController:_tomorrowOpenserverController];
        [_tomorrowOpenserverController didMoveToParentViewController:self];
    }
    return _tomorrowOpenserverController;
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







