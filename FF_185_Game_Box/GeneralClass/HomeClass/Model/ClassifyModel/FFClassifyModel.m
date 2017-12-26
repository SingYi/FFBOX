//
//  FFClassifyModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFClassifyModel.h"
#import "FFMapModel.h"

@implementation FFClassifyModel

/** 游戏分类 */
- (void)gameClassifyWithPage:(NSString *)page Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"channel"];

    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:page forKey:@"page"];

    [FFClassifyModel postRequestWithURL:[FFMapModel map].GAME_CLASS params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


- (void)loadNewClassifyWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage = 1;
    [self gameClassifyWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Comoletion:completion];
}

- (void)loadMoreClassifyWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage++;
    [self gameClassifyWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Comoletion:completion];
}


/** 分类详情 */
+ (void)ClassifyWithID:(NSString *)classifyID
                  Page:(NSString *)page
            Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:classifyID forKey:@"classId"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:page forKey:@"page"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_CLASS_INFO params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}








@end
