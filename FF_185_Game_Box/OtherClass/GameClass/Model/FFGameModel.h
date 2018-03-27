//
//  FFGameModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/15.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//


/** Reconstruction by Sans on 2018/03/27
 *  Main purpose : Shared instance For data interaction
 */

#import "FFBasicModel.h"
#import <UIKit/UIKit.h>

#define CURRENT_GAME [FFGameModel CurrentGame]

typedef void(^RefreshCompleteBlock)(BOOL success);
typedef void(^CommentNumberBlock)(NSString *commentNumber);

@interface FFGameModel : FFBasicModel

/** 游戏 ID */
@property (nonatomic, strong) NSString *game_id;
/** 游戏包名 */
@property (nonatomic, strong) NSString *game_bundle_name;
/** 游戏名称 */
@property (nonatomic, strong) NSString *game_name;
/** 游戏大小*/
@property (nonatomic, strong) NSString *game_size;
/** 游戏标签 */
@property (nonatomic, strong) NSString *game_label;
/** 游戏标签数组 */
@property (nonatomic, strong) NSArray<NSString *> *game_label_array;
/** 游戏 logo */
@property (nonatomic, strong) UIImage *game_logo_image;
/** 游戏 logo url */
@property (nonatomic, strong) NSString *game_logo_url;
/** gif url */
@property (nonatomic, strong) NSString *gif_url;
/** gif */
@property (nonatomic, strong) id gif_image;
/** gif model */
@property (nonatomic, strong) NSString *gif_model;
/** image array */
@property (nonatomic, strong) NSArray *showImageArray;
/** 游戏简介 */
@property (nonatomic, strong) NSString *game_introduction;
/** 游戏短简介 */
@property (nonatomic, strong) NSString *game_short_introduction;
/** 游戏特征 */
@property (nonatomic, strong) NSString *game_feature;
/** vip 价格 */
@property (nonatomic, strong) NSString *game_vip_amount;
/** 充值返利 */
@property (nonatomic, strong) NSString *game_rebate;
/** 收藏 */
@property (nonatomic, strong) NSString *game_is_collection;
/** 下载地址 */
@property (nonatomic, strong) NSString *game_download_url;
/** 玩家 QQ 群 */
@property (nonatomic, strong) NSString *player_qq_group;
/** 评论数 */
@property (nonatomic, strong) NSString *game_comment_number;
/** 下载数 */
@property (nonatomic, strong) NSString *game_download_number;
/** 游戏评分 */
@property (nonatomic, strong) NSString *game_score;
/** game tag */
@property (nonatomic, strong) NSString *game_tag;
/** 游戏类型 */
@property (nonatomic, strong) NSString *game_type;
/** 游戏类型数组 */
@property (nonatomic, strong) NSArray *game_type_array;
/** 游戏版本 */
@property (nonatomic, strong) NSString *game_version;
/** 用户是否评分 */
@property (nonatomic, strong) NSString *player_is_score;

/** 游戏详情页面的 "猜你喜欢" 功能*/
@property (nonatomic, strong) NSArray *like;
/** 回调信息 */
@property (nonatomic, strong) NSString *call_back_message;



@property (nonatomic, strong) CommentNumberBlock commentNumberBlock;





/** 游戏信息单例 */
+ (instancetype)CurrentGame;
/** 根据游戏 id 刷新游戏数据 */
+ (instancetype)refreshCurrentGameWithGameID:(NSString *)gameID Completion:(RefreshCompleteBlock)block;
/** 根据游戏模型刷新数据 */
+ (instancetype)refreshCurrentGameWithGameModel:(FFGameModel *)gameModel Completion:(RefreshCompleteBlock)block;


/** 游戏详情接口 */
+ (void)gameInfoWithGameID:(NSString * )gameID Comoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 游戏相关攻略 */
+ (void)raidersWithGameID:(NSString *)gameID Comoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 收藏接口 type = 1 收藏  type = 2 取消*/
+ (void)gameCollectWithType:(NSString *)type GameID:(NSString *)gameID Comoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 评论获取金币 */
+ (void)writeCommentGetCoinComoletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** 子渠道下载 */
+ (void)gameDownloadWithTag:(NSString *)gameTag Comoletion:(void(^)(NSDictionary *  content, BOOL success))completion;





@end
