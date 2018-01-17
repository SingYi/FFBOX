//
//  FFGameModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/15.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

@interface FFGameModel : FFBasicModel

/** 游戏详情接口 */
+ (void)gameInfoWithGameID:(NSString * )gameID Comoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 游戏相关攻略 */
+ (void)raidersWithGameID:(NSString *)gameID Comoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 收藏接口 type = 1 收藏  type = 2 取消*/
+ (void)gameCollectWithType:(NSString *)type GameID:(NSString *)gameID Comoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 评论获取金币 */
+ (void)writeCommentGetCoinComoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 子渠道下载 */
+ (void)gameDownloadWithTag:(NSString *)gameTag Comoletion:(void(^)(NSDictionary *  content, BOOL success))completion;


@end
