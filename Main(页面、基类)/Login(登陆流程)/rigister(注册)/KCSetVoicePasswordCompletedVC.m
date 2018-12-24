//
//  KCSetVoicePasswordCompletedVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCSetVoicePasswordCompletedVC.h"
#import "KCSetVoicePasswordVC.h"

@interface KCSetVoicePasswordCompletedVC ()
@end
@implementation KCSetVoicePasswordCompletedVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setSubViews
{
    [super setSubViews];
    CGFloat IVWidth=89;
    CGFloat topSpace=15;
    CGFloat marin=12;
    /* ****  成功失败图标  **** */
    UIImageView *iv=[[UIImageView alloc] init];
    iv.frame=CGRectMake((KScreen_Width-IVWidth)/2.0, KSafeAreaTopNaviHeight+42, IVWidth, IVWidth);
    iv.tag=100;
    [self.view addSubview:iv];
    /* ****  注释  **** */
    UILabel *lab=[[UILabel alloc] init];
    lab.frame=CGRectMake(0, KSafeAreaTopNaviHeight+42+topSpace+IVWidth, KScreen_Width, 20);
    lab.font=AppointTextFontMain;
    lab.textColor=APPOINTCOLORSecond;
    lab.textAlignment=NSTextAlignmentCenter;
    lab.tag=101;
    [self.view addSubview:lab];
    /* ****  详细说明  **** */
    UILabel *detailLab=[[UILabel alloc] init];
    detailLab.frame=CGRectMake(0, KSafeAreaTopNaviHeight+42+topSpace+20+topSpace+IVWidth, KScreen_Width, 14);
    detailLab.font=AppointTextFontThird;
    detailLab.textColor=APPOINTCOLORFifth;
    detailLab.textAlignment=NSTextAlignmentCenter;
    detailLab.tag=102;
    [self.view addSubview:detailLab];
    /* ****  底部按钮  **** */
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(marin, KScreen_Height-KSafeAreaBottomHeight-CHeight(150), KScreen_Width-2*marin, 50)];
    [but addTarget:self action:@selector(bottomButClick:) forControlEvents:UIControlEventTouchUpInside];
    but.tag=103;
    [self.view addSubview:but];
}
-(void)setVoiceStatusOption:(KCSetVoiceStatusOptions)voiceStatusOption{
    _voiceStatusOption=voiceStatusOption;
    [self setDataIntoSubviews];
}
-(void)setDataIntoSubviews
{
    UIImageView *iv=[self.view viewWithTag:100];
    UILabel *lab=[self.view viewWithTag:101];
    UILabel *detailLab=[self.view viewWithTag:102];
    UIButton *but=[self.view viewWithTag:103];
    if (_voiceStatusOption==0) {
        /* ****  设置成功  **** */
        [iv setImage:KImage(@"KCLogin-成功")];
        lab.text=@"声音锁设置成功";
        detailLab.text=@"将可通过声音登录超级好友";
        [but setBackgroundColor:RGBHexAlpha(0x008ffb, 1.0)];
        but.layer.cornerRadius=5;
        CAGradientLayer *galayer=[CAGradientLayer layer];
        galayer.frame=but.bounds;
        galayer.startPoint=CGPointMake(0, 0);
        galayer.endPoint=CGPointMake(1, 1);
        galayer.locations=@[@(0),@(1)];
        [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
        galayer.cornerRadius=5;
        [but.layer addSublayer:galayer];
        [but setTitle:@"验证声纹" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if(_voiceStatusOption==1)
    {
        /* ****  设置失败  **** *//* ****  设置失败  **** */
        [iv setImage:KImage(@"KCLogin-失败")];
        lab.text=@"声音密码设置失败";
        detailLab.text=@"无法通过声音登录超级好友";
        [but setBackgroundColor:RGB(161, 161, 161)];
        [but setTitle:@"知道了" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else
    {
        /* ****  验证失败  **** */
        [iv setImage:KImage(@"KCLogin-失败")];
        lab.text=@"声音不匹配，重新注册";
        detailLab.text=@"";
        [but setBackgroundColor:RGBHexAlpha(0x008ffb, 1.0)];
        but.layer.cornerRadius=5;
        CAGradientLayer *galayer=[CAGradientLayer layer];
        galayer.frame=but.bounds;
        galayer.startPoint=CGPointMake(0, 0);
        galayer.endPoint=CGPointMake(1, 1);
        galayer.locations=@[@(0),@(1)];
        [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
        galayer.cornerRadius=5;
        [but.layer addSublayer:galayer];
        [but setTitle:@"重新注册" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
#pragma mark - events
/* ****  <#description#>  **** */
-(void)bottomButClick:(UIButton *)sender
{
    XLLog(@"bottom but click...");
    if (_voiceStatusOption==0) {
        /* ****  声纹设置成功  **** */
        KCSetVoicePasswordVC *VC=[[KCSetVoicePasswordVC alloc] init];
        VC.isReset=_isReset;
        VC.voiceOptions=KCSetVoicePasswordTypeNotify;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if (_voiceStatusOption==1)
    {
        /* ****  声纹设置失败  **** */
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else
    {
        /* ****  验证失败  **** */
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
@end

