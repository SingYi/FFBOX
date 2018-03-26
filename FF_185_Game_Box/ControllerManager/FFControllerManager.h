//
//  FFControllerMagager.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMainTabbarViewController.h"

@interface FFControllerManager : NSObject

@property (nonatomic, strong) UINavigationController *rootViewController;

@property (nonatomic, strong) FFMainTabbarViewController *tabBarController;



+ (FFControllerManager *)sharedManager;



@end
