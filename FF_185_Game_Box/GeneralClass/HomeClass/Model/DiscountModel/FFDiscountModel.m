//
//  FFDiscountModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/5/3.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDiscountModel.h"
#import "FFMapModel.h"

@implementation FFDiscountModel

+ (void)discountGameWithPage:(NSString *)page Completion:(DiscountCompletionBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //页数
    [dict setObject:page forKey:@"page"];
    //渠道ID
    [dict setObject:Channel forKey:@"channel"];
    //游戏平台: 1为bt服, 2为折扣服
    [dict setObject:@"2" forKey:@"platform"];
    //设备ID
    [dict setObject:@"2" forKey:@"system"];

    [self postRequestWithURL:[FFMapModel map].GAME_INDEX params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

@end
