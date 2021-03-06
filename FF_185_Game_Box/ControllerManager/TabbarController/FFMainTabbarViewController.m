//
//  FFMainTabbarViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMainTabbarViewController.h"
#import "FFCustomizeTabBar.h"
#import "FFInviteFriendViewController.h"
#import "FFLoginViewController.h"
//#import "ZCNavigationController+Smoonth.h"


@interface FFMainTabbarViewController () <FFCustomizeTabbarDelegate>



@end

@implementation FFMainTabbarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeUserInterface];
        [self initializeDataSource];
    }
    return self;
}

- (void)initializeUserInterface {
    FFCustomizeTabBar *tabbar = [[FFCustomizeTabBar alloc] init];
    tabbar.customizeDelegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
}

- (void)initializeDataSource {
//    NSArray *viewControllerNames = @[@"FFHomeViewController", @"FFOpenServerViewController", @"FFDriveController", @"FFNewMineViewController"];
    //    NSArray *titles = @[@"游戏", @"开服表", @"开车", @"我的"];
    NSArray *viewControllerNames = @[@"FFHomeViewController", @"FFRankListViewController", @"FFOpenServerViewController", @"FFNewMineViewController"];
    NSArray *titles = @[@"游戏", @"排行榜", @"开服表", @"我的"];

    NSArray *images = @[@"d_youxi_an", @"b_paihangbang_an-", @"a_libao_an", @"c_wode_an"];
    NSArray *selectImages = @[@"d_youxi_liang", @"b_paihangbang_liang", @"a_libao_liang", @"c_wode_liang"];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:4];

    [viewControllerNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = nil;

        Class classname = NSClassFromString(obj);
        viewController = [[classname alloc] init];

//        viewController = [[UIViewController alloc] init];

//        FFNavigationController *nav = [[FFNavigationController alloc] initWithRootViewController:viewController];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        //设置title
        viewController.navigationItem.title = titles[idx];
        viewController.navigationController.tabBarItem.title = titles[idx];

        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[idx] image:[[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVGATION_BAR_COLOR} forState:UIControlStateSelected];


        [viewControllers addObject:nav];

    }];
    self.viewControllers = viewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - delegate
- (void)CustomizeTabBar:(FFCustomizeTabBar *)tabBar didSelectCenterButton:(id)sender {
    syLog(@"tabbar click center button");
    UINavigationController *nav = (UINavigationController *)self.selectedViewController;
    nav.childViewControllers[0].hidesBottomBarWhenPushed = YES;
    FFInviteFriendViewController *vc = [FFInviteFriendViewController new];
    if ([vc initDataSource]) {
        [nav pushViewController:[FFInviteFriendViewController new] animated:YES];
    } else{
        [nav pushViewController:[FFLoginViewController new] animated:YES];
    }
    nav.childViewControllers[0].hidesBottomBarWhenPushed = NO;
}

#pragma mark - getter












@end















