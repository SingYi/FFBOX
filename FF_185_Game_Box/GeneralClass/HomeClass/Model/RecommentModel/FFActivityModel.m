//
//  FFActivityModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/6.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFActivityModel.h"
#import "FFMapModel.h"

@implementation FFActivityModel

- (void)loadNewActivityWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage = 1;
    [self activityWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}

- (void)loadMoreActivityWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage++;
    syLog(@"page == %ld", self.currentPage);
    [self activityWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}


/** 活动 */
- (void)activityWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:page forKey:@"page"];

    [FFActivityModel postRequestWithURL:[FFMapModel map].INDEX_ARTICLE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

@end
