//
//  KCTAPPStartADVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTAPPStartADVC.h"
#import "KCLoginHomeVC.h"
#import "KCBaseTabbarVC.h"
#import "KCLoginSecondTimeVC.h"

#import "KCWebSocketManager.h"

#import "KCProfileInfoModel.h"
#import "UIImage+XLCategory.h"
@interface KCTAPPStartADVC ()

@end

@implementation KCTAPPStartADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *IV=[[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:IV];
    [IV setImage:[UIImage getLaunchImage]];

    [KNotificationCenter addObserver:self selector:@selector(webSocketLogOut:) name:kWebSocketDidCloseNote object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self jumpToApp];
        });
    });
    
}



-(void)webSocketLogOut:(NSNotification *)noti
{
    XLLog(@"收到断开连接通知了");
    dispatch_async(dispatch_get_main_queue(), ^{
        [KCUserDefaultManager setLoginStatus:NO];
        KCLoginHomeVC *VC=[[KCLoginHomeVC alloc] init];
        UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:VC];
        VC.navigationController.navigationBar.hidden=YES;
        KCLoginSecondTimeVC *VC2=[[KCLoginSecondTimeVC alloc] init];
        navi.viewControllers=@[VC,VC2];
        self.view.window.rootViewController=navi;
    });
}



-(void)jumpToApp
{
    if ([KCUserDefaultManager getLoginStatus]) {
        [KCNetWorkManager POST:KNSSTR(@"/userInfoController/getUserInfoByAccount") WithParams:@{@"account":[KCUserDefaultManager getAccount]} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                KCProfileInfoModel *model=[KCProfileInfoModel new];
                [model mj_setKeyValues:response[@"data"]];
                model.authorization=[KCUserDefaultManager getSigen];
                [KCUserDefaultManager setInfoModel:model];
                [KNotificationCenter postNotificationName:KCLoginInSuccessNoti object:nil];
                KCBaseTabbarVC *TabbarVC=[[KCBaseTabbarVC alloc] init];
                self.view.window.rootViewController=TabbarVC;
            }else
            {
                [KCUserDefaultManager setLoginStatus:NO];
                KCLoginHomeVC *VC=[[KCLoginHomeVC alloc] init];
                UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:VC];
                VC.navigationController.navigationBar.hidden=YES;
                KCLoginSecondTimeVC *VC2=[[KCLoginSecondTimeVC alloc] init];
                navi.viewControllers=@[VC,VC2];
                self.view.window.rootViewController=navi;
            }
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
    }else if([KCUserDefaultManager getAccount].length==0)
    {
        KCLoginHomeVC *VC=[[KCLoginHomeVC alloc] init];
        UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:VC];
        VC.navigationController.navigationBar.hidden=YES;
        self.view.window.rootViewController=navi;
        
    }else
    {
        KCLoginHomeVC *VC=[[KCLoginHomeVC alloc] init];
        UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:VC];
        VC.navigationController.navigationBar.hidden=YES;
        KCLoginSecondTimeVC *VC2=[[KCLoginSecondTimeVC alloc] init];
        navi.viewControllers=@[VC,VC2];
        self.view.window.rootViewController=navi;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
