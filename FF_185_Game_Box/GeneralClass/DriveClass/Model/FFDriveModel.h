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
    attentionDynamic,
    CheckUserDynamic
} DynamicType;

typedef enum : NSUInteger {
    dislike = 0,
    like
} LikeOrDislike;

typedef enum : NSUInteger {
    timeType = 1,
    hotType
} CommentType;

typedef enum : NSUInteger {
    attention = 1,
    cancel
} AttentionType;

typedef enum : NSUInteger {
    myAttention = 1,
    myFans
} FansOrAttention;

typedef void (^CompleteBlock)(NSDictionary *content, BOOL success);



@interface FFDriveModel : FFBasicModel

/** 发状态 */
//+ (void)postDynamicWith:(NSString *)content Images:(NSArray *)imgs Complete:(CompleteBlock)completion;


/** get dynamic */
+ (void)getDynamicWithType:(DynamicType)type Page:(NSString *)page CheckUid:(NSString *)buid Complete:(CompleteBlock)completion;


/** 发布动态 */
+ (void)userUploadPortraitWithContent:(NSString *)content
                                Image:(NSArray *)images
                           Completion:(CompleteBlock)completion;

/** 赞或者踩动态 */
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

/** 赞或者踩评论 */
+ (void)userLikeOrDislikeComment:(NSString *)comment_id
                            Type:(LikeOrDislike)type
                        Complete:(CompleteBlock)completion;

/** 删除评论 */
+ (void)userDeleteCommentWith:(NSString *)comment_id
                     Complete:(CompleteBlock)completion;

/** 关注用户 */
+ (void)userAttentionWith:(NSString *)attentionUid
                     Type:(AttentionType)type
                 Complete:(CompleteBlock)completion;

/** 分享动态 */
+ (void)userSharedDynamics:(NSString *)Dynamics
                  Complete:(CompleteBlock)completion;

/** 关注 / 粉丝*/
+ (void)userFansAndAttettionWithPage:(NSString *)page
                                Type:(FansOrAttention)type
                            Complete:(CompleteBlock)completion;


@end













