//
//  FFGameViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFGameViewController : UIViewController

/** 游戏ID */
@property (nonatomic, strong) NSString *gameID;

/** 游戏logo */
@property (nonatomic, strong) UIImage *gameLogo;

/** 游戏名称 */
@property (nonatomic, strong) NSString *gameName;


+ (instancetype)sharedController;


@end
