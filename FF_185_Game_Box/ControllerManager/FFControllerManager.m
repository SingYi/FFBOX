//
//  FFControllerMagager.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFControllerManager.h"
#import "FFPostStatusModel.h"
#import "UIAlertController+FFAlertController.h"

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


/** init */
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setPostStatusModel];
    }
    return self;
}

#pragma mark - method
- (void)setPostStatusModel {
    [[FFPostStatusModel sharedModel] setCallBackBlock:^(NSDictionary *content, BOOL success) {
        syLog(@"发车返回: %@",content);
        if (success) {
            [UIAlertController showAlertMessage:@"发车成功" dismissTime:0.7 dismissBlock:nil];
//            [UIAlertController showAlertControllerWithViewController:self.rootViewController alertControllerStyle:(UIAlertControllerStyleAlert) title:@"发车成功" message:@"请在我的页面查" cancelButtonTitle:@"确定" destructiveButtonTitle:nil CallBackBlock:nil otherButtonTitles:nil, nil];
        } else {
            [UIAlertController showAlertMessage:[NSString stringWithFormat:@"发车失败 : %@",content[@"msg"]] dismissTime:0.7 dismissBlock:nil];
        }
    }];
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






