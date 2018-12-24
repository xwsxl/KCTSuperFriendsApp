//
//  KCRegisterAccountVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCRegisterAccountVC.h"
#import "KCRegisterFillInfoVC.h"
#import "KCFillInfoView.h"
@interface KCRegisterAccountVC ()

@property (nonatomic, strong) KCFillInfoView *accountFillInfoView;
@property (nonatomic, strong) KCFillInfoView *passwordFillInfoView;
@property (nonatomic, strong) KCFillInfoView *surePasswordFillInfoView;

@end

@implementation KCRegisterAccountVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}
#pragma mark - SetUI
/*
 * 创建UI界面
 */
-(void)setSubViews
{
    [super setSubViews];
    XLLog(@"请输入账号");
//    self.navigationController.navigationBar.hidden=NO;
//    self.title=@"注册";

    XLNaviView *navi=[[XLNaviView alloc] initWithMessage:@"注册" ImageName:@""];
    __weak typeof(self) weakself=self;
    navi.qurtBlock = ^{
        [weakself qurtButClick];
    };
    [self.view addSubview:navi];
    
    self.accountFillInfoView =[[KCFillInfoView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, 45)];
    _accountFillInfoView.titleLab.text=@"账号";
    _accountFillInfoView.textField.placeholder=@"请输入账号";
    [self.view addSubview:self.accountFillInfoView];
    
    self.passwordFillInfoView=[[KCFillInfoView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+45, KScreen_Width, 45)];
    _passwordFillInfoView.titleLab.text=@"密码";
    _passwordFillInfoView.textField.placeholder=@"密码不少于6位";
    [self.view addSubview:self.passwordFillInfoView];
    
    self.surePasswordFillInfoView=[[KCFillInfoView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+90, KScreen_Width, 45)];
    _surePasswordFillInfoView.titleLab.text=@"确认密码";
    _surePasswordFillInfoView.textField.placeholder=@"密码不少于6位";
    [self.view addSubview:self.surePasswordFillInfoView];
    
    /* ****  下一步  **** */
    UIButton *KCRegisterNextBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [KCRegisterNextBut setFrame:CGRectMake(CWidth(29), KSafeAreaTopNaviHeight+135+30, CWidth(317.5), 50)];
    [KCRegisterNextBut setBackgroundColor:RGBHexAlpha(0x008ffb, 1.0)];
    KCRegisterNextBut.layer.cornerRadius=5;

    CAGradientLayer *galayer=[CAGradientLayer layer];
    galayer.frame=KCRegisterNextBut.bounds;
    galayer.startPoint=CGPointMake(0, 0);
    galayer.endPoint=CGPointMake(1, 1);
    galayer.locations=@[@(0),@(1)];
    [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
    
    galayer.cornerRadius=5;
    [KCRegisterNextBut.layer addSublayer:galayer];
    [KCRegisterNextBut setTitle:@"下一步" forState:UIControlStateNormal];
    [KCRegisterNextBut addTarget:self action:@selector(KCRegisterNextButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:KCRegisterNextBut];
    
}
#pragma mark - test


#pragma mark - events
/*
 * 下一步
 */
-(void)KCRegisterNextButClick:(UIButton *)sender
{
    
    XLLog(@"I love you baby....");
    NSString *pw=_passwordFillInfoView.textField.text;
    NSString *Spw=_surePasswordFillInfoView.textField.text;
    if ((pw.length<6)||(Spw.length<6)) {
        [KCUIAlertTools showAlertWithTitle:@"" message:@"请输入正确的密码,密码至少为6位数字或字母" cancelTitle:@"确定" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
        return;
    }
    if (![pw isEqualToString:Spw]) {
        [KCUIAlertTools showAlertWithTitle:@"" message:@"两次输入密码不一致" cancelTitle:@"确定" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
        return;
    }
    KCRegisterFillInfoVC *VC=[[KCRegisterFillInfoVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

/*
 * 如果我们不选择堕落.那么地狱的存在又有什么意义
 */

@end
