//
//  FFGameDetailViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FFGameDetailViewController : UIViewController

/** 游戏ID */
@property (nonatomic, strong) NSString *gameID;

@property (nonatomic, strong) NSDictionary *gameContent;

/** 评论数组 */
@property (nonatomic, strong) NSArray *commentArray;

@property (nonatomic, strong) NSString *topic_id;

/** 返回顶部 */
- (void)goToTop;

@end
