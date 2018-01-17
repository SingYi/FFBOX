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


typedef void (^CompleteBlock)(NSDictionary *content, BOOL success);



@interface FFDriveModel : FFBasicModel

/** 发状态 */
+ (void)postDynamicWith:(NSString *)content Images:(NSArray *)imgs Complete:(CompleteBlock)completion;


/** get dynamic */
+ (void)getDynamicWithType:(DynamicType)type Page:(NSString *)page Complete:(CompleteBlock)completion;



+ (void)userUploadPortraitWithContent:(NSString *)content
                                Image:(NSArray *)images
                           Completion:(CompleteBlock)completion;



@end













