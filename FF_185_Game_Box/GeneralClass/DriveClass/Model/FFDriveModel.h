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
    like,
    dislike,
} LikeOrDislike;


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

@end













