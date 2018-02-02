//
//  FFStatisticsModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/2.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFStatisticsModel.h"
#import "TrackingIO.h"

#define TrackingIOID @"ffcaffb5979b3df9ff12751857fc88fa"
#define TrackingIOToken @"506D348071C391675943F5754F6AF056"


@implementation FFStatisticsModel

/** 注册统计 */
+ (void)reigstStatics {
    [TrackingIO initWithappKey:TrackingIOID withChannelId:TrackingIOToken];
    syLog(@"注册统计 !!!!!!!!!!!!!!!!!!11");
}



@end
