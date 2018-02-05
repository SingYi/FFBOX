//
//  FFStatisticsModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/2.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFStatisticsModel.h"
#import "TrackingIO.h"
#import "FFMapModel.h"
#import "FFPayModel.h"

#define TrackingIOID @"ffcaffb5979b3df9ff12751857fc88fa"
#define TrackingIOToken @"506D348071C391675943F5754F6AF056"
#define TrackingStart if ([self SharedModel].isStartStatistics == NO) {\
return;\
}\

@interface FFStatisticsModel ()

@property (nonatomic, assign) BOOL isStartStatistics;

@end


static FFStatisticsModel *model = nil;
@implementation FFStatisticsModel


+ (FFStatisticsModel *)SharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            model = [[FFStatisticsModel alloc] init];
            model.isStartStatistics = NO;
        }
    });
    return model;
}

/** 注册统计 */
+ (void)reigstStatics {
    NSDictionary *dict = @{@"channel":Channel};
    [FFBasicModel postRequestWithURL:[FFMapModel map].BOX_INIT
                              params:@{@"channel":Channel,@"sign":BOX_SIGN(dict, (@[@"channel"]))}
                             Success:^(NSDictionary *content) {
                                 syLog(@"统计  == =%@", content);
                                 NSString *status = content[@"status"];
                                 NSString *box_static = content[@"data"][@"box_static"];
                                 if (status.integerValue == 1 && box_static.integerValue == 2) {
                                     [self SharedModel].isStartStatistics = YES;
                                 } else {
                                     [self SharedModel].isStartStatistics = NO;
                                 }

                                 [self startStatics];
                             } Failure:^(NSError *error) {
                                 [self SharedModel].isStartStatistics = NO;
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [self reigstStatics];
                                 });
                             }];
}


/** 启动统计 */
+ (void)startStatics {
    syLog(@"是否开启统计 : %lu",[self SharedModel].isStartStatistics);
    TrackingStart;
    [TrackingIO initWithappKey:TrackingIOID withChannelId:Channel];
    syLog(@"注册统计 !!!!!!!!!!!!!!!!!!11");
}


/** 注册统计 */ 
+ (void)statisticsRegistrationWithAccount:(NSString *)account {
    TrackingStart;
    syLog(@"注册统计");
    [TrackingIO setRegisterWithAccountID:account];
}

/** 登录统计 */ 
+ (void)statisticsLoginWithAccount:(NSString *)account {
    TrackingStart;
    syLog(@"登录统计");
    [TrackingIO setLoginWithAccountID:account];
}


/** 支付统计 */
+ (void)statisticsPayWithTransactionID:(NSString *)transactionID paymentType:(NSString *)payMentType currencyAmount:(NSString *)amount {
    TrackingStart;
    syLog(@"准备支付统计");
    /** typedef enum : NSUInteger {
     AliQRcode = 1,
     Alipay = 2,
     WechatQRcode = 3,
     WechatPay = 4,
     TenPay = 6,
     ChinaMobile = 7,
     ChinaTelecom = 8,
     ChinaUnicom = 9,
     platformCoin = 10
     } PayType; */
    NSString *pay;
    switch (payMentType.integerValue) {
        case 1:
        case 2: pay = @"alipay";
            break;
        case 3:
        case 4: pay = @"weixinpay";
            break;
        default:
            break;
    }

    [TrackingIO setryzfStart:transactionID ryzfType:pay currentType:@"CNY" currencyAmount:amount.floatValue];
}

+ (void)statisticsPayCallBackWithTransactionID:(NSString *)transactionID paymentType:(NSString *)payMentType currencyAmount:(NSString *)amount {
    TrackingStart;
    syLog(@"支付回调统计");
    /** typedef enum : NSUInteger {
     AliQRcode = 1,
     Alipay = 2,
     WechatQRcode = 3,
     WechatPay = 4,
     TenPay = 6,
     ChinaMobile = 7,
     ChinaTelecom = 8,
     ChinaUnicom = 9,
     platformCoin = 10
     } PayType; */
    NSString *pay;
    switch (payMentType.integerValue) {
        case 1:
        case 2: pay = @"alipay";
            break;
        case 3:
        case 4: pay = @"weixinpay";
            break;
        default:
            break;
    }

    [TrackingIO setryzf:transactionID ryzfType:pay currentType:@"CNY" currencyAmount:amount.floatValue];
}


/** 自定义 */
+ (void)customEventsWith:(NSString *)name Extra:(NSDictionary *)dict {
    TrackingStart;
    syLog(@"自定义统计 : %@",name);
    [TrackingIO setEvent:name andExtra:dict];
}

/** 用户统计 */
+ (void)profile:(NSDictionary *)dataDic {
    TrackingStart;
    syLog(@"用户统计 : %@",dataDic);
    [TrackingIO setProfile:dataDic];
}






@end
