//
//  FFBasicModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYKeychain.h"

#define REQUEST_STATUS NSString *status = content[@"status"]
#define CONTENT_DATA ((content[@"data"]) ? (content[@"data"]) : content)

#define REQUEST_COMPLETION \
REQUEST_STATUS;\
if (success) {\
    if (status.integerValue == 0) {\
        if (completion) {\
            completion(content, YES);\
        }\
    } else {\
        if (completion) {\
            completion(@{@"status":content[@"status"],@"msg":content[@"msg"]},false);\
        }\
    }\
} else {\
    if (completion) {\
        completion(@{@"status":@"404",@"msg":@"请求超时"},false);\
    }\
}

#define NEW_REQUEST_COMPLETION \
REQUEST_STATUS;\
if (success) {\
    if (status.integerValue == 1) {\
        if (completion){\
            completion(content,true);\
        }\
    } else {\
        if (completion){\
            completion(@{@"status":content[@"status"],@"msg":content[@"msg"]},false);\
        }\
    }\
} else {\
    if (completion){\
        completion(@{@"status":@"404",@"msg":@"请求超时"},false);\
    }\
}



#define BOX_SIGN(dict, pamarasKey) [FFBasicModel signWithParms:dict WithKeys:pamarasKey]
#define AppID @"1013"
#define AppKey @"709931298992c123ba79f9394032e91e"


#define Channel ([FFBasicModel channel])
#define DeviceID ([FFBasicModel deviceID])
#define PhoneType ([FFBasicModel phoneType])
#define AppVersion ([FFBasicModel appVersion])


@interface FFBasicModel : NSObject

@property (nonatomic, assign) NSInteger currentPage;

/** 获取所有类的属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType;

/** 对类的所有属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict;

/** get方法 */
+ (void)getRequestWithURL:(NSString *)url
                   params:(NSDictionary *)dicP
               completion:(void(^)(NSDictionary *content,BOOL success))completion;


/** post方法 */
+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** post */
+ (void)postRequestWithURL:(NSString *)url params:(NSDictionary *)params Success:(void(^) (NSDictionary *content))success Failure:(void(^)(NSError * error))failure;


#pragma mark - channel
+ (NSString *)channel;

/* 设备 ID */
+ (NSString *)deviceID;

/** 设备 ip */
+ (NSString *)DeviceIP;

/* 设备型号 */
+ (NSString *)phoneType;

/* 设备系统版本 */
+ (NSString *)systemVersion;

/** app 版本 */
+ (NSString *)appVersion;


+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys;





@end
