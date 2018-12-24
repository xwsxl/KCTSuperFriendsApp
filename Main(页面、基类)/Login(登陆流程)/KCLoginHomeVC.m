//
//  KCLoginHomeVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCLoginHomeVC.h"
#import "KCRegisterAccountVC.h"
#import "KCLoginAccountLoginVC.h"
#import "SWQRCodeViewController.h"
#import "KCLoginSecondTimeVC.h"

@interface KCLoginHomeVC ()

@end

@implementation KCLoginHomeVC

#pragma mark - life cycle
/*
 * 视图已经加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setUI];
    // Do any additional setup after loading the view.
}
#pragma mark - events
/*
 * 注册
 */
-(void)RegisterButClick:(UIButton *)sender
{
    KCRegisterAccountVC *VC=[[KCRegisterAccountVC alloc] init];
    VC.jz_navigationBarHidden=YES;
    [self.navigationController pushViewController:VC animated:YES];
    XLLog(@"accountLoginButClick");
}

/*
 * 扫描登陆
 */
-(void)scanQRCodeLoginButClick:(UIButton *)sender
{
    XLLog(@"ScanQRCodeLoginButClick");
    
    SWQRCodeViewController *VC=[[SWQRCodeViewController alloc] init];
    VC.jz_navigationBarHidden=YES;
    [self.navigationController pushViewController:VC animated:YES];
}

/*
 * 账户登陆
 */
-(void)accountLoginButClick:(UIButton *)sender
{
 
    XLLog(@"accountLoginButClick");
    if ([KCUserDefaultManager getAccount].length==0) {
        /* ****  第一次登录  **** */
        KCLoginAccountLoginVC *VC=[[KCLoginAccountLoginVC alloc] init];
        VC.jz_navigationBarHidden=YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else
    {
        /* ****  不是第一次登录  **** */
        KCLoginSecondTimeVC *VC=[[KCLoginSecondTimeVC alloc] init];
        VC.jz_navigationBarHidden=YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

/*
 * 隐私政策点击
 */
-(void)agreePrivateButClick:(UIButton *)sender
{

    XLLog(@"agreePrivateButClick");

}

#pragma mark - SetUI
/**
 设置UI界面
 */
-(void)setUI
{
    CGFloat top=KSafeTopHeight;
    CGFloat bottom=KSafeAreaBottomHeight;
    CGFloat navi=KSafeAreaTopNaviHeight;
    XLLog(@"top=%.2f",top);
    XLLog(@"bottom=%.2f",bottom);
    XLLog(@"navi=%.2f",navi);
    
    /* ****  背景图  **** */
    UIImageView *BackIv=[[UIImageView alloc] initWithFrame:KScreen_Bounds];
    [self.view insertSubview:BackIv atIndex:0];
    
    /* ****  注册按钮  **** */
    UIButton *scanQRCodeLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [scanQRCodeLoginBut setFrame:CGRectMake(KScreen_Width-57, KSafeTopHeight+15, 52, 52)];
    [scanQRCodeLoginBut setImage:KImage(@"KCLogin-扫码用户线索") forState:UIControlStateNormal];
    [scanQRCodeLoginBut addTarget:self action:@selector(scanQRCodeLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanQRCodeLoginBut];
    
    /* ****  超级好友logo  **** */
    UIImageView *LogoIV=[[UIImageView alloc] initWithFrame:CGRectMake(CWidth(135), KSafeTopHeight+CHeight(149), CWidth(105), CWidth(105))];
    [LogoIV setImage:KImage(@"超级好友")];
    [self.view addSubview:LogoIV];
    
    /* ****  超级好友标题  **** */
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, KSafeTopHeight+CWidth(278), KScreen_Width, 27)];
    [titleLab setText:@"超级好友"];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setFont:AppointTextFontFirst];
    [titleLab setTextColor:APPOINTCOLORSecond];
    [self.view addSubview:titleLab];
    
    
    /* ****  登陆按钮  **** */
    UIButton *accountLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [accountLoginBut setFrame:CGRectMake(CWidth(10), KSafeTopHeight+CHeight(591),(KScreen_Width-CWidth(28))/2, 50)];
    [accountLoginBut setBackgroundColor:RGBHexAlpha(0x008ffb, 1.0)];
    accountLoginBut.layer.cornerRadius=5;
    CAGradientLayer *galayer=[CAGradientLayer layer];
    galayer.frame=accountLoginBut.bounds;
    galayer.startPoint=CGPointMake(0, 0);
    galayer.endPoint=CGPointMake(1, 1);
    galayer.locations=@[@(0),@(1)];
    [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
    galayer.cornerRadius=5;
    [accountLoginBut.layer addSublayer:galayer];
    [accountLoginBut setTitle:@"登录" forState:UIControlStateNormal];
    [accountLoginBut addTarget:self action:@selector(accountLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountLoginBut];
    
    /* ****  注册  **** */
    UIButton *RegisterBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [RegisterBut setFrame:CGRectMake(CWidth(18)+(KScreen_Width-CWidth(28))/2, KSafeTopHeight+CHeight(591), (KScreen_Width-CWidth(28))/2, 50)];
    [RegisterBut.layer setCornerRadius:5];
    [RegisterBut.layer setBorderWidth:1];
    [RegisterBut.layer setBorderColor:RGBHex(0x008dfb).CGColor];
    [RegisterBut setTitleColor:APPOINTCOLORThird forState:UIControlStateNormal];
    [RegisterBut setTitle:@"注册" forState:UIControlStateNormal];
    [RegisterBut addTarget:self action:@selector(RegisterButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegisterBut];
    
    /* ****  隐私政策  **** */
    /*
        UIButton *agreePrivateBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [agreePrivateBut setFrame:CGRectMake(0, KSafeTopHeight+CHeight(615),KScreen_Width, 24)];
        [agreePrivateBut setTitleColor:APPOINTCOLORFirst forState:UIControlStateNormal];
        [agreePrivateBut.titleLabel setFont:AppointTextFontFourth];
        [agreePrivateBut setTitle:@"已阅读并同意软件服务协议及隐私政策" forState:UIControlStateNormal];
        [agreePrivateBut addTarget:self action:@selector(agreePrivateButClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:agreePrivateBut];
    */
    
}

/* ****  隐藏状态栏  **** */
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
