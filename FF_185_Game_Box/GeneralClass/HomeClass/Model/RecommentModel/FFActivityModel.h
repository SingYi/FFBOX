//
//  FFActivityModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/6.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

@interface FFActivityModel : FFBasicModel

- (void)loadNewActivityWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

- (void)loadMoreActivityWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

@end
