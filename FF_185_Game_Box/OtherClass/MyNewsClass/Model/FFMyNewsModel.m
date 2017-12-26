//
//  FFMyNewsModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMyNewsModel.h"
#import "ChangyanSDK.h"
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
    [ChangyanSDK getUserNewReply:@"15" pageNo:page completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {

        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//        syLog(@"dict =====  %@",dict);
        if (statusCode == 0) {
            if (completeBlock) {
                completeBlock(dict,YES);
            }
        } else {
            if (completeBlock) {
                completeBlock(nil,NO);
            }
        }
    }];
}

/** dic[@"topic_id"] */
+ (void)ReplyToComment:(NSString *)topicID
               content:(NSString *)content
               replyID:(NSString *)replyID
         completeBlock:(FFCompleteBlock)completeBlock {

    [ChangyanSDK submitComment:topicID content:content replyID:replyID score:nil appType:40 picUrls:@[] metadata:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {

        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

        if (statusCode == 0) {
            if (completeBlock) {
                completeBlock(dict, YES);
            }
        } else {
            if (completeBlock) {
                completeBlock(dict, NO);
            }
        }
    }];
}

/*
 *  功能 : 提交评论或者回复某条评论
 *  参数 :
 *        topicID       : 要评论的话题ID(必须)
 *        content       : 评论内容(必须)
 *        replyID       : (可填, 若为评论回复则必须传被回复评论的ID)
 *        score         : 评分（可选，若不打分请传nil）
 *        appType       : 40:iPhone 41:iPad 42:Android
 *        picUrls       : 附带图片URL数组,url不能包含","
 *        metadata      : 附加信息 (可选,若有附加信息,在数据中会原样返回)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)submitComment:(NSString *)topicID
              content:(NSString *)content
              replyID:(NSString *)replyID
                score:(NSString *)score
              appType:(NSInteger )appType
              picUrls:(NSArray *)picUrls
             metadata:(NSString *)metadata
        completeBlock:(CompleteBlock)completeBlock {

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
















