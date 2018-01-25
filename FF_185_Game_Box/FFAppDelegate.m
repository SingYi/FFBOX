//
//  FFAppDelegate.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/25.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFAppDelegate.h"
#import "FFControllerManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "FFMapModel.h"
#import "ChangyanSDK.h"
#import "FFBoxModel.h"
#import <UserNotifications/UserNotifications.h>
#import "FFLaunchScreen.h"
#import "FFAdvertisingView.h"


#define WEIXINAPPID @"wx7ec31aabe8cc710d"
#define QQAPPID @"1106099979"


@interface FFAppDelegate () <UNUserNotificationCenterDelegate,WXApiDelegate>

@end


@implementation FFAppDelegate

- (void)onReq:(BaseReq*)req {
    syLog(@"????????????????????????????????????????");
}

- (void)onResp:(BaseResp*)resp {
    syLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //初始化界面
    [self initializeUserInterface];

    //初始化数据
    [self initializeDataSource];

//    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
//    self.window.rootViewController = [UIViewController new];
//    [self.window makeKeyAndVisible];



    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    syLog(@"open url == %@",url);
    [WXApi handleOpenURL:url delegate:self];
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    syLog(@"open url == %@",url);
    [WXApi handleOpenURL:url delegate:self];
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    syLog(@"open url == %@",url);
    [WXApi handleOpenURL:url delegate:self];
    return NO;
}


#pragma mark - method
- (void)initializeUserInterface {

    //第一次安装
    [FFBoxModel isFirstInstall];

    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [FFControllerManager sharedManager].rootViewController;
    [self.window makeKeyAndVisible];

    //加载引导页
    if ([FFBoxModel isFirstLogin]) {
        [self.window addSubview:[FFLaunchScreen new]];
    } else {
        //广告
        NSData * data = [FFBoxModel getAdvertisingImage];
        if (data) {
            [FFAdvertisingView initWithImage:data];
        }

    }

    //请求广告页面
    [FFBoxModel postAdvertisingImage];


}

- (void)initializeDataSource {

    [FFMapModel getMap];

    //注册微信
    [WXApi registerApp:WEIXINAPPID];
    //注册QQ
    TencentOAuth *oAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:nil];
    [oAuth isSessionValid];
    //注册畅言SDK
    BOXLOG(@"register ChagnyanSDK");
    [ChangyanSDK registerApp:@"cysYKUClL"
                      appKey:@"6c88968800e8b236e5c69b8634db704d"
                 redirectUrl:nil
        anonymousAccessToken:nil];


    //注册通知
    [self resignNotifacation];

    //公告
    [FFBoxModel appAnnouncement];

    //检查更新
    [FFBoxModel checkBoxVersionCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"box version ==== %@",content);
        if (success) {
            if ([content[@"data"] isKindOfClass:[NSString class]]) {
                [FFBoxModel boxUpdateWithUrl:content[@"data"]];
            }
        }
    }];
}

/** 注册通知 */
- (void)resignNotifacation {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;

        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted == YES) {
                SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:granted], @"NOTIFICATIONSETTING");
            } else {
                SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:NO], @"NOTIFICATIONSETTING");

            }
        }];

        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {

        }];
    } else {

    }
}






@end