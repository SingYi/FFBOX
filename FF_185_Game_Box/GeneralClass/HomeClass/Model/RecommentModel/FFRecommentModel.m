//
//  FFRecommentModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRecommentModel.h"
#import "FFMapModel.h"

@implementation FFRecommentModel

- (void)loadNewRecommentGameWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage = 1;
    [self recommendGameWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}

- (void)loadMoreRecommentGameWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage++;
    [self recommendGameWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}

- (void)recommendGameWithPage:(NSString *)page
                   Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    //页数
    [dict setObject:page forKey:@"page"];
    //渠道ID
    [dict setObject:Channel forKey:@"channel"];
    //游戏平台: 1为bt服, 2为折扣服
    [dict setObject:@"1" forKey:@"platform"];
    //设备ID
    [dict setObject:@"2" forKey:@"system"];

    [FFRecommentModel postRequestWithURL:[FFMapModel map].GAME_INDEX params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}






@end
