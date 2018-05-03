//
//  FFRankListModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRankListModel.h"
#import "FFMapModel.h"

#define MAP_URL [FFMapModel map]

@implementation FFRankListModel


- (void)loadNewRankListWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    self.currentPage = 1;
    [self rankGameListWithPage:[NSString stringWithFormat:@"%ld",self.currentPage] Completion:completion];
}

- (void)loadMoreRankListWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    WeakSelf;
    weakSelf.currentPage++;
    [weakSelf rankGameListWithPage:[NSString stringWithFormat:@"%ld",weakSelf.currentPage] Completion:completion];
}


- (void)rankGameListWithPage:(NSString *)page Completion:(void (^)(NSDictionary * content, BOOL success))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //页数
    [dict setObject:page forKey:@"page"];
    //渠道
    [dict setObject:Channel forKey:@"channel"];
    //系统
    [dict setObject:@"2" forKey:@"system"];

    [dict setObject:self.discount forKey:@"platform"];
    //游戏类型
    [dict setObject:self.gameType forKey:@"type"];

//    syLog(@"dicgt ===- %@",dict);

    [FFRankListModel postRequestWithURL:[FFMapModel map].GAME_TYPE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];

}


#pragma mark -
- (NSString *)discount {
    if (!_discount) {
        _discount = @"1";
    }
    return _discount;
}

@end
