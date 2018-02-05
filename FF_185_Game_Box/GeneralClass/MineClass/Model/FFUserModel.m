//
//  FFUserModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/6.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFUserModel.h"
#import "FFMapModel.h"
#import "SYKeychain.h"
#import "AFHTTPSessionManager.h"
#import "FFStatisticsModel.h"

#define KEYCHAINSERVICE @"tenoneTec.com"
#define DEVICEID @"CurrentUid"

#define Map [FFMapModel map]


#define SAVEOBJECT [[NSUserDefaults standardUserDefaults] synchronize]
#define USER_INFO_KEYS @"user_info_keys"

@interface FFUserModel ()



@end


static FFUserModel *model;

@implementation FFUserModel

+ (FFUserModel *)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFUserModel alloc] init];
        }
    });
    return model;
}

+ (NSDictionary *)getUserDict {
    NSArray *keys = OBJECT_FOR_USERDEFAULTS(USER_INFO_KEYS);

    if (keys == nil || keys.count == 0) {
        return nil;
    }

//    syLog(@"keys === %@",keys);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [keys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = [SYKeychain passwordForService:KEYCHAINSERVICE account:key];
        if (value != nil) {
            [dict setObject:value forKey:key];
        }
    }];

    return [dict copy];
}

+ (void)login:(NSDictionary *)dict {
    if (dict) {
        NSArray *keys = [dict allKeys];
        //保存系统单利
        SAVEOBJECT_AT_USERDEFAULTS(keys, USER_INFO_KEYS);
        //保存 keychain
        [keys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
            [SYKeychain setPassword:dict[key] forService:KEYCHAINSERVICE account:key];
        }];
    }
}

+ (void)signOut {
//    if (model.isLogin == nil) {
//        return;
//    }

    NSArray *keys = OBJECT_FOR_USERDEFAULTS(USER_INFO_KEYS);
    //移除 keychain 中的数据
    [keys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
        [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:key];
    }];


    //移除 UID
    [FFUserModel deleteUID];
    //移除 userName
    [FFUserModel deleteUserName];
    //清空密码
    [FFUserModel deletePassWord];
    //移除所有 key
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_KEYS];

    //清空 usermodel
    [model setAllPropertyWithDict:nil];

    //退出畅言
    [ChangyanSDK logout];

    //删除头像
    [[NSFileManager defaultManager] removeItemAtPath:[FFUserModel avatarDataPath] error:nil];
    [FFUserModel currentUser].isLogin = nil;
}


#pragma mark - uid
+ (BOOL)setUID:(NSString *)uid {
    return [SYKeychain setPassword:uid forService:KEYCHAINSERVICE account:DEVICEID];
}

+ (NSString *)getUID {
    NSString *uid = [SYKeychain passwordForService:KEYCHAINSERVICE account:DEVICEID];
    return uid;
}

+ (BOOL)deleteUID {
    return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:DEVICEID];
}

+ (NSString *)uid {
    if (model == nil) {
        return nil;
    }
    return model.uid;
}

- (void)setNick_name:(NSString *)nick_name {
    [SYKeychain setPassword:nick_name forService:KEYCHAINSERVICE account:@"nick_name"];
}

#pragma mark - mobile
@synthesize mobile = _mobile;
- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    if (mobile == nil) {
        [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:@"mobile"];
    } else {
        [SYKeychain setPassword:mobile forService:KEYCHAINSERVICE account:@"mobile"];
    }
}

- (NSString *)mobile {
    if (_mobile != [SYKeychain passwordForService:KEYCHAINSERVICE account:@"mobile"]) {
        _mobile = [SYKeychain passwordForService:KEYCHAINSERVICE account:@"mobile"];
    }
    return _mobile;
}

#pragma mark - user name
+ (BOOL)setUserName:(NSString *)userName {
    return [SYKeychain setPassword:userName forService:KEYCHAINSERVICE account:USER_NAME];
}

+ (NSString *)getUserName {
    NSString *uid = [SYKeychain passwordForService:KEYCHAINSERVICE account:USER_NAME];
    return uid;
}

+ (BOOL)deleteUserName {
    return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:USER_NAME];
}

+ (NSString *)UserName {
    if (model == nil) {
        return nil;
    }
    return model.username;
}

+ (BOOL)setPassWord:(NSString *)passWord {
    return [SYKeychain setPassword:passWord forService:KEYCHAINSERVICE account:USER_PASSWORDK];
}

+ (NSString *)getPassWord {
    NSString *uid = [SYKeychain passwordForService:KEYCHAINSERVICE account:USER_PASSWORDK];
    return uid;
}

+ (BOOL)deletePassWord {
    return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:USER_PASSWORDK];
}


//CurrentUserName

/** avatar */
+ (NSData *)getAvatarData {
    NSData *data = [NSData dataWithContentsOfFile:[FFUserModel avatarDataPath]];
    syLog(@"get avatar");
    return data;
}

+ (void)setAvatarData:(NSData *)data {
    syLog(@"save avatar");
    [data writeToFile:[FFUserModel avatarDataPath] atomically:YES];
}

+ (NSString *)avatarDataPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"avatarData"];
    return filePath;
}



#pragma mark - method ===============================================================
- (void)setAllPropertyWithDict:(NSDictionary *)dict {
    [super setAllPropertyWithDict:dict];
}

/** 畅言单点登录 */
+ (void)changyanLogin {
    BOXLOG(@"chang yan login");
    NSDictionary *dict = [FFUserModel getUserDict];
    syLog(@"model = %@",dict);
    if (dict[@"id"] == nil || dict[@"nick_name"] == nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [FFUserModel changyanLogin];
        });
        return;
    }
    //畅言单点登录
    syLog(@"model uid  && model nick name === %@ \n %@",dict[@"id"],dict[@"nick_name"]);
    [ChangyanSDK loginSSO:dict[@"id"] userName:dict[@"nick_name"] profileUrl:@"" imgUrl:[NSString stringWithFormat:IMAGEURL,model.icon_url] completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        /*
         CYSuccess           = 0,     成功
         CYParamsError       = 1,     参数错误
         CYLoginError        = 2,     登录错误
         CYOtherError        = 3,     其他错误 */
        syLog(@"ChangyanSDK login === %@",responseStr);
    }];
}
/** 用户登录 */
+ (void)userLoginWithUserName:(NSString *)userName
                     PassWord:(NSString *)passWord
                   Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{

    NSArray *pamarasKey = @[@"username",@"password",@"channel",@"system",@"machine_code"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userName forKey:@"username"];
    [dict setObject:passWord forKey:@"password"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:DeviceID forKey:@"machine_code"];
    [dict setObject:BOX_SIGN(dict, pamarasKey) forKey:@"sign"];

    [FFUserModel postRequestWithURL:Map.USER_LOGIN params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;

        syLog(@"login content ==== %@",content);
        if (success && status.integerValue == 1) {
            [FFUserModel changyanLogin];
            NSDictionary *dict = content[@"data"];
            NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithCapacity:dict.count];
            if (dict[@"username"]) {
                [muDict setObject:dict[@"username"] forKey:@"username"];
            }

            if (dict[@"mobile"]) {
                [muDict setObject:dict[@"mobile"] forKey:@"mobile"];
            }
            if (dict[@"nick_name"]) {
                [muDict setObject:dict[@"nick_name"] forKey:@"nick_name"];
            }

            [FFStatisticsModel statisticsLoginWithAccount:content[@"data"][@"username"]];
            [FFStatisticsModel profile:muDict];
        }
    }];
}

/** 用户注册 */
+ (void)userRegisterWithUserName:(NSString *)userName
                            Code:(NSString *)code
                     PhoneNumber:(NSString *)phoneNumber
                        PassWord:(NSString *)passWord
                            Type:(NSString *)type
                      Completion:(void (^)(NSDictionary *, BOOL))completion
{

    NSArray *pamaras = @[@"username",@"code",@"mobile",@"password",@"channel",@"system",@"maker",@"mobile_model",@"machine_code",@"system_version",@"type"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:userName forKey:@"username"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:passWord forKey:@"password"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:@"Apple" forKey:@"maker"];
    [dict setObject:[FFBasicModel phoneType] forKey:@"mobile_model"];
    [dict setObject:[FFBasicModel deviceID] forKey:@"machine_code"];
    [dict setObject:[FFBasicModel systemVersion] forKey:@"system_version"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:BOX_SIGN(dict, pamaras) forKey:@"sign"];
    [FFUserModel postRequestWithURL:Map.USER_REGISTER params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
        syLog(@"注册信息 : %@",content);
        if (success && status.integerValue == 1) {
            [FFStatisticsModel statisticsRegistrationWithAccount:content[@"data"][@"username"]];
        }
    }];
}

/** 修改密码 */
+ (void)userModifyPasswordOldPassword:(NSString *)oldPassword
                          NewPassword:(NSString *)newPassword
                           Completion:(void (^)(NSDictionary *, BOOL))completion
{
    NSArray *array = @[@"id",@"password",@"newpassword"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    NSString *uid = [FFUserModel getUID];
    [dict setObject:uid forKey:@"id"];
    [dict setObject:oldPassword forKey:@"password"];
    [dict setObject:newPassword forKey:@"newpassword"];
    [dict setObject:BOX_SIGN(dict, array) forKey:@"sign"];

    [FFUserModel postRequestWithURL:Map.USER_MODIFYPWD params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

#pragma mark - ===================== sign ===============================
/** 初始化签到 */
+ (void)signInitWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSArray *array = @[@"uid",@"channel"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Uid forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, array) forKey:@"sign"];
    [FFUserModel postRequestWithURL:Map.SIGN_INIT params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 签到 */
+ (void)doSignWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSArray *array = @[@"uid",@"channel"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Uid forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, array) forKey:@"sign"];
    [FFUserModel postRequestWithURL:Map.DO_SIGN params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= 获取 vip 选项 =======================
+ (void)vipGetOptionWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    [FFUserModel postRequestWithURL:Map.VIP_OPTION params:nil completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= 邀请好友 =======================
+ (void)inviteFriendWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion {
    NSArray *array = @[@"uid",@"channel"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Uid forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, array) forKey:@"sign"];
    [FFUserModel postRequestWithURL:Map.FRIEND_RECOM_INFO params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= 客服中心 =======================
+ (void)customerServiceWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSArray *array = @[@"channel"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, array) forKey:@"sign"];
    [FFUserModel postRequestWithURL:Map.CUSTOMER_SERVICE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

#pragma mark - ======================= 我的收藏 =======================
+ (void)myCollectionGameWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"2" forKey:@"system"];
    if (SSKEYCHAIN_USER_NAME) {
        [dict setObject:SSKEYCHAIN_USER_NAME forKey:@"username"];
    } else {
        [dict setObject:@"" forKey:@"username"];
    }
    [dict setObject:page forKey:@"page"];


    [FFBasicModel postRequestWithURL:[FFMapModel map].GAME_MY_COLLECT params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= 找回密码 =======================
/** 获取手机验证码 */
+ (void)userSendMessageWithPhoneNumber:(NSString *)phoneNumber
                                  Type:(NSString *)type
                            Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:BOX_SIGN(dict, (@[@"mobile",@"type"])) forKey:@"sign"];

    [FFUserModel postRequestWithURL:[FFMapModel map].USER_SENDMSG params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 检验验证码 */
+ (void)userCheckMessageWithPhoneNumber:(NSString *)phoneNumber
                            MessageCode:(NSString *)messageCode
                             Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:messageCode forKey:@"code"];
    [dict setObject:BOX_SIGN(dict, (@[@"mobile",@"code"])) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_CHECKMSG params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 重置密码 */
+ (void)userForgetPasswordWithUserID:(NSString *)userID
                            Password:(NSString *)password
                          RePassword:(NSString *)rePassword
                               Token:(NSString *)token
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userID forKey:@"id"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:token forKey:@"token"];
    [dict setObject:BOX_SIGN(dict, (@[@"id",@"password",@"token"])) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_FINDPWD params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= 修改昵称 =======================
/** 修改昵称 */
+ (void)userModifyNicknameWithUserID:(NSString *)userID
                            NickName:(NSString *)nickName
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userID forKey:@"id"];
    [dict setObject:nickName forKey:@"nick_name"];
    [dict setObject:BOX_SIGN(dict, (@[@"id",@"nick_name"])) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_MODIFYNN params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


#pragma mark - ======================= 上传头像 =======================
/** 上传头像 */
+ (void)userUploadPortraitWithImage:(UIImage *)image
                         Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         @"text/txt",
                                                         nil];


    NSURLSessionDataTask *task = [manager POST:[FFMapModel map].USER_UPLOAD parameters:@{@"id":model.uid} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

        NSData *imageData = UIImagePNGRepresentation(image);

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];

        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"img"
                                fileName:fileName
                                mimeType:@"image/png"];

    } progress:^(NSProgress *_Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (completion) {
            completion(nil, YES);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, NO);
        }
    }];

    [task resume];

}


#pragma mark - ======================= user coin =======================
/** 用户的各种币 */
+ (void)userCoinWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel"])) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_CENTER params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)coinCenterWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel"])) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].MY_COIN params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)coinDetailWithPage:(NSString *)page Completion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"page"])) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].COIN_LOG params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)coinExchangeInfoCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel"])) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].COIN_INFO params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 兑换平台币 */
+ (void)coinExchangePlatformCounts:(NSString *)platform_counts
                        Completion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:platform_counts forKey:@"platform_counts"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"platform_counts"])) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].PLAT_EXCHANGE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 平台币明细 */
+ (void)coinPlatformDetailWithPage:(NSString *)page Completion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"page"])) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].PLAT_LOG params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 我的奖品 */
+ (void)myPrizeCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",])) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].MY_PRIZE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= transfer games =======================
+ (void)transferGameApplyWithOriginAppName:(NSString *)origin_appname OriginServerName:(NSString *)origin_servername OriginRoleName:(NSString *)origin_rolename NewAppName:(NSString *)new_appname NewServerName:(NSString *)new_servername NewRoleName:(NSString *)new_rolename QQNumber:(NSString *)qq Mobile:(NSString *)mobile Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:origin_appname forKey:@"origin_appname"];
    [dict setObject:origin_servername forKey:@"origin_servername"];
    [dict setObject:origin_rolename forKey:@"origin_rolename"];
    [dict setObject:new_appname forKey:@"new_appname"];
    [dict setObject:new_servername forKey:@"new_servername"];
    [dict setObject:new_rolename forKey:@"new_rolename"];
    [dict setObject:qq forKey:@"qq"];
    [dict setObject:mobile forKey:@"mobile"];

    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"origin_appname",@"origin_servername",@"origin_rolename",@"new_appname",@"new_servername",@"new_rolename",@"qq",@"mobile"])) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].CHANGEGAME_APPLY params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

+ (void)transferGameListWithPage:(NSString *)page Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"channel",@"page"])) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].CHANGEGAME_LOG params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)transferGameoticeCompletion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, (@[@"channel"])) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].CHANGEGAME_NOTICE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


#pragma mark - ======================= bind phone number =======================
/** 绑定手机 */
+ (void)userBindingPhoneNumber:(NSString *)phoneNumber
                          Code:(NSString *)code
                    completion:(void(^)(NSDictionary *content,BOOL success))completion {

    NSArray *pamarasKey = @[@"uid",@"mobile",@"appid",@"code"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:AppID forKey:@"appid"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:BOX_SIGN(dict, pamarasKey) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_BIND_MOBILE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    
}

+ (void)userUnbindingPhoneNumber:(NSString *)phoneNumber Code:(NSString *)code completion:(void (^)(NSDictionary *, BOOL))completion {
    NSArray *pamarasKey = @[@"uid",@"mobile",@"appid",@"code"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:AppID forKey:@"appid"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:BOX_SIGN(dict, pamarasKey) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_UNBIND_MOBILE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}




@end


















