//
//  KCLoginSecondTimeVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCLoginSecondTimeVC.h"

#import "SWQRCodeViewController.h"
#import "KCLoginAccountLoginVC.h"
#import "KCLoginAuthCodeVC.h"
#import "KCVoicePasswordLoginVC.h"
#import "KCSetVoicePasswordVC.h"

#import "UIImageView+WebCache.h"
@interface KCLoginSecondTimeVC ()

@end

@implementation KCLoginSecondTimeVC


#pragma mark - life cycle
/*
 * 生命周期
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - setUI
/*
 * 布局子视图
 */
-(void)setSubViews
{
    [super setSubViews];
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(15, 42+KSafeTopHeight, 40,20)];
    [but setTitle:@"取消" forState:UIControlStateNormal];
    [but setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [but.titleLabel setFont:AppointTextFontSecond];
    [but addTarget:self action:@selector(qurtButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UIButton *scanQRCodeLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [scanQRCodeLoginBut setFrame:CGRectMake(KScreen_Width-57, KSafeTopHeight+15, 52, 52)];
    [scanQRCodeLoginBut setImage:KImage(@"KCLogin-扫码用户线索") forState:UIControlStateNormal];
    [scanQRCodeLoginBut addTarget:self action:@selector(scanQRCodeLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanQRCodeLoginBut];
    
    CGFloat imgwidth=82;
    CGFloat topspace=24;
    
    UIImageView *headIV=[[UIImageView alloc] init];
    [headIV setFrame:CGRectMake((KScreen_Width-imgwidth)/2.0, KSafeAreaTopNaviHeight+10+14+15, imgwidth, imgwidth)];
    headIV.tag=100;
    [headIV sd_setImageWithURL:KNSPHOTOURL(_model.headerIconStr) placeholderImage:KImage(@"超级好友")];
    
    [self.view addSubview:headIV];
    
    UILabel *accountLab=[[UILabel alloc] init];
    accountLab.tag=101;
    [accountLab setFont:AppointTextFontSecond];
    [accountLab setTextColor:APPOINTCOLORSecond];
    [accountLab setText:self.model.accountName];
    [accountLab setFrame:CGRectMake(0, KSafeAreaTopNaviHeight+10+imgwidth+35, KScreen_Width, 24)];
    [accountLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:accountLab];
    
    UIButton *changeAccountBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [changeAccountBut setFrame:CGRectMake((KScreen_Width-100)/2.0, KSafeAreaTopNaviHeight+10+imgwidth+topspace*2+24, 100, 30)];
    [changeAccountBut setTitle:@"切换账号" forState:UIControlStateNormal];
    [changeAccountBut.titleLabel setFont:AppointTextFontSecond];
    [changeAccountBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [changeAccountBut addTarget:self action:@selector(changeAccountButClick:) forControlEvents:UIControlEventTouchUpInside];
    [changeAccountBut.layer setBorderWidth:1];
    [changeAccountBut.layer setBorderColor:APPOINTCOLORSecond.CGColor];
    [changeAccountBut.layer setCornerRadius:15];
    [self.view addSubview:changeAccountBut];
    
    UIButton *voicePWLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [voicePWLoginBut setFrame:CGRectMake(CWidth(15), KSafeAreaTopNaviHeight+10+imgwidth+topspace*4+24+30, KScreen_Width-CWidth(30), 50)];
    [voicePWLoginBut.layer setCornerRadius:15];
    [voicePWLoginBut setBackgroundColor:RGBHexAlpha(0x008ffb, 1.0)];
    CAGradientLayer *galayer=[CAGradientLayer layer];
    galayer.frame=voicePWLoginBut.bounds;
    galayer.startPoint=CGPointMake(0, 0);
    galayer.endPoint=CGPointMake(1, 1);
    galayer.locations=@[@(0),@(1)];
    [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
    galayer.cornerRadius=15;
    [voicePWLoginBut.layer addSublayer:galayer];
    [voicePWLoginBut setTitle:@"声音锁登录" forState:UIControlStateNormal];
    [voicePWLoginBut.titleLabel setFont:AppointTextFontSecond];
    [voicePWLoginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [voicePWLoginBut addTarget:self action:@selector(voicePasswordLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voicePWLoginBut];
    
    UIButton *phoneAuthCodeLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [phoneAuthCodeLoginBut setFrame:CGRectMake(CWidth(15), KSafeAreaTopNaviHeight+10+imgwidth+topspace*5+24+30+50, KScreen_Width-CWidth(30), 50)];
    [phoneAuthCodeLoginBut setTitle:@"手机验证登录" forState:UIControlStateNormal];
    [phoneAuthCodeLoginBut.layer setBorderWidth:1];
    [phoneAuthCodeLoginBut.layer setBorderColor:RGB(211, 211, 211).CGColor];
    [phoneAuthCodeLoginBut.layer setCornerRadius:15.0];
    [phoneAuthCodeLoginBut.titleLabel setFont:AppointTextFontSecond];
    [phoneAuthCodeLoginBut setTitleColor:APPOINTCOLORThird forState:UIControlStateNormal];
    [phoneAuthCodeLoginBut addTarget:self action:@selector(phoneAuthCodeLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneAuthCodeLoginBut];
    
    
    UIButton *resetPassWordBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [resetPassWordBut setFrame:CGRectMake(KScreen_Width-65-10, KSafeAreaTopNaviHeight+10+imgwidth+topspace*5+24+30+50+50+10, 65, 17)];
    [resetPassWordBut setTitle:@"重置声纹" forState:UIControlStateNormal];
    [resetPassWordBut.titleLabel setFont:AppointTextFontSecond];
    [resetPassWordBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [resetPassWordBut addTarget:self action:@selector(resetPassWordButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetPassWordBut];
    
  
}
#pragma mark - network

#pragma mark - events
/*
 * 扫码登录
 */
-(void)scanQRCodeLoginButClick:(UIButton *)sender
{
    SWQRCodeViewController *VC=[[SWQRCodeViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    XLLog(@"");
}

/*
 * 切换账号
 */
-(void)changeAccountButClick:(UIButton *)sender
{
    KCLoginAccountLoginVC *VC=[[KCLoginAccountLoginVC alloc] init];
    [self.navigationController jz_pushViewController:VC
                                            animated:YES completion:nil];
}
/*
 * 声音锁登录
 */
-(void)voicePasswordLoginButClick:(UIButton *)sender
{
    KCVoicePasswordLoginVC *VC=[[KCVoicePasswordLoginVC alloc] init];
    VC.datamodel=[KCUserDefaultManager getInfoModel];
    [self.navigationController jz_pushViewController:VC
                                            animated:YES completion:nil];
}
/*
 * 重置声纹密码
 */
-(void)resetPassWordButClick:(UIButton *)sender
{
    XLLog(@"0.0.0.0.0.0");
    [KCNetWorkManager POST:KNSSTR(@"/userController/applyUpdatePwd") WithParams:@{@"account":_model.accountName} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            if ([response[@"data"] intValue]==1) {
                KCSetVoicePasswordVC *VC=[[KCSetVoicePasswordVC alloc] init];
                VC.isReset=YES;
                [self.navigationController pushViewController:VC animated:YES];
            }else
            {
                
                [KCUIAlertTools showAlertWithTitle:@"申请成功" message:@"请在家长端确认申请" cancelTitle:@"确定" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
                 
                }];
                
            }
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
/*
 * 手机验证码登录
 */
-(void)phoneAuthCodeLoginButClick:(UIButton *)sender
{
    if (_model.phone_Num.length>0&&([_model.phone_Num phoneNumberIsCorrect]))
    {
        KCLoginAuthCodeVC *VC=[[KCLoginAuthCodeVC alloc] init];
        VC.datamodel=[KCUserDefaultManager getInfoModel];
        [self.navigationController jz_pushViewController:VC
                                                animated:YES completion:nil];
    }
}
#pragma mark - delegate

#pragma mark - lazy loading
-(KCProfileInfoModel *)model
{
    if (!_model) {
        _model=[KCUserDefaultManager getInfoModel];
    }
    return _model;
}
@end
