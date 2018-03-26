//
//  FFRaidersModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFRaidersModel.h"
#import "FFMapModel.h"

@implementation FFRaidersModel

+ (void)getRaidersWithPage:(NSString *)page Completion:(MCompletionBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:Channel forKey:@"channel_id"];
    if (page) {
        [dict setObject:page forKey:@"page"];
    } else {
        [dict setObject:@"1" forKey:@"page"];
    }
    [FFBasicModel postRequestWithURL:[FFMapModel map].INDEX_ARTICLE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


@end
