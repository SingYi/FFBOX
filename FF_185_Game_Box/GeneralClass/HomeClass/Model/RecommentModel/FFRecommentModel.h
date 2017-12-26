//
//  FFRecommentModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

@interface FFRecommentModel : FFBasicModel

- (void)loadNewRecommentGameWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

- (void)loadMoreRecommentGameWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;


@end
