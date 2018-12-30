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
#import <ImSDK/ImSDK.h>

#import "KCProfileInfoModel.h"
#import "UIImage+XLCategory.h"

@interface KCTAPPStartADVC ()

@property (nonatomic, assign) BOOL receiveGeTui;

@end

@implementation KCTAPPStartADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *IV=[[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:IV];
    [IV setImage:[UIImage getLaunchImage]];

    [KNotificationCenter addObserver:self selector:@selector(webSocketLogOut:) name:kWebSocketDidCloseNote object:nil];
    [KNotificationCenter addObserver:self selector:@selector(loginSuccess) name:KCLoginInSuccessNoti object:nil];
    [KNotificationCenter addObserver:self selector:@selector(receiveGeTuiID) name:@"receiveGetuiClientId" object:nil];
    //[KNotificationCenter postNotificationName: object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self jumpToApp];
        });
    });
    
}

-(void)receiveGeTuiID
{
    _receiveGeTui=YES;
}
-(void)jumpToApp
{
    if ([KCUserDefaultManager getLoginStatus]) {
        [KCNetWorkManager POST:KNSSTR(@"/userInfoController/getBaseUserInfo") WithParams:@{} ForSuccess:^(NSDictionary * _Nonnull response) {
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

/* ****  socket断开  **** */
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
/* ****  登录  **** */
-(void)loginSuccess
{
    /* ****  获取联系人数据  **** */
   
    
    [self getContactData];
    [self connectChatServer];
    [self getGroupListData];
}
/* ****  获取联系人数据  **** */
-(void)getContactData
{
    
        [KCNetWorkManager POST:KNSSTR(@"/friendController/getFriendList") WithParams:@{} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                NSArray *tempArray=response[@"data"];
                NSMutableArray *contactArr=[[NSMutableArray alloc] init];
                for (NSDictionary *dic in tempArray) {
                    ContactRLMModel *model=[ContactRLMModel new];
                    [model mj_setKeyValues:dic];
                    [contactArr addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KCTRealmManager addOrUpdateObjects:contactArr];
                });
            }
        } AndFaild:^(NSError * _Nonnull error) {
    
        }];
}
/* ****  获取群组数据  **** */
-(void)getGroupListData
{
    
    [KCNetWorkManager Get:KNSSTR(@"/familyChatController/getFamilyChatList") WithParams:@{} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            for (NSDictionary *dic in response[@"data"]) {
                GroupRLMModel *model=[[GroupRLMModel alloc] init];
                [model mj_setKeyValues:dic];
                [KCTRealmManager addOrUpdateObject:model];
            }
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
/* ****  连接聊天服务器  **** */
-(void)connectChatServer
{
    BOOL webSockets=YES;
    [KCUserDefaultManager setIsTimServer:NO];
    if (webSockets) {
        [[KCWebSocketManager instance] SRWebSocketOpen];
    }else
    {
        TIMLoginParam *params=[[TIMLoginParam alloc] init];
        params.identifier=[KCUserDefaultManager getAccount];
        params.userSig=[KCUserDefaultManager getSig];
        params.appidAt3rd=@"1400170299";
        [[TIMManager sharedInstance] login:params succ:^{
            XLLog(@"tim login success");
            [KCUserDefaultManager setIsTimServer:YES];
        } fail:^(int code, NSString *msg) {
            XLLog(@"tim login fail %@",msg);
        }];
    }
}

@end
