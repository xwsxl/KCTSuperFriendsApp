//
//  KCLoginAccountLoginVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/16.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCLoginAccountLoginVC.h"
#import "SWQRCodeViewController.h"
#import "KCLoginAuthCodeVC.h"
#import "KCVoicePasswordLoginVC.h"
#import "KCLoginSecondTimeVC.h"
#import "KCBaseTabbarVC.h"

#import "KCFillInfoView.h"

@interface KCLoginAccountLoginVC ()<UITabBarControllerDelegate>
/* ****  - -  **** */
@property (nonatomic, strong) KCFillInfoView *accountFillInfoView;
/* ****  - -  **** */
@end

@implementation KCLoginAccountLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setSubViews
{
    [super setSubViews];
    UIButton *qurtBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [qurtBut setImage:KImage(@"KCNaviBar-返回") forState:UIControlStateNormal];
    [qurtBut setFrame:CGRectMake(8, 32+KSafeTopHeight, 12, 21)];
    [qurtBut addTarget:self action:@selector(qurtButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qurtBut];
    
    UIButton *scanBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [scanBut setImage:KImage(@"KCLogin-扫码用户线索") forState:UIControlStateNormal];
    [scanBut setFrame:CGRectMake(KScreen_Width-15-32, 25+KSafeTopHeight, 32, 32)];
    [scanBut addTarget:self action:@selector(scanButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBut];
    
    self.accountFillInfoView = [[KCFillInfoView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, 45)] ;
    _accountFillInfoView.titleLab.text = @"账号";
    _accountFillInfoView.textField.placeholder = @"请输入账号/手机号";
    [self.view addSubview:_accountFillInfoView];
    
    /* ****  下一步  **** */
    UIButton *KCAccountLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [KCAccountLoginBut setFrame:CGRectMake(15, KSafeAreaTopNaviHeight+CHeight(102), KScreen_Width-30, 50)];
    [KCAccountLoginBut setBackgroundColor:RGBHexAlpha(0x008ffb, 1.0)];
    KCAccountLoginBut.layer.cornerRadius=5;
    CAGradientLayer *galayer=[CAGradientLayer layer];
    galayer.frame=KCAccountLoginBut.bounds;
    galayer.startPoint=CGPointMake(0, 0);
    galayer.endPoint=CGPointMake(1, 1);
    galayer.locations=@[@(0),@(1)];
    [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
    galayer.cornerRadius=5;
    [KCAccountLoginBut.layer addSublayer:galayer];
    [KCAccountLoginBut setTitle:@"下一步" forState:UIControlStateNormal];
    [KCAccountLoginBut addTarget:self action:@selector(KCAccountLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:KCAccountLoginBut];
    
    XLLog(@"Baby,I love you...!");
    
}

#pragma mark - events
/*
 * 下一步
 */
-(void)KCAccountLoginButClick:(UIButton *)sender
{
    XLLog(@"下一步");
    NSString *str=_accountFillInfoView.textField.text;
    
    if (str.length<=0) {
        return;
    }
    
    [KCNetWorkManager POST:KNSSTR(@"/userController/beforeLogin") WithParams:@{@"account":str} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([[NSString stringWithFormat:@"%@",response[@"code"]] isEqualToString:@"200"]&&![response[@"data"] isEqual:[[NSNull alloc] init]]) {
            
            NSDictionary *dic=response[@"data"];
            KCProfileInfoModel *model=[KCProfileInfoModel new];
            model.headerIconStr=dic[@"portraitUri"];
            model.client_id=dic[@"clientId"];
            model.nickName=dic[@"nickName"];
            model.sex=dic[@"sex"];
            model.account_type=dic[@"accountType"];
            if ([str phoneNumberIsCorrect]) {
                model.phone_Num=str;
            }
            model.accountName=dic[@"account"];
            [KCUserDefaultManager setInfoModel:model];
            KCLoginSecondTimeVC *VC=[[KCLoginSecondTimeVC alloc] init];
            [self.navigationController pushViewController:VC animated:YES];

        }else
        {
            [KCUIAlertTools showAlertWithTitle:@"" message:response[@"msg"] cancelTitle:@"知道了" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
                
            }];
        }
        
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}

/*
 * 扫一扫
 */
-(void)scanButClick:(UIButton *)sender
{
    XLLog(@"扫一扫");
    SWQRCodeViewController *VC=[[SWQRCodeViewController alloc] init];
    VC.jz_navigationBarHidden=YES;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
