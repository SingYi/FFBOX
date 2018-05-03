//
//  FFRecommentController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRecommentController.h"
#import "FFViewFactory.h"
#import "FFRecommentModel.h"

#import "FFRecommentCollectionCell.h"
#import "FFCustomizeCell.h"

#import "FFLoginViewController.h"

#import "SYKeychain.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "FFGameViewController.h"
#import "FFWebViewController.h"

#define CELL_IDE @"FFCustomizeCell"
#define BTNTAG 1300



@interface FFRecommentController ()

@property (nonatomic, strong) FFRecommentModel *model;




@end

@implementation FFRecommentController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)initDataSource {
    [super initDataSource];
    _collectionArray = @[@"新游",@"满V",@"活动",@"分类"];
    _collectionImage = @[@"New_recomment_rebate",@"New_recomment_activity",@"New_recomment_package",@"New_recomment_hightvip"];

    NSArray<NSString *> *controllerName = @[@"FFNewGameController",
                                            @"FFRHeightVipViewController",
                                            @"FFRActivityViewController",
                                            @"FFClassifyController"];

    _childControllers = [NSMutableArray arrayWithCapacity:controllerName.count];
    for (NSString *vcName in controllerName) {
        Class ViewController = NSClassFromString(vcName);
        id vc = [[ViewController alloc] init];
        if (vc != nil) {
            [_childControllers addObject:vc];
        } else {
            printf("%s error :  View Controller does not exist",__func__);
            [_childControllers addObject:[UIViewController new]];
        }
    }
    //刷新视图
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

- (void)refreshNewData {
    WeakSelf;
    [self.model loadNewRecommentGameWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            weakSelf.carouselView.rollingArray = content[@"data"][@"banner"];
            weakSelf.showArray = [content[@"data"][@"gamelist"] mutableCopy];
            [weakSelf.tableView reloadData];
        } else {

        }

        if (weakSelf.showArray && weakSelf.showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        if (self.carouselView.rollingArray.count > 0) {
            weakSelf.tableView.tableHeaderView = weakSelf.carouselView;
        } else {
            weakSelf.tableView.tableHeaderView = nil;
        }

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    WeakSelf;
    [self.model loadMoreRecommentGameWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSMutableArray *array = [content[@"data"][@"gamelist"] mutableCopy];
            if (array.count == 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.showArray addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }

        if (weakSelf.showArray && weakSelf.showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

    }];
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.showArray && self.showArray.count != 0) {
        return kSCREEN_WIDTH * 0.218 + 4;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.218 + 10)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:self.collectionView];
    return view;
}

#pragma mark - collection deleegate And dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FFRecommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FFRecommentCollectionCell" forIndexPath:indexPath];

    cell.titleLabel.text = _collectionArray[indexPath.item];

    cell.titleImage.image = [UIImage imageNamed:_collectionImage[indexPath.item]];


    return cell;

}
#pragma mark - collection cell did select
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _childControllers.count) {
        return;
    }

    HIDE_PARNENT_TABBAR;
    if (indexPath.row == 0 && SSKEYCHAIN_UID == nil) {
        FFLoginViewController *login = [[FFLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        SHOW_PARNENT_TABBAR;
        return;
    }

    [self.navigationController pushViewController:_childControllers[indexPath.row] animated:YES];
    SHOW_PARNENT_TABBAR;
}

#pragma mark - carouselView image did select
- (void)FFRecommentCarouselView:(FFRecommentCarouselView *)view didSelectImageWithInfo:(NSDictionary *)info {
    syLog(@"CarouselView dict = %@",info);
    NSString *type = info[@"type"];
    if (type.integerValue == 1) {
        HIDE_TABBAR;
        HIDE_PARNENT_TABBAR;
        [FFGameViewController sharedController].gameID = info[@"gid"];
        [FFGameViewController sharedController].gameLogo = nil;
        [self.navigationController pushViewController:[FFGameViewController sharedController] animated:YES];
        SHOW_TABBAR;
        SHOW_PARNENT_TABBAR;
    } else {
        HIDE_PARNENT_TABBAR;
        HIDE_TABBAR;
        FFWebViewController *webView = [FFWebViewController new];
        [webView setWebURL:info[@"url"]];
        [self.navigationController pushViewController:webView animated:YES];
        SHOW_PARNENT_TABBAR;
        SHOW_TABBAR;
    }
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


/** 中间4个按钮 */
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        CGFloat item_width = (_collectionArray.count > 0) ? (kSCREEN_WIDTH / _collectionArray.count) : (kSCREEN_WIDTH / 4);
        layout.itemSize = CGSizeMake(item_width, kSCREEN_WIDTH * 0.218 - 2);

        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;


        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 2, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.218) collectionViewLayout:layout];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        [_collectionView registerClass:[FFRecommentCollectionCell class] forCellWithReuseIdentifier:@"FFRecommentCollectionCell"];

        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (FFRecommentModel *)model {
    if (!_model) {
        _model = [[FFRecommentModel alloc] init];
    }
    return _model;
}


@end






















