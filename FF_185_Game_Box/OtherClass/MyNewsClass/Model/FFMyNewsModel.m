//
//  FFMyNewsModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyNewsModel.h"
#import "FFMapModel.h"
#import "SYKeychain.h"

/**
 CYSuccess           = 0,         成功
 CYParamsError       = 1,         参数错误
 CYLoginError        = 2,         登录错误
 CYOtherError        = 3,         其他错误
 */

@implementation FFMyNewsModel


+ (void)getUserNewsWithPage:(NSString *)page CompleteBlock:(FFCompleteBlock)completeBlock {

}

/** dic[@"topic_id"] */
+ (void)ReplyToComment:(NSString *)topicID
               content:(NSString *)content
               replyID:(NSString *)replyID
         completeBlock:(FFCompleteBlock)completeBlock {

}




/** 消息列表 */
+ (void)systemInfoListWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel"])) forKey:@"sign"];

    [FFMapModel postRequestWithURL:[FFMapModel map].MESSAGE_LIST  params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 消息详情 */
+ (void)messageDetailWithMessageID:(NSString *)user_message_id Completion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:user_message_id forKey:@"user_message_id"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"user_message_id"])) forKey:@"sign"];

    [FFMapModel postRequestWithURL:[FFMapModel map].MESSAGE_INFO  params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


/** 领取奖励 */
+ (void)receiveAwardWithMessAgeId:(NSString *)user_message_id WithUrl:(NSString *)url Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:user_message_id forKey:@"user_message_id"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"user_message_id"])) forKey:@"sign"];

    [FFMapModel postRequestWithURL:url params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)deleteMessageWithMessageID:(NSString *)user_message_id Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:user_message_id forKey:@"user_message_id"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"user_message_id"])) forKey:@"sign"];

    [FFMapModel postRequestWithURL:[FFMapModel map].MESSAGE_DELETE  params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}



@end
















