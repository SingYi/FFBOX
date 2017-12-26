//
//  FFRankListModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

@interface FFRankListModel : FFBasicModel

@property (nonatomic, strong) NSString *gameType;

/** 刷新页面 */
- (void)loadNewRankListWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;


/** 加载更多 */
- (void)loadMoreRankListWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;


- (void)rankGameListWithPage:(NSString *)page Completion:(void (^)(NSDictionary * content, BOOL success))completion;





@end
