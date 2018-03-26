//
//  FFRPackageViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRPackageViewController.h"

#import "FFRecommentCarouselView.h"
#import "FFPackageSearchResultViewController.h"
#import "FFMyPackageViewController.h"
#import "FFGameViewController.h"

#define CELL_IDE @"FFpackageCell"

@interface FFRPackageViewController () <UITableViewDelegate, FFRecommentCarouselViewDelegate, UISearchBarDelegate, UISearchControllerDelegate>


/** 滚动视图 */
@property (nonatomic, strong) FFRecommentCarouselView *carouselView;

/** 搜索框 */
@property (nonatomic, strong) UISearchController *searchController;
/** 搜索结果 */
@property (nonatomic, strong) FFPackageSearchResultViewController *searchResultController;

/** section hight */
@property (nonatomic, assign) CGFloat sectionHeight;
/** sectionview */
@property (nonatomic, strong) UIView *sectionView;

/**< 我的礼包按钮 */
@property (nonatomic, strong) UIBarButtonItem *minePackageBtn;

@end

@implementation FFRPackageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setRightButton];
}

- (void)setRightButton {
    if (SSKEYCHAIN_USER_NAME) {
        self.navigationItem.rightBarButtonItem = self.minePackageBtn;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)clickMinePackageBtn {
    self.hidesBottomBarWhenPushed = YES;
    FFMyPackageViewController *vc = [[FFMyPackageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat height = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.tableView.frame = CGRectMake(0, height, kSCREEN_WIDTH,  kSCREEN_HEIGHT - height);
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"礼包";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initDataSource {
    [super initDataSource];
    BOX_REGISTER_CELL;
    [self.tableView.mj_header beginRefreshing];
    self.sectionHeight = self.searchController.searchBar.bounds.size.height;
}

- (void)refreshNewData {
    //请求轮播图
    [FFPackageModel packageBannerWithCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"package banner == %@",content);
        if (success) {
            self.carouselView.rollingArray = content[@"data"];
        }
    }];

    //请求礼包列表
    WeakSelf;
    [self.model loadNewPackageWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            weakSelf.showArray = [content[@"data"][@"list"] mutableCopy];
            [weakSelf.tableView reloadData];
        } else {

        }

        if (weakSelf.showArray && weakSelf.showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
            if (self.carouselView.rollingArray.count > 0) {
                self.tableView.tableHeaderView = self.carouselView;
            } else {
                self.tableView.tableHeaderView = nil;
            }
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
            self.tableView.tableHeaderView = nil;
        }

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


- (void)loadMoreData {
    WeakSelf;
    [self.model loadMorePackageWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *dataArray = content[@"data"][@"list"];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchController.searchBar resignFirstResponder];
}

#pragma mark - searchbar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    syLog(@"search === %@",searchBar.text);
    [self.searchResultController searchPackage:searchBar.text];
}

#pragma mark - search controller delegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    [self addChildViewController:self.searchResultController];
    [self.view addSubview:self.searchResultController.view];
    [self.searchResultController didMoveToParentViewController:self];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [self.searchResultController willMoveToParentViewController:self];
    [self.searchResultController.view removeFromSuperview];
    [self.searchResultController removeFromParentViewController];
}



#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.sectionView addSubview:self.searchController.searchBar];
    return self.sectionView;
}

#pragma mark - carouse view delegate
- (void)FFRecommentCarouselView:(FFRecommentCarouselView *)view didSelectImageWithInfo:(NSDictionary *)info {
    syLog(@"did image info == %@",info);
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [FFGameViewController sharedController].gameID = info[@"gid"];
    [FFGameViewController sharedController].gameLogo = nil;
    [self.navigationController pushViewController:[FFGameViewController sharedController] animated:YES];
}

#pragma mark - getter
/** 滚动轮播图 */
- (FFRecommentCarouselView *)carouselView {
    if (!_carouselView) {
        _carouselView = [[FFRecommentCarouselView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.4)];
        _carouselView.delegate = self;
    }
    return _carouselView;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.barTintColor = NAVGATION_BAR_COLOR;
        _searchController.searchBar.placeholder = @"搜索礼包";
        _searchController.searchBar.delegate = self;

        for (id subView in [_searchController.searchBar subviews][0].subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [subView setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                break;
            }
        }
        _searchController.searchBar.tintColor = [UIColor whiteColor];
        id searchField = [_searchController.searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setTintColor:[UIColor grayColor]];
        }
    }
    return _searchController;
}

- (FFPackageSearchResultViewController *)searchResultController {
    if (!_searchResultController) {
        _searchResultController = [[FFPackageSearchResultViewController alloc] init];
    }
    return _searchResultController;
}

- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.searchController.searchBar.bounds.size.height)];
        _sectionView.backgroundColor = NAVGATION_BAR_COLOR;
    }
    return _sectionView;
}

- (UIBarButtonItem *)minePackageBtn {
    if (!_minePackageBtn) {
        _minePackageBtn = [[UIBarButtonItem alloc] initWithTitle:@"我的礼包" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickMinePackageBtn)];
    }
    return _minePackageBtn;
}

@end
















