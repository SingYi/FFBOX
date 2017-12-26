//
//  FFOpenServerModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

@interface FFOpenServerModel : FFBasicModel

@property (nonatomic, strong) NSString *serverType; // 1.今日开服, 2.即将开服 3.已经开服


- (void)loadNewOpenServerWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

- (void)loadMoreOpenServerWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 单一游戏开服 */
+ (void)gameServerOpenWithGameID:(NSString *)gameID Completion:(void (^)(NSDictionary * content, BOOL success))completion;



@end
