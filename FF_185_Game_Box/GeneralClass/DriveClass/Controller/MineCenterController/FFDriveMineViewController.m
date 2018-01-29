//
//  FFDriveMineViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveMineViewController.h"
#import "FFSelectHeaderView.h"
#import "FFMineViewCell.h"

#import "UINavigationController+Cloudox.h"
#import "UIViewController+Cloudox.h"

@interface FFDriveMineViewController ()<UITableViewDelegate, UITableViewDataSource, FFSelectHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FFSelectHeaderView *selectHeaderView;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) NSMutableArray *selectHeaderTitleArray;
//YES代表能滑动
@property (nonatomic, assign) BOOL canScroll;

//导航栏的背景view
@property (strong, nonatomic) UIImageView *barImageView;


@end

@implementation FFDriveMineViewController {
    UIImage *changeImage;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"0.0";

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}



- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self addSubViews];
}

- (void)addSubViews {
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    self.selectHeaderTitleArray = [@[@"开车数",@"粉丝",@"关注"] mutableCopy];
//    [self setFchildControllerWithClassNames:@[@"FFDriveAllInfoViewController",
//                                              @"FFDriveHotInfoViewController",
//                                              @"FFDriveAttentionInfoViewController"]];

    //通知的处理，本来也不需要这么多通知，只是写一个简单的demo，所以...根据项目实际情况进行优化吧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageViewCtrlChange:) name:@"CenterPageViewScroll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScrollBottomView:) name:@"PageViewGestureState" object:nil];
}

///通知的处理
//pageViewController页面变动时的通知
- (void)onPageViewCtrlChange:(NSNotification *)ntf {
    //更改YUSegment选中目标
//    self.segment.selectedIndex = [ntf.object integerValue];
}

//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    syLog(@"?");
    FFMineViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.canScroll = YES;
    cell.canScroll = NO;
}

//当滑动下面的PageView时，当前要禁止滑动
- (void)onScrollBottomView:(NSNotification *)ntf {
    if ([ntf.object isEqualToString:@"ended"]) {
        //bottomView停止滑动了  当前页可以滑动
        self.tableView.scrollEnabled = YES;
    } else {
        //bottomView滑动了 当前页就禁止滑动
        self.tableView.scrollEnabled = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

#pragma mark - tableview dele gate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFMineViewCell *cell = [FFMineViewCell dequeueReusableCellWithIdentifierWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.canScroll = YES;
    [cell setPageView];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height - kNAVIGATION_HEIGHT - CGRectGetHeight(self.tabBarController.tabBar.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.selectHeaderView;
}

#pragma mark - setter
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //计算导航栏的透明度
    CGFloat offset = scrollView.contentOffset.y;
    syLog(@"offset === %lf",offset);

    if (offset > self.tableHeaderView.frame.size.height - 64) {
        self.title = @"name";
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        } else {

        }
        self.navBarBgAlpha = @"1.0";
    } else {
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {

        }
        self.navBarBgAlpha = @"0.0";
        self.title = @"?????";
    }

    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y-64;
    if (scrollView.contentOffset.y >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (_canScroll) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kScrollToTopNtf" object:@1];
//            _canScroll = NO;
//            FFMineViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            cell.canScroll = YES;
        }
    } else {
//        if (!_canScroll) {
//            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
//        }
    }

}

- (void)setSelectHeaderTitleArray:(NSMutableArray *)selectHeaderTitleArray {
    _selectHeaderTitleArray = selectHeaderTitleArray;
    self.selectHeaderView.headerTitleArray = selectHeaderTitleArray;
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        [FFMineViewCell registCellWithTableView:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {

        }
    }
    return _tableView;
}
- (FFSelectHeaderView *)selectHeaderView {
    if (!_selectHeaderView) {
        _selectHeaderView = [[FFSelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
        _selectHeaderView.delegate = self;
        _selectHeaderView.lineColor = [UIColor colorWithWhite:0.95 alpha:1];
        _selectHeaderView.backgroundColor = [UIColor whiteColor];

    }
    return _selectHeaderView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        _tableHeaderView.backgroundColor = [UIColor orangeColor];
    }
    return _tableHeaderView;
}


@end
