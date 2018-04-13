//
//  FFGameModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/15.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameModel.h"
#import "FFMapModel.h"

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"

#define SET_VALUE(original,new) (original = (new ? [NSString stringWithFormat:@"%@",new] : nil))
#define GAMEINFO(key) (_gameinfo[key])

static FFGameModel *model;

@interface FFGameModel ()

@property (nonatomic, strong) NSDictionary *content_data;
@property (nonatomic, strong) NSDictionary *gameinfo;



@end



@implementation FFGameModel

/** 单利 */
+ (instancetype)CurrentGame {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFGameModel alloc] init];
        }
    });
    return model;
}

+ (instancetype)refreshCurrentGameWithGameID:(NSString *)gameID Completion:(RefreshCompleteBlock)block {
    [self gameInfoWithGameID:gameID Comoletion:^(NSDictionary *content, BOOL success) {
        syLog(@"game info ==== %@",content);
        if (success) {
            [CURRENT_GAME setInfoWithDictionary:content];
        }
        if (block) {
            block(success);
        }
    }];
    return CURRENT_GAME;
}

+ (instancetype)refreshCurrentGameWithGameModel:(FFGameModel *)gameModel Completion:(RefreshCompleteBlock)block {
    CURRENT_GAME.game_name = gameModel.game_name;
    CURRENT_GAME.game_logo_image = gameModel.game_logo_image;
    return [self refreshCurrentGameWithGameID:gameModel.game_id Completion:block];
}

#pragma mark - set data
- (void)setInfoWithDictionary:(NSDictionary *)dict {
    self.content_data = dict[@"data"];
    self.gameinfo = self.content_data[@"gameinfo"];
    self.like = self.content_data[@"like"];
    self.call_back_message = dict[@"msg"];
}

- (void)setGameinfo:(NSDictionary *)gameinfo {
    if (gameinfo && [gameinfo isKindOfClass:[NSDictionary class]]) {
        _gameinfo = gameinfo.copy;
        //设置参数
        [self setGameInfo];
        //请求评论数目
        [self getCommentNumber];
    } else {
        syLog(@"gameinfo is null");
    }
}

- (void)setLike:(NSArray *)like {
    if (like) {
        _like = like;
    }
}

//设置信息
- (void)setGameInfo {
    [self setGame_introduction:GAMEINFO(@"abstract")];
    [self setGame_is_collection:GAMEINFO(@"collect")];
    [self setGame_short_introduction:GAMEINFO(@"content")];
    [self setGame_download_number:GAMEINFO(@"download")];
    [self setGame_feature:GAMEINFO(@"feature")];
    [self setGame_name:GAMEINFO(@"gamename")];
    [self setGif_url:GAMEINFO(@"gif")];
    [self setGif_model:GAMEINFO(@"gif_model")];
    [self setGame_id:GAMEINFO(@"id")];
    [self setShowImageArray:GAMEINFO(@"imgs")];
    [self setGame_bundle_name:GAMEINFO(@"ios_pack")];
    [self setGame_download_url:GAMEINFO(@"ios_url")];
    [self setPlayer_is_score:GAMEINFO(@"isMark")];
    [self setGame_label:GAMEINFO(@"label")];
    [self setGame_logo_url:GAMEINFO(@"logo")];
    [self setPlayer_qq_group:GAMEINFO(@"qq_group")];
    [self setGame_rebate:GAMEINFO(@"rebate")];
    [self setGame_score:GAMEINFO(@"score")];
    [self setGame_size:GAMEINFO(@"size")];
    [self setGame_tag:GAMEINFO(@"tag")];
    [self setGame_type:GAMEINFO(@"types")];
    [self setGame_version:GAMEINFO(@"version")];
    [self setGame_vip_amount:GAMEINFO(@"vip")];
}

/** 请求评论 */
- (void)getCommentNumber {
    [FFGameModel getCommentNumberWithComoletion:^(NSDictionary *content, BOOL success) {
        syLog(@"comment number === %@",content);
        if (success) {
            NSString *string = [NSString stringWithFormat:@"%@",content[@"data"]];
            if (_commentNumberBlock) {
                _commentNumberBlock(string);
            }
        }
    }];
}

/** 游戏简介 */
- (void)setGame_introduction:(NSString *)game_introduction {
    SET_VALUE(_game_introduction, game_introduction);
}

/** 游戏特征 */
- (void)setGame_feature:(NSString *)game_feature {
    SET_VALUE(_game_feature, game_feature);
}

/** 游戏收藏 */
- (void)setGame_is_collection:(NSString *)game_is_collection {
    SET_VALUE(_game_is_collection, game_is_collection);
}

/** vip 价格 */
- (void)setGame_vip_amount:(NSString *)game_vip_amount {
    SET_VALUE(_game_vip_amount, game_vip_amount);
}


/** 下载次数 */
- (void)setGame_download_number:(NSString *)game_download_number {
    SET_VALUE(_game_download_number, game_download_number);
}

/** 游戏名称 */
- (void)setGame_name:(NSString *)game_name {
    SET_VALUE(_game_name, game_name);
}

/** gif url */
- (void)setGif_url:(NSString *)gif_url {
    SET_VALUE(_gif_url, gif_url);
}

/** gif model */
- (void)setGif_model:(NSString *)gif_model {
    SET_VALUE(_gif_model, gif_model);
}

/** 游戏 id */
- (void)setGame_id:(NSString *)game_id {
    SET_VALUE(_game_id, game_id);
}

/** 显示图数组 */
- (void)setShowImageArray:(NSArray *)showImageArray {
    if (showImageArray && [showImageArray isKindOfClass:[NSArray class]] && showImageArray.count > 0) {
        _showImageArray = showImageArray.copy;
    }
}

/** 游戏包名 */
- (void)setGame_bundle_name:(NSString *)game_bundle_name {
    SET_VALUE(_game_bundle_name, game_bundle_name);
}

/** 游戏下载地址 */
- (void)setGame_download_url:(NSString *)game_download_url {
    SET_VALUE(_game_download_url, game_download_url);
}

/** 游戏 logo 地址 */
- (void)setGame_logo_url:(NSString *)game_logo_url {
    _game_logo_url = [NSString stringWithFormat:IMAGEURL,game_logo_url];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_game_logo_url] options:(SDWebImageDownloaderLowPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (finished) {
            _game_logo_image = image;
        }
    }];

}

/** 游戏标签 */
- (void)setGame_label:(NSString *)game_label {
    SET_VALUE(_game_label, game_label);
    self.game_label_array = [_game_label componentsSeparatedByString:@","];
}

/** qq 群 */
- (void)setPlayer_qq_group:(NSString *)player_qq_group {
    SET_VALUE(_player_qq_group, player_qq_group);
}

/** 充值返利 */
- (void)setGame_rebate:(NSString *)game_rebate {
    SET_VALUE(_game_rebate, game_rebate);
}

/** 游戏评分 */
- (void)setGame_score:(NSString *)game_score {
    SET_VALUE(_game_score, game_score);
}

/** 游戏大小 */
- (void)setGame_size:(NSString *)game_size {
    SET_VALUE(_game_size, game_size);
}

/** game tag */
- (void)setGame_tag:(NSString *)game_tag {
    SET_VALUE(_game_tag, game_tag);
}

/** 游戏类型 */
- (void)setGame_type:(NSString *)game_type {
    SET_VALUE(_game_type, game_type);
    self.game_type_array = [_game_type componentsSeparatedByString:@" "];
}

/** 游戏版本 */
- (void)setGame_version:(NSString *)game_version {
    SET_VALUE(_game_version, game_version);
}

/** 用户是否评分 */
- (void)setPlayer_is_score:(NSString *)player_is_score {
    SET_VALUE(_player_is_score, player_is_score);
}





/** 获取当前游戏评论列表 */
- (void)getCommentListWithPage:(NSString *)page Completion:(CommentListBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
    if (SSKEYCHAIN_UID != nil && SSKEYCHAIN_UID.length != 0) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        [dict setObject:@"0" forKey:@"uid"];
    }
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:CURRENT_GAME.game_id forKey:@"dynamics_id"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:@"2" forKey:@"comment_type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"dynamics_id",@"type",@"page"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 发表评论 */
- (void)sendCommentWithText:(NSString *)text ToUid:(NSString *)toUid is_fake:(NSString *)is_fake Completion:(CommentListBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    (toUid != nil) ? [dict setObject:toUid forKey:@"to_uid"] : [dict setObject:@"0" forKey:@"to_uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:CURRENT_GAME.game_id forKey:@"dynamics_id"];
    [dict setObject:text forKey:@"content"];
    [dict setObject:@"2" forKey:@"comment_type"];
    if (is_fake) {
        [dict setObject:is_fake forKey:@"is_fake"];
    }
    [dict setObject:@"1" forKey:@"is_game_id"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"to_uid",@"channel",@"dynamics_id",@"content"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 删除评论 */
- (void)deleteCommentWithCommentID:(NSString *)commentId Completion:(GameCompletionBlck)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:commentId forKey:@"comment_id"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"comment_id"]))) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_DEL params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 评论赞的接口 */
- (void)likeCommentWithCommentID:(NSString *)commentid Completion:(GameCompletionBlck)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:commentid forKey:@"comment_id"];
    [dict setObject:@"1" forKey:@"type"];

    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"comment_id",@"type"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_LIKE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 取消赞 */
- (void)cancelLikeCommentWithCommentID:(NSString *)commentid Type:(NSString *)type Completion:(GameCompletionBlck)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:commentid forKey:@"comment_id"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"comment_id",@"type"]))) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].CANCEL_COMMENT_LIKE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 请求游戏功率 */
- (void)getGameActivity {
    [FFGameModel activityWithGameID:self.game_id Comoletion:^(NSDictionary *content, BOOL success) {
        if (self.activityCallBackBlock) {
            self.activityCallBackBlock(content, success);
        }
    }];
}


/** 游戏详情 */
+ (void)gameInfoWithGameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:gameID forKey:@"gid"];

    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }

    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:Channel forKey:@"channel"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_INFO params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 游戏相关攻略 */
+ (void)raidersWithGameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:@"1" forKey:@"page"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_GONGLUE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 游戏相关攻略 */
+ (void)activityWithGameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:@"1" forKey:@"page"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_GONGLUE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}



/** 收藏接口 type = 1 收藏  type = 2 取消*/
+ (void)gameCollectWithType:(NSString *)type GameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:gameID forKey:@"gid"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:@"2" forKey:@"system"];

    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }

    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_COLLECT params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

+ (void)writeCommentGetCoinComoletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:BOX_SIGN(dict, @[@"uid"]) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_COIN params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

+ (void)gameDownloadWithTag:(NSString *)gameTag Comoletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:gameTag forKey:@"tag"];
    [dict setObject:Channel forKey:@"channel"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_CHANNEL_DOWNLOAD params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

+ (void)getCommentNumberWithComoletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"comment_type"];
    [dict setObject:CURRENT_GAME.game_id forKey:@"dynamics_id"];
    [dict setObject:BOX_SIGN(dict, (@[@"channel",@"comment_type",@"dynamics_id"])) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_COUNTS params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}






@end