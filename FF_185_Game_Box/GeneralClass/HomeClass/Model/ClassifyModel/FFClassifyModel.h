//
//  FFClassifyModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

@interface FFClassifyModel : FFBasicModel

@property (nonatomic, strong) NSString *platform;

/** 刷新页面 */
- (void)loadNewClassifyWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;


/** 加载更多 */
- (void)loadMoreClassifyWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;


/** 分类详情 */
+ (void)ClassifyWithID:(NSString *)classifyID
              Platform:(NSString *)platform
                  Page:(NSString *)page
            Completion:(void (^)(NSDictionary *, BOOL))completion;

@end
