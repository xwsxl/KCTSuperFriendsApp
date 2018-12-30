//
//  KCLoginBDPhoneVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCLoginBDPhoneVC.h"

#import "KCFillInfoView.h"

@interface KCLoginBDPhoneVC ()

@property (nonatomic, strong) KCFillInfoView *fillIphoneInfoView;

@end


@implementation KCLoginBDPhoneVC

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
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc] initWithImage:[KImage(@"KCLogin-叉") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(qurtButClick)];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    self.title=@"绑定手机";
    
    _fillIphoneInfoView=[[KCFillInfoView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, 55)];
    [_fillIphoneInfoView.titleLab setText:@"手机号"];
    [_fillIphoneInfoView.textField setPlaceholder:@"输入手机号"];
    [self.view addSubview:self.fillIphoneInfoView];
    
    UITextField *authCodeTF=[[UITextField alloc] init];
    authCodeTF.placeholder=@"填写验证码";
    authCodeTF.font=AppointTextFontSecond;
    authCodeTF.tag=1000;
    authCodeTF.frame=CGRectMake(15, KSafeAreaTopNaviHeight+55+10, KScreen_Width-30-80, 35);
    [self.view addSubview:authCodeTF];
    
    UIButton *getAuthCodeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [getAuthCodeBut setFrame:CGRectMake(KScreen_Width-100, KSafeAreaTopNaviHeight+55+10, 80, 35)];
    [getAuthCodeBut setTitle:@"获取验证" forState:UIControlStateNormal];
    [getAuthCodeBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [getAuthCodeBut.titleLabel setFont:AppointTextFontSecond];
    [getAuthCodeBut addTarget:self action:@selector(getAuthCodeButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getAuthCodeBut];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(15, KSafeAreaTopNaviHeight+55+54, KScreen_Width-30, 1)];
    [line setBackgroundColor:APPOINTCOLORFifth];
    [self.view addSubview:line];
    
    /* ****  登陆按钮  **** */
    UIButton *sureBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBut setFrame:CGRectMake(CWidth(15), KSafeAreaTopNaviHeight+110+CHeight(30),KScreen_Width-CWidth(30), 50)];
    [sureBut setBackgroundColor:RGBHexAlpha(0x008ffb, 1.0)];
    sureBut.layer.cornerRadius=5;
    CAGradientLayer *galayer=[CAGradientLayer layer];
    galayer.frame=sureBut.bounds;
    galayer.startPoint=CGPointMake(0, 0);
    galayer.endPoint=CGPointMake(1, 1);
    galayer.locations=@[@(0),@(1)];
    [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
    galayer.cornerRadius=5;
    [sureBut.layer addSublayer:galayer];
    [sureBut setTitle:@"确定" forState:UIControlStateNormal];
    [sureBut addTarget:self action:@selector(sureButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBut];
    
    
}
#pragma mark - network


#pragma mark - events
/*
 * 确定
 */
-(void)sureButClick:(UIButton *)sender
{
    XLLog(@"- - -");
    UITextField *tf=[self.view viewWithTag:1000];
    NSString *authCode=tf.text;
    [KCNetWorkManager POST:KNSSTR(@"/userInfoController/updateUserInfo") WithParams:@{@"nickName":[KCUserDefaultManager getNickName],@"portraitUri":[KCUserDefaultManager getHeaderIconStr],@"sex":@([[KCUserDefaultManager getSex] integerValue]),@"phoneNum":_fillIphoneInfoView.textField.text,@"authCode":authCode} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            [self qurtButClick];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
    
}

/*
 * 获取验证码
 */
-(void)getAuthCodeButClick:(UIButton *)sender
{
    XLLog(@" --- ");
    NSString *phoneNum=self.fillIphoneInfoView.textField.text;
    if (phoneNum.length==0) {
        [KCUIAlertTools showAlertWithTitle:@"" message:@"请输入手机号" cancelTitle:@"确定" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
    }else if (![phoneNum phoneNumberIsCorrect])
    {
        [KCUIAlertTools showAlertWithTitle:@"" message:@"请输入正确的手机号" cancelTitle:@"确定" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
    }
    [KCNetWorkManager POST:KNSSTR(@"/userInfoController/sendSMSOfBindPhone") WithParams:@{@"phoneNum":phoneNum} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            [KCUIAlertTools showAlertWithTitle:@"" message:response[@"data"] cancelTitle:@"确定" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
                
            }];
        }else
        {
            [KCUIAlertTools showAlertWithTitle:@"" message:@"验证码发送失败" cancelTitle:@"确定" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
                
            }];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - delegate


#pragma mark - lazy loading


@end
