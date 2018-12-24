//
//  KCFirstVoicePasswordSettedVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCFirstVoicePasswordSettedVC.h"
#import "KCSetVoicePasswordVC.h"
@interface KCFirstVoicePasswordSettedVC ()

@end

@implementation KCFirstVoicePasswordSettedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

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
//    if (_isReset) {
//        [but setHidden:YES];
//    }
    UILabel *titleLab=[[UILabel alloc] init];
    titleLab.frame=CGRectMake(0, KSafeTopHeight+CHeight(149), KScreen_Width, 18);
    titleLab.font=AppointTextFontSecond;
    titleLab.textColor=APPOINTCOLORSecond;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.text=@"已录入一次声纹";
    [self.view addSubview:titleLab];
    
    /* ****  下一步  **** */
    UIButton *KCAccountLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [KCAccountLoginBut setFrame:CGRectMake(28, KScreen_Height-KSafeAreaBottomHeight-CHeight(110), KScreen_Width-56, 50)];
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
    [KCAccountLoginBut setTitle:@"再一遍" forState:UIControlStateNormal];
    [KCAccountLoginBut addTarget:self action:@selector(nextMoreTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:KCAccountLoginBut];
}

-(void)nextMoreTime:(UIButton *)sender
{
    KCSetVoicePasswordVC *VC=[[KCSetVoicePasswordVC alloc] init];
    VC.isReset=_isReset;
    VC.voiceOptions=KCSetVoicePasswordTypeSecond;
    [self.navigationController pushViewController:VC animated:YES];
    
}


@end
