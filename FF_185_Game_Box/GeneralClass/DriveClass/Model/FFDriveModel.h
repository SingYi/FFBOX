//
//  FFDriveModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

typedef enum : NSUInteger {
    hotDynamic = 1,
    allDynamic,
    throughDynamic,
    attentionDynamic
} DynamicType;

typedef enum : NSUInteger {
    dislike = 0,
    like
} LikeOrDislike;

typedef enum : NSUInteger {
    timeType = 1,
    hotType
} CommentType;

typedef void (^CompleteBlock)(NSDictionary *content, BOOL success);



@interface FFDriveModel : FFBasicModel

/** 发状态 */
+ (void)postDynamicWith:(NSString *)content Images:(NSArray *)imgs Complete:(CompleteBlock)completion;


/** get dynamic */
+ (void)getDynamicWithType:(DynamicType)type Page:(NSString *)page Complete:(CompleteBlock)completion;


/** 发布动态 */
+ (void)userUploadPortraitWithContent:(NSString *)content
                                Image:(NSArray *)images
                           Completion:(CompleteBlock)completion;

/** 赞或者踩 */
+ (void)userLikeOrDislikeWithDynamicsID:(NSString *)dynamics_id
                                   type:(LikeOrDislike)type
                               Complete:(CompleteBlock)completion;

/** 请求评论(请求动态详情) */
+ (void)userComeentListWithDynamicsID:(NSString *)dynamicsID
                                 type:(CommentType)type
                                 page:(NSString *)page
                             Complete:(CompleteBlock)completion;

/** 发送评论 */
+ (void)userSendCommentWithjDynamicsID:(NSString *)dynamicsID
                                 ToUid:(NSString *)toUid
                               Comment:(NSString *)comment
                              Complete:(CompleteBlock)completion;


@end













