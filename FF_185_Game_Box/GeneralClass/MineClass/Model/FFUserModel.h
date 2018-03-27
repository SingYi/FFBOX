//
//  FFUserModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/6.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

#define Uid [FFUserModel getUID]

@interface FFUserModel : FFBasicModel

/** 是否登录 */
@property (nonatomic, strong) NSString *isLogin;

/** uid */
@property (nonatomic, strong) NSString *uid;
/** 用户名 */
@property (nonatomic, strong) NSString *username;
/** 手机号码 */
@property (nonatomic, strong) NSString *mobile;
/** 平台币 */
@property (nonatomic, strong) NSString *platform_money;
/** 金币 */
@property (nonatomic, strong) NSString *coin;
/** 头像地址 */
@property (nonatomic, strong) NSString *icon_url;
/** 昵称 */
@property (nonatomic, strong) NSString *nick_name;
/** 邀请奖励 */
@property (nonatomic, strong) NSString *recom_bonus;


/** 当前用户 */
+ (FFUserModel *)currentUser;
/** 登录 */
+ (void)login:(NSDictionary *)dict;
/** 登出 */
+ (void)signOut;
+ (NSDictionary *)getUserDict;
/** uid */
+ (NSString *)uid;
+ (BOOL)setUID:(NSString *)uid;
+ (NSString *)getUID;
+ (BOOL)deleteUID;
/** username */
+ (BOOL)setUserName:(NSString *)userName;
+ (NSString *)getUserName;
+ (BOOL)deleteUserName;
+ (NSString *)UserName;
/** password */
+ (BOOL)setPassWord:(NSString *)passWord;
+ (NSString *)getPassWord;
+ (BOOL)deletePassWord;
/** avatar */
+ (NSData *)getAvatarData;
+ (void)setAvatarData:(NSData *)data;

#pragma mark =======================登录注册方法==============================
/** 用户登录接口
 *  username:用户名或者手机号
 */
+ (void)userLoginWithUserName:(NSString *)userName
                     PassWord:(NSString *)passWord
                   Completion:(void(^)(NSDictionary * content, BOOL success))completion;

/** 用户注册接口 */
+ (void)userRegisterWithUserName:(NSString * )userName
                            Code:(NSString * )code
                     PhoneNumber:(NSString * )phoneNumber
                        PassWord:(NSString * )passWord
                            Type:(NSString * )type
                      Completion:(void(^)(NSDictionary * content, BOOL success))completion;

/** 修改密码 */
+ (void)userModifyPasswordOldPassword:(NSString *)oldPassword
                          NewPassword:(NSString *)newPassword
                           Completion:(void (^)(NSDictionary * content, BOOL success))completion;

#pragma mark - ======================= 签到 =======================
/** 签到初始化 */
+ (void)signInitWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;
/** 签到 */
+ (void)doSignWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;


#pragma mark - ======================= 获取 vip 选项 =======================
+ (void)vipGetOptionWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

#pragma mark - ======================= 邀请好友 =======================
+ (void)inviteFriendWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;


#pragma mark - ======================= 客服中心 =======================
+ (void)customerServiceWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

#pragma mark - ======================= 我的收藏 =======================
+ (void)myCollectionGameWithPage:(NSString *)page Completion:(void (^)(NSDictionary * content, BOOL success))completion;

#pragma mark - ======================= 找回密码 =======================
/** 获取手机验证码 */
+ (void)userSendMessageWithPhoneNumber:(NSString *)phoneNumber
                                  Type:(NSString *)type
                            Completion:(void (^)(NSDictionary * content, BOOL success))completion;
/** 检验验证码 */
+ (void)userCheckMessageWithPhoneNumber:(NSString *)phoneNumber
                            MessageCode:(NSString *)messageCode
                             Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 重置密码 */
+ (void)userForgetPasswordWithUserID:(NSString *)userID
                            Password:(NSString *)password
                          RePassword:(NSString *)rePassword
                               Token:(NSString *)token
                          Completion:(void (^)(NSDictionary * content, BOOL success))completion;

#pragma mark - ======================= 修改昵称 =======================
/** 修改昵称 */
+ (void)userModifyNicknameWithUserID:(NSString *)userID
                            NickName:(NSString *)nickName
                          Completion:(void (^)(NSDictionary * content, BOOL success))completion;


#pragma mark - ======================= 上传头像 =======================
/** 上传头像 */
+ (void)userUploadPortraitWithImage:(id)image Completion:(void (^)(NSDictionary * content, BOOL success))completion;


#pragma mark - ======================= user coin =======================
/** 用户的各种币 */ 
+ (void)userCoinWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 金币中心 */
+ (void)coinCenterWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 金币明细 */
+ (void)coinDetailWithPage:(NSString *)page Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 兑换平台币信息 */
+ (void)coinExchangeInfoCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 兑换平台币 */
+ (void)coinExchangePlatformCounts:(NSString *)platform_counts
                        Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 平台币明细 */
+ (void)coinPlatformDetailWithPage:(NSString *)page
                        Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 我的奖品 */
+ (void)myPrizeCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

#pragma mark - ======================= transfer games =======================
/** 申请转游戏 */
+ (void)transferGameApplyWithOriginAppName:(NSString *)origin_appname
                          OriginServerName:(NSString *)origin_servername
                            OriginRoleName:(NSString *)origin_rolename
                                NewAppName:(NSString *)new_appname
                             NewServerName:(NSString *)new_servername
                               NewRoleName:(NSString *)new_rolename
                                  QQNumber:(NSString *)qq
                                    Mobile:(NSString *)mobile
                                Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 转游戏记录 */
+ (void)transferGameListWithPage:(NSString *)page
                      Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 转游须知 */
+ (void)transferGameoticeCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

#pragma mark - ======================= bind phone number =======================
/** 绑定手机 */
+ (void)userBindingPhoneNumber:(NSString *)phoneNumber
                          Code:(NSString *)code
                    completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 解绑手机 */
+ (void)userUnbindingPhoneNumber:(NSString *)phoneNumber
                            Code:(NSString *)code
                      completion:(void(^)(NSDictionary *content,BOOL success))completion;

@end











