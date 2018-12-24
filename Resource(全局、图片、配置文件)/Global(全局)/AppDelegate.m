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
@interface AppDelegate ()
@property (nonatomic, strong) KCTAPPStartADVC *VC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [_window makeKeyAndVisible];
    sleep(1);
    self.VC=[[KCTAPPStartADVC alloc] init];
    self.window.rootViewController=self.VC;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    [self getBDAccessToken];
    [KNotificationCenter addObserver:self selector:@selector(logedIn:) name:KCLoginInSuccessNoti object:nil];
    [[UITabBar appearance] setTranslucent:NO];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"succeeded!");
            }
        }];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){//iOS8-iOS9
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {//iOS8以下
        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // Override point for customization after application launch.
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


-(void)getBDAccessToken
{
    XLLog(@"获取百度accesstoken");
    NSString *BAIDU_TOKEN_DOMAIN = @"https://openapi.baidu.com";
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
