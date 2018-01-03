//
//  FFPayModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFPayModel.h"
#import "FFMapModel.h"
#import "FFUserModel.h"

#define MAP_URL [FFMapModel map]

static FFPayModel *model = nil;

@implementation FFPayModel


+ (FFPayModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFPayModel alloc] init];
        }
    });
    return model;
}

/** 准备支付 */
+ (void)payReadyWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSArray *pamarasKey = @[@"appid",@"uid"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:AppID forKey:@"appid"];
    if (SSKEYCHAIN_UID) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    }
    [dict setObject:BOX_SIGN(dict, pamarasKey) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:MAP_URL.PAY_READY params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 开始支付 */
+ (void)payStartWithproductID:(NSString *)productID
                      payType:(NSString *)payType
                       amount:(NSString *)amount
                   Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"deviceType",@"appid",@"channel",@"uid",
                            @"serverID",@"serverNAME",@"roleID",@"roleNAME",
                            @"productID",@"productNAME",@"payType",@"payMode",
                            @"cardID",@"cardPass",@"cardMoney",@"amount",
                            @"extend"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"2" forKey:@"deviceType"];
    [dict setObject:AppID forKey:@"appid"];
    [dict setObject:Channel forKey:@"channel"];

    if (SSKEYCHAIN_UID) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        return;
    }

    [dict setObject:Channel forKey:@"serverID"];
    [dict setObject:@"游戏盒子" forKey:@"serverNAME"];
    [dict setObject:[FFUserModel currentUser].uid forKey:@"roleID"];
    [dict setObject:[FFUserModel currentUser].username forKey:@"roleNAME"];

    [dict setObject:productID forKey:@"productID"];
    [dict setObject:@"VIP充值" forKey:@"productNAME"];
    [dict setObject:payType forKey:@"payType"];
    [dict setObject:@"3" forKey:@"payMode"];

//    if (!cardID) {
//        cardID = @"";
//    }
    [dict setObject:@"" forKey:@"cardID"];

//    if (!cardPassword) {
//        cardPassword = @"";
//    }
    [dict setObject:@"" forKey:@"cardPass"];

//    if (!cardMoney) {
//        cardMoney = @"";
//    }
    [dict setObject:@"" forKey:@"cardMoney"];

    [dict setObject:amount forKey:@"amount"];

//    if ([extension isEqualToString:@""] || extension == nil) {
//        extension = @"%";
//    }
    [dict setObject:@"vip支付" forKey:@"extend"];

    [dict setObject:BOX_SIGN(dict, pamarasKey) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:MAP_URL.PAY_START params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}




/** 支付查询 */
+ (void)payQueryWithOrderID:(NSString *)orderID
                 Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"orderID"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:orderID forKey:@"orderID"];
    [dict setObject:BOX_SIGN(dict, pamarasKey) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:MAP_URL.PAY_QUERY params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}



@end
