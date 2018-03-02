//
//  FFControllerMagager.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFControllerManager.h"

@interface FFControllerManager () 


@end

static FFControllerManager *manager = nil;

@implementation FFControllerManager

+ (FFControllerManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[FFControllerManager alloc] init];
        }
    });
    return manager;
}


#pragma mark - getter
- (UINavigationController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
        _rootViewController.navigationBar.hidden = YES;
        _rootViewController.navigationBar.barStyle = UIBarStyleBlack;
        _rootViewController.navigationBar.backgroundColor = [UIColor blackColor];
        _rootViewController.navigationBar.tintColor = [UIColor whiteColor];
    }
    return _rootViewController;
}

- (FFMainTabbarViewController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [[FFMainTabbarViewController alloc] init];
    }
    return _tabBarController;
}






@end






