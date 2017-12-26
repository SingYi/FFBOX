//
//  FFBoxModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/10.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"

typedef void (^Completion)(NSDictionary *  content, BOOL success);


@interface FFBoxModel : FFBasicModel

/** check box version */
+ (void)checkBoxVersionCompletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** update box */ 
+ (void)boxUpdateWithUrl:(NSString *)url;

/** first login */
+ (BOOL)isFirstLogin;

/** first install */
+ (BOOL)isFirstInstall;

/** app  announcement */
+ (void)appAnnouncement;


/** test */
+ (void)registerNotification:(NSInteger )alerTime;

+ (NSArray *)notificationList;

/** 注册本地通知 */
+ (void)addNotificationWithDict:(NSDictionary *)dict Completion:(Completion)completion;
/** is add notification */
+ (BOOL)isAddNotificationWithDict:(NSDictionary *)dict;
/** 通知 info */
+ (NSDictionary *)notificationUserInfo:(NSDictionary *)dict;
/** notification identifier */
+ (NSString *)notificationIdentifierWithUserInfo:(NSDictionary *)dict;

+ (NSArray *)allNotifications;

+ (void)deleteNotificationWith:(id)dict;
+ (void)deleteAllNotification;

/** advertising  */
+ (void)postAdvertisingImage;

+ (id *)addAdvertisinImage;

+ (NSData *)getAdvertisingImage;

+ (void)UnreadMessagesWithCompletion:(Completion)completion;


@end
