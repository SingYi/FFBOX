//
//  FFDriveMineViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveMineViewController.h"
#import "SYKeychain.h"

#import "FFSelectHeaderView.h"
#import "FFDrivePersonalHeader.h"
#import "FFMineViewCell.h"

#import "UINavigationController+Cloudox.h"
#import "UIViewController+Cloudox.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import "FFDriveDetailInfoViewController.h"

@interface FFTestTableViewController : UITableView

@end

@implementation FFTestTableViewController

//允许同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end


@interface FFDriveMineViewController ()<UITableViewDelegate, UITableViewDataSource, FFSelectHeaderViewDelegate, FFDriveDetailDelegate>

@property (nonatomic, strong) FFTestTableViewController *tableView;
@property (nonatomic, strong) FFSelectHeaderView *selectHeaderView;

@property (nonatomic, strong) FFDrivePersonalHeader *tableHeaderView;

@property (nonatomic, strong) NSMutableArray *selectHeaderTitleArray;


@property (nonatomic, assign) BOOL canScroll;
//pageViewController
@property (strong, nonatomic) FFMineViewCell *contentCell;

//导航栏的背景view
@property (strong, nonatomic) UIImageView *barImageView;


//编辑按钮
@property (nonatomic, strong) UIBarButtonItem *editButton;

@property (nonatomic, strong) FFDriveDetailInfoViewController *detailController;


@end

@implementation FFDriveMineViewController {
    NSString *controller_nick_name;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

    self.canScroll = YES;
    self.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.barImageView = self.navigationController.navigationBar.subviews.firstObject;
    self.barImageView.alpha = 0;
    
    [self addSubViews];
}

- (void)addSubViews {
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    self.selectHeaderTitleArray = [@[@"开车数",@"粉丝",@"关注"] mutableCopy];

    //通知的处理，本来也不需要这么多通知，只是写一个简单的demo，所以...根据项目实际情况进行优化吧
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageViewCtrlChange:) name:@"CenterPageViewScroll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScrollBottomView:) name:@"PageViewGestureState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailController:) name:@"pushDetailController" object:nil];

    self.tableView.showsVerticalScrollIndicator = NO;
    [FFMineViewCell registCellWithTableView:self.tableView];

}

//通知的处理
//pageViewController页面变动时的通知
- (void)onPageViewCtrlChange:(NSNotification *)ntf {
    [self.selectHeaderView setSelectTitleIndex:[ntf.object integerValue]];
}

//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    self.canScroll = YES;
    self.contentCell.canScroll = NO;
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

//推送详细页面;
- (void)pushDetailController:(NSNotification *)ntf {
    syLog(@"退出通知");
    NSDictionary *dict = ntf.userInfo;
    self.detailController.dict = dict;
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:self.detailController animated:YES];
}


#pragma mark - tableview dele gate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentCell.buid = self.uid;
    [self.contentCell setPageView];
    return self.contentCell;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //计算导航栏的透明度
    CGFloat offset = scrollView.contentOffset.y;
//    syLog(@"offset === %lf",offset);
    //计算导航栏的透明度
    CGFloat minAlphaOffset = 20;
    CGFloat maxAlphaOffset = (self.tableHeaderView.bounds.size.height - kNAVIGATION_HEIGHT);
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    //根据导航栏透明度设置title
    (alpha > 1) ? (alpha = 1) : ((alpha < 0) ? (alpha = 0) : alpha);
    self.navBarBgAlpha = [NSString stringWithFormat:@"%.2lf",alpha];
    if (alpha > 0.5) {
        self.navigationItem.title = controller_nick_name;
        [self.tableHeaderView hideNickName:YES];
    } else {
        self.navigationItem.title = @"";
        [self.tableHeaderView hideNickName:NO];
    }

    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y - kNAVIGATION_HEIGHT;
    if (scrollView.contentOffset.y >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (_canScroll) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kScrollToTopNtf" object:@1];
            _canScroll = NO;
            FFMineViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.canScroll = YES;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }
}

#pragma mark - respodns
- (void)respondsToEditButton {
    syLog(@"编辑个人信息");
}

- (void)refreshNewData {
    syLog(@"刷新");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [hud hideAnimated:YES];
    });
}

#pragma mark - setter
- (void)setSelectHeaderTitleArray:(NSMutableArray *)selectHeaderTitleArray {
    _selectHeaderTitleArray = selectHeaderTitleArray;
    self.selectHeaderView.headerTitleArray = selectHeaderTitleArray;
}

- (void)setDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        _dict = dict;
    } else {
        _dict = nil;
    }

    self.tableHeaderView.dict = _dict;
    //
    [self setNickName];
}

- (void)setIconImage:(UIImage *)iconImage {
    self.tableHeaderView.iconImage = iconImage;
}

- (void)setUid:(NSString *)uid {
    _uid = uid;
    if ([uid isEqualToString:SSKEYCHAIN_UID]) {
        self.navigationItem.rightBarButtonItem = self.editButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.contentCell.buid = _uid;
}

- (void)setNickName {
    controller_nick_name = self.tableHeaderView.nickName;
}


#pragma mark - select header delegate
- (void)FFSelectHeaderView:(FFSelectHeaderView *)view didSelectTitleWithIndex:(NSUInteger)idx {


    self.contentCell.selectIndex = idx;
}


#pragma mark - getter
- (FFTestTableViewController *)tableView {
    if (!_tableView) {
        _tableView = [[FFTestTableViewController alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        [FFMineViewCell registCellWithTableView:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        MJRefreshNormalHeader *customRefreshHeader = [[MJRefreshNormalHeader alloc] init];
        [customRefreshHeader setRefreshingTarget:self];

        //自动更改透明度
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_header = customRefreshHeader;

        [customRefreshHeader setTitle:@"数据已加载" forState:MJRefreshStateIdle];
        [customRefreshHeader setTitle:@"刷新数据" forState:MJRefreshStatePulling];
        [customRefreshHeader setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        [customRefreshHeader setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
        [customRefreshHeader setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];

        [customRefreshHeader.lastUpdatedTimeLabel setText:@"0"];

        //下拉刷新
        [customRefreshHeader setRefreshingAction:@selector(refreshNewData)];
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

- (FFDrivePersonalHeader *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[FFDrivePersonalHeader alloc] init];
    }
    return _tableHeaderView;
}

- (UIBarButtonItem *)editButton {
    if (!_editButton) {
        _editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToEditButton)];
    }
    return _editButton;
}

- (FFMineViewCell *)contentCell {
    if (!_contentCell) {
        _contentCell = [FFMineViewCell dequeueReusableCellWithIdentifierWithTableView:self.tableView];
    }
    return _contentCell;
}


- (FFDriveDetailInfoViewController *)detailController {
    if (!_detailController) {
        _detailController = [[FFDriveDetailInfoViewController alloc] init];
        _detailController.delegate = self.contentCell.numbersViewController;
    }
    return _detailController;
}


@end

