//
//  FFRankListViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicViewController.h"

@interface FFRankListViewController : FFBasicViewController


- (void)setGameType:(NSString *)gameType;

/** 1 -> bt服务器 2 -> 折扣服 */
- (void)setGameDiscCount:(NSString *)discount;


- (void)tableViewBegainRefreshData;



@end
