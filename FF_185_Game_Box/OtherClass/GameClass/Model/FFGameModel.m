//
//  FFGameModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/15.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameModel.h"
#import "FFMapModel.h"


@implementation FFGameModel


/** 游戏详情 */
+ (void)gameInfoWithGameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:gameID forKey:@"gid"];

    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }

    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:Channel forKey:@"channel"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_INFO params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 游戏相关攻略 */
+ (void)raidersWithGameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary *, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:@"1" forKey:@"page"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_GONGLUE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 收藏接口 type = 1 收藏  type = 2 取消*/
+ (void)gameCollectWithType:(NSString *)type GameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:type forKey:@"type"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:gameID forKey:@"gid"];
    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }

    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_COLLECT params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

+ (void)writeCommentGetCoinComoletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:BOX_SIGN(dict, @[@"uid"]) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_COIN params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}




@end
