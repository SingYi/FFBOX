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
//#import <GDTActionSDK/GDTAction.h>

#define TrackingIOID @"ffcaffb5979b3df9ff12751857fc88fa"
#define TrackingIOToken @"506D348071C391675943F5754F6AF056"

#define GDTActionID         @"1106853768"                           //数据源 ID
#define GDTActionSecretKey  @"9fde0f5c7ea574a9edb962d745834243"     //数据源 Key

#define TrackingStart if ([self SharedModel].isStartStatistics == NO) {\
return;\
}\

@interface FFStatisticsModel ()

@property (nonatomic, assign) BOOL isStartStatistics;

@property (nonatomic, assign) FFStatisticsState registState;

@end


static FFStatisticsModel *model = nil;
@implementation FFStatisticsModel


+ (FFStatisticsModel *)SharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            model = [[FFStatisticsModel alloc] init];
            model.isStartStatistics = NO;
            model.registState = other;
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
                                 if (status.integerValue == 1) {
                                     [self SharedModel].registState = (FFStatisticsState)box_static.integerValue;
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
    syLog(@"是否开启统计 : %lu",[self SharedModel].registState);
    switch ([self SharedModel].registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO initWithappKey:TrackingIOID withChannelId:Channel];
            break;
        }
        case guangdiantong: {
//            [GDTAction init:GDTActionID secretKey:GDTActionSecretKey];
            break;
        }

        default:
            break;
    }

    syLog(@"注册统计 !!!!!!!!!!!!!!!!!!11");
    syLog(@"______________________________________________________\n");
//    [GDTAction logAction:GDTSDKActionNameRegister actionParam:@{@"test":@"test1"}];
    syLog(@"______________________________________________________\n");
}


/** 注册统计 */ 
+ (void)statisticsRegistrationWithAccount:(NSString *)account {
    switch ([self SharedModel].registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setRegisterWithAccountID:account];
            break;
        }
        case guangdiantong: {
//            [GDTAction logAction:GDTSDKActionNameRegister actionParam:@{@"register":[NSString stringWithFormat:@"%@",account]}];
            break;
        }

        default:
            break;
    }
    syLog(@"注册统计");
}

/** 登录统计 */ 
+ (void)statisticsLoginWithAccount:(NSString *)account {
    switch ([self SharedModel].registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setLoginWithAccountID:account];
            break;
        }
        case guangdiantong: {
//            [GDTAction logAction:@"CUSTOM" actionParam:@{@"login":[NSString stringWithFormat:@"%@",account]}];
            break;
        }

        default:
            break;
    }
    syLog(@"登录统计");
}


/** 支付统计 */
+ (void)statisticsPayWithTransactionID:(NSString *)transactionID paymentType:(NSString *)payMentType currencyAmount:(NSString *)amount {
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

    switch ([self SharedModel].registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setryzfStart:transactionID ryzfType:pay currentType:@"CNY" currencyAmount:amount.floatValue];
            break;
        }
        case guangdiantong: {
//            [GDTAction logAction:GDTSDKActionNameAddToCart actionParam:@{@"transactionID":transactionID,
//                                                     @"payType":pay,
//                                                     @"cuurentType":@"CNY",
//                                                     @"mount":[NSNumber numberWithFloat:amount.floatValue]}];
            break;
        }

        default:
            break;
    }
}

+ (void)statisticsPayCallBackWithTransactionID:(NSString *)transactionID paymentType:(NSString *)payMentType currencyAmount:(NSString *)amount {
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

    switch ([self SharedModel].registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setryzf:transactionID ryzfType:pay currentType:@"CNY" currencyAmount:amount.floatValue];
            break;
        }
        case guangdiantong: {
//            [GDTAction logAction:GDTSDKActionNamePurchase actionParam:@{@"transactionID":transactionID,
//                                                       @"payType":pay,
//                                                       @"cuurentType":@"CNY",
//                                                       @"mount":[NSNumber numberWithFloat:amount.floatValue]}];
            break;
        }

        default:
            break;
    }

}


/** 自定义 */
+ (void)customEventsWith:(NSString *)name Extra:(NSDictionary *)dict {
    syLog(@"自定义统计 : %@",name);
    switch ([self SharedModel].registState) {
        case other:
            return;
        case selfBackGround:
            break;
        case reyun: {
            [TrackingIO setEvent:name andExtra:dict];
            break;
        }
        case guangdiantong: {
//            [GDTAction logAction:@"CUSTOM" actionParam:dict];
            break;
        }

        default:
            break;
    }
}

/** 用户统计 */
+ (void)profile:(NSDictionary *)dataDic {
    syLog(@"用户统计 : %@",dataDic);
    switch ([self SharedModel].registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setProfile:dataDic];
            break;
        }
        case guangdiantong: {
//            [GDTAction logAction:@"CUSTOM" actionParam:dataDic];
            break;
        }

        default:
            break;
    }
}





@end
