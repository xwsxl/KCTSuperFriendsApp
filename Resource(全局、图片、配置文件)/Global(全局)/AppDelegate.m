//
//  AppDelegate.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/11.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "AppDelegate.h"
#import "KCTAPPStartADVC.h"
#import "IQKeyboardManager.h"
#import "KCTRealmManager.h"
#import <UserNotifications/UserNotifications.h>
#import <ImSDK/ImSDK.h>
#import "TimMessageListenerImpl.h"

#import <UIKit/UIKit.h>
#import <GTSDK/GeTuiSdk.h>

#define kGtAppId           @"OY24zp3FgA7uVkUFpNMX45"
#define kGtAppKey          @"3GaEVnLnZOAu7otBn5Q2r8"
#define kGtAppSecret       @"V0KM8jsZqh626i69PidCc8"
@interface AppDelegate ()<GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
@property (nonatomic, strong) KCTAPPStartADVC *VC;
@property (nonatomic, strong) NSData *token;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [_window makeKeyAndVisible];
    
    sleep(1);
    self.VC=[[KCTAPPStartADVC alloc] init];
    self.window.rootViewController=self.VC;
    
    TIMSdkConfig *config=[[TIMSdkConfig alloc] init];
    config.sdkAppId=1400170299;
    config.accountType=@"2";
    config.disableCrashReport=YES;
    config.disableLogPrint=YES;
    [[TIMManager sharedInstance] initSdk:config];
    TIMUserConfig *userConfig=[[TIMUserConfig alloc] init];
    [[TIMManager sharedInstance] setUserConfig:userConfig];
    
    TimMessageListenerImpl *impl=[[TimMessageListenerImpl alloc] init];
    [[TIMManager sharedInstance] addMessageListener:impl];
    
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // 注册 APNs
    [self registerRemoteNotification];
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    [self getBDAccessToken];
    [KNotificationCenter addObserver:self selector:@selector(logedIn:) name:KCLoginInSuccessNoti object:nil];
    [[UITabBar appearance] setTranslucent:NO];

    return YES;
}
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    XLLog(@"%@",deviceToken);
    // [3]:向个推服务器注册deviceToken 为了方便开发者，建议使用新方法
  //  self.token=deviceToken;
   BOOL success=[GeTuiSdk registerDeviceTokenData:deviceToken];
    if (success) {
        XLLog(@"success token ");
    }
}
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
   
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    [GeTuiSdk setPushModeForOff:NO];
    [KUserDefaults setObject:clientId forKey:@"GeTuiID"];
    [self BDClientID];
  
}
/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    XLLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}
-(void)BDClientID
{
    NSString *str =[KUserDefaults stringForKey:@"GeTuiID"];
    if (str&&str.length>0) {
        // [GeTuiSdk unbindAlias:[KCUserDefaultManager getAccount] andSequenceNum:str andIsSelf:NO];
        [GeTuiSdk bindAlias:[KCUserDefaultManager getAccount] andSequenceNum:str];
        XLLog(@"str=%@,account=%@",str,[KCUserDefaultManager getAccount]);
    }
   // [KNotificationCenter removeObserver:self name:KCLoginInSuccessNoti object:nil];
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    XLLog(@"msg=%@",msg)
}
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    XLLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    //静默推送收到消息后也需要将APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
-(void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError
{
    if ([kGtResponseBindType isEqualToString:action]) {
        XLLog(@"绑定结果 ：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        if (!isSuccess) {
            XLLog(@"失败原因: %@", aError);
        }
    } else if ([kGtResponseUnBindType isEqualToString:action]) {
        XLLog(@"绑定结果 ：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        if (!isSuccess) {
            XLLog(@"失败原因: %@", aError);
        }
    }
}
- (void) application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    XLLog(@"%@",notification);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    XLLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    XLLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
    
}
#endif

/**
 *  SDK运行状态通知
 *
 *  @param aStatus 返回SDK运行状态
 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus
{
    XLLog(@"sdkstatus=%d",aStatus);
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


-(void)getBDAccessToken
{
    XLLog(@"获取百度accesstoken");
    //NSString *BAIDU_TOKEN_DOMAIN = @"https://openapi.baidu.com";
    NSString *BAIDU_APP = @"UI5rGeZu0wIqGgzve4DZciE9";
    NSString *BAIDU_SECRET = @"D2YEWAt6ZyuUzGRGGvPp031eKbg8ouIi";
    
    [KCNetWorkManager POST:@"https://openapi.baidu.com/oauth/2.0/token" WithParams:@{@"grant_type":@"client_credentials",@"client_id":BAIDU_APP,@"client_secret":BAIDU_SECRET} ForSuccess:^(NSDictionary * _Nonnull response) {
        NSNull *null=[[NSNull alloc] init];
        if (![response[@"access_token"] isEqual:null]) {
            [KUserDefaults setObject:response[@"access_token"] forKey:@"BDAccess_token"];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
    
}

-(void)logedIn:(NSNotification *)noti
{
    [KCTRealmManager setDefaultRealmForUser:[KCUserDefaultManager getAccount]];
}

@end
