//
//  FFOpenServerModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFOpenServerModel.h"
#import "FFMapModel.h"

@implementation FFOpenServerModel

/** 单一游戏开服 */
+ (void)gameServerOpenWithGameID:(NSString *)gameID Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSDictionary *dict = @{@"gid":gameID};
    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_OPEN_SERVER params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


/** 开服列表 */
- (void)openGameServerWithType:(NSString *)serviceTye Page:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:serviceTye forKey:@"type"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:page forKey:@"page"];

    [FFMapModel postRequestWithURL:[FFMapModel map].OPEN_SERVER  params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

- (void)loadNewOpenServerWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage = 1;
    [self openGameServerWithType:self.serverType Page:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}

- (void)loadMoreOpenServerWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage++;
    [self openGameServerWithType:self.serverType Page:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}









@end
