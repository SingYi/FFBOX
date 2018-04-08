//
//  FFPackageModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/14.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFPackageModel.h"
#import "FFUserModel.h"
#import "FFMapModel.h"
#import <CommonCrypto/CommonDigest.h>



@implementation FFPackageModel


- (void)loadNewPackageWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage = 1;
    [self packageListWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}

- (void)loadMorePackageWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage++;
    syLog(@"page == %ld", self.currentPage);
    [self packageListWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}


/** 礼包列表接口 */
- (void)packageListWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:page forKey:@"page"];
    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }
    [dict setObject:[FFBasicModel deviceID] forKey:@"device_id"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].PACKS_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


/** 获取礼包接口 */
- (void)getPackageWithGiftID:(NSString *)pid Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    NSString *username = SSKEYCHAIN_USER_NAME;
    if (username == nil) {
        username = @"";
    }

    [dict setObject:username forKey:@"username"];
    [dict setObject:[FFBasicModel DeviceIP] forKey:@"ip"];
    [dict setObject:@"2" forKey:@"terminal_type"];
    [dict setObject:pid forKey:@"pid"];
    [dict setObject:[FFBasicModel deviceID] forKey:@"device_id"];

    NSString *signStr = [NSString stringWithFormat:@"device_id%@ip%@pid%@terminal_type2username%@",[FFBasicModel deviceID],[FFBasicModel DeviceIP],pid,username];


    const char *cstr = [signStr cStringUsingEncoding:NSUTF8StringEncoding];

    NSData *data = [NSData dataWithBytes:cstr length:signStr.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *cha1str = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)

        [cha1str appendFormat:@"%02x", digest[i]];

    NSString *sign = [cha1str uppercaseString];

    [dict setObject:sign forKey:@"sign"];

    [dict setObject:Channel forKey:@"channel_id"];

    syLog(@"领取礼包 dict === %@",dict);

    [FFBasicModel postRequestWithURL:[FFMapModel map].PACKS_LINGQU params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


/** 获取礼包也轮播图 */
+ (void)packageBannerWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    [FFBasicModel postRequestWithURL:[FFMapModel map].PACKS_SLIDE params:@{@"channel_id":Channel} completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 搜索礼包 */
+ (void)searchPackageWith:(NSString *)name Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:name forKey:@"search"];
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:@"1" forKey:@"page"];
    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }
    [dict setObject:DeviceID forKey:@"device_id"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].PACKS_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


/** 游戏相关礼包 */
+ (void)packageWithGameID:(NSString *)gameID Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:@"1" forKey:@"page"];
    [dict setObject:Channel forKey:@"channel_id"];
    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }
    [dict setObject:DeviceID forKey:@"device_id"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_PACK params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 获取用户礼包列表 */
+ (void)userPackageListWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"channel_id"];

    [dict setObject:page forKey:@"page"];

    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }
    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_PACK params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

//加载新礼包


/** 礼包详情 */
+ (void)getPackageDetailInfoWithID:(NSString *)pid Completion:(Completion)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:pid forKey:@"pid"];

    NSString *username = SSKEYCHAIN_USER_NAME;
    if (username == nil) {
        username = @"";
    }
    [dict setObject:username forKey:@"username"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:DeviceID forKey:@"machine_code"];
    [dict setObject:@"2" forKey:@"terminal_type"];
    [dict setObject:@"2" forKey:@"system"];

    [dict setObject:BOX_SIGN(dict, (@[@"pid",@"username",@"channel",@"machine_code",@"terminal_type",@"system"])) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].PACKAGE_INFO params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];


}


@end




