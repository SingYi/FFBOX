//
//  FFDiscountModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/5/3.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

typedef void(^DiscountCompletionBlock)(NSDictionary *content, BOOL success);

@interface FFDiscountModel : FFBasicModel

+ (void)discountGameWithPage:(NSString *)page Completion:(DiscountCompletionBlock)completion;

@end
