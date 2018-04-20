//
//  FFStatisticsModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/2.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^StatisticsBlock)(NSDictionary *content,  BOOL success);

typedef enum : NSUInteger {
    other = 0,
    selfBackGround = 1,
    reyun = 2,
    guangdiantong = 3,
} FFStatisticsState;


@interface FFStatisticsModel : NSObject

/** 请求是否统计 */
+ (void)reigstStatics;

/** 注册统计 */
+ (void)statisticsRegistrationWithAccount:(NSString *)account;

/** 登录统计 */
+ (void)statisticsLoginWithAccount:(NSString *)account;

/** 支付统计 */
+ (void)statisticsPayWithTransactionID:(NSString *)transactionID
                           paymentType:(NSString *)payMentType
                        currencyAmount:(NSString *)amount;

/** 支付回调统计 */
+ (void)statisticsPayCallBackWithTransactionID:(NSString *)transactionID
                                   paymentType:(NSString *)payMentType
                                currencyAmount:(NSString *)amount;

/** 自定义事件统计 */
+ (void)customEventsWith:(NSString *)name Extra:(NSDictionary *)dict;


/** 用户事件统计 */
+ (void)profile:(NSDictionary*)dataDic;




@end

