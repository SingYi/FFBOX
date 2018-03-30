//
//  FFPackageModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/14.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

typedef void (^Completion)(NSDictionary *content, BOOL success);

@interface FFPackageModel : FFBasicModel

/** 请求新数据列表 */
- (void)loadNewPackageWithCompletion:(void (^)(NSDictionary *content, BOOL success))completion;
/** 加载更多礼包 */
- (void)loadMorePackageWithCompletion:(void (^)(NSDictionary *content, BOOL success))completion;

/** 领取礼包 */
- (void)getPackageWithGiftID:(NSString *)pid Completion:(void (^)(NSDictionary * content, BOOL success))completion;
/** 获取礼包也轮播图 */
+ (void)packageBannerWithCompletion:(void (^)(NSDictionary *content, BOOL success))completion;
/** 搜索礼包 */
+ (void)searchPackageWith:(NSString *)name Completion:(void (^)(NSDictionary *content, BOOL success))completion;
/** 获取游戏礼包 */
+ (void)packageWithGameID:(NSString *)gameID Completion:(void (^)(NSDictionary *content, BOOL success))completion;

/** 我的礼包 */
+ (void)userPackageListWithPage:(NSString *)page Completion:(Completion)completion;

/** 礼包详情 */
+ (void)getPackageDetailInfoWithID:(NSString *)pid Completion:(Completion)completion;





@end
