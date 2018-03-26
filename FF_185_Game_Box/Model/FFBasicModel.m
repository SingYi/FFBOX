//
//  FFBasicModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicModel.h"
#import <objc/runtime.h>
#import "AFHTTPSessionManager.h"
#import <CommonCrypto/CommonDigest.h>

#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "SYKeychain.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

#define KEYCHAINSERVICE @"tenoneTec.com"
#define DEVICEID @"deviceID%forBOX"

@implementation FFBasicModel

/** 获取类的所有属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType {
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([classType class], &count);

    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count;  i++) {

        objc_property_t property = properties[i];

        const char *cName = property_getName(property);

        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];

        [mArray addObject:name];
    }
    return [mArray copy];
}

/** 对类的属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict {
    WeakSelf;

    NSArray *names = [FFBasicModel getAllPropertyWithClass:self];
    if (dict != nil && dict.count > 0) {
        NSArray *mapArray = [dict allKeys];
        syLog(@"inpute property count %ld",mapArray.count);
        syLog(@"original property count %ld",names.count);
        NSMutableSet *namesSet = [NSMutableSet setWithArray:names];
        NSMutableSet *mapSet = [NSMutableSet setWithArray:mapArray];
        NSString *className = NSStringFromClass([weakSelf class]);
        if (namesSet.count > mapSet.count) {
            [namesSet minusSet:mapSet];
            syLog(@"%@ 没有添加的属性 %@",className, namesSet);
        } else {
            [mapSet minusSet:namesSet];
            syLog(@"%@ 多余的属性 %@",className, mapSet);
        }
    }


    if (dict == nil) {
        for (NSString *name in names) {
            [weakSelf setValue:nil forKey:name];
        }
    } else {

        for (NSString *name in names) {
            //如果字典中的值为空，赋值可能会出问题
            if (!name) {
                continue;
            }

            if ([name isEqualToString:@"isLogin"]) {
                [weakSelf setValue:@"1" forKey:name];
                continue;
            }

            if ([name isEqualToString:@"uid"]) {
                [weakSelf setValue:[NSString stringWithFormat:@"%@",dict[@"id"]] forKey:name];
                continue;
            }

            if(dict[name]) {
                [weakSelf setValue:[NSString stringWithFormat:@"%@",dict[name]] forKey:name];

            }

        }
    }
}



+ (void)getRequestWithURL:(NSString *)url
                   params:(NSDictionary *)dicP
               completion:(void(^)(NSDictionary * content,BOOL success))completion
{
    NSMutableString * strUrl = [NSMutableString stringWithString:url];
    if (dicP && dicP.count) {
        NSArray * arrKey = [dicP allKeys];
        NSMutableArray * pValues = [NSMutableArray array];
        for (id key in arrKey) {
            [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,dicP[key]]];
        }
        NSString * strP = [pValues componentsJoinedByString:@"&"];
        [strUrl appendFormat:@"?%@",strP];
    }
    NSURLSession * session  = [NSURLSession sharedSession];

    NSURLSessionTask * task = [session dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,false);
                    }
                });
                syLog(@"NSJSONSerialization error");
            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion((NSDictionary *)obj,true);
                        }
                    });

                }
            }
        } else {
            syLog(@"Request Failed...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,false);
                }
            });
        }
    }];
    [task resume];
}


+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary * content,BOOL success))completion {

//    [FFBasicModel postRequestWithURL:url params:dicP Success:^(NSDictionary *content) {
//        if (completion) {
//            completion(content, YES);
//        }
//    } Failure:^(NSError *error) {
//        if (completion) {
//            completion(@{@"error": error.localizedDescription}, NO);
//        }
//    }];

    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (dicP && dicP.count) {
        NSArray *arrKey = [dicP allKeys];
        NSMutableArray *pValues = [NSMutableArray array];
        for (id key in arrKey) {
            [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,dicP[key]]];
        }
        NSString *strP = [pValues componentsJoinedByString:@"&"];
        [request setHTTPBody:[strP dataUsingEncoding:NSUTF8StringEncoding]];
//        [request setHTTPBody:[strP dataUsingEncoding:NSUTF16StringEncoding]];
//        nsutf
    }

    request.timeoutInterval = 5.f;

    [request setHTTPMethod:@"POST"];

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {

            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
                        syLog(@"%@",obj);
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,false);
                    }
                });
                                syLog(@"NSJSONSerialization error");

            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion((NSDictionary *)obj,true);
                        }
                    });
                }
            }
        } else {
                        syLog(@"Request Failed...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,false);
                }
            });
        }
    }];
    [task resume];
}

+ (void)postRequestWithURL:(NSString *)url params:(NSDictionary *)dicP {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:url parameters:dicP progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}


+ (void)postRequestWithURL:(NSString *)url params:(NSDictionary *)params Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;

    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {

            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(responseObject);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - channel
+ (NSString *)channel {
    NSString *channel = @"185";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameBoxConfig" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (dict == nil) {
        syLog(@"channel errormessage:channel is Null; channel === %@",channel);
        return channel;
    } else {
        channel = dict[@"channelID"];
    }

    syLog(@"GAME_BOX === channel == %@",channel);

    return channel;
}


/** 签名 */
+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys {

    NSMutableString *signString = [NSMutableString string];

    [keys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {

        [signString appendString:obj];
        [signString appendString:@"="];
        if (params[obj] == nil) {
            syLog(@"尚未登录或者 参数错误");
            return ;
        }

        [signString appendString:params[obj]];

        if (idx < keys.count - 1) {
            [signString appendString:@"&"];
        }
    }];

    NSString *key = AppKey;

    [signString appendString:key];

    return [FFBasicModel md5:signString];
}


+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        //注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}

/** 设备 id */
+ (NSString *)deviceID {
    NSString *deviceID = [SYKeychain passwordForService:KEYCHAINSERVICE account:DEVICEID];
    if (deviceID == nil) {
        deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SYKeychain setPassword:deviceID forService:KEYCHAINSERVICE account:DEVICEID];
    }
    return deviceID;
}

/** 设备型号 */
+ (NSString *)phoneType {

    struct utsname systemInfo;

    uname(&systemInfo);

    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;

}

/** 系统版本 */
+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

/** 游戏的版本 */
+ (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}

/** 设备 ip */
+ (NSString *)DeviceIP {

    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    success = getifaddrs(&interfaces);
    if (success == 0) {

        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {

                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {

                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}






@end




