//
//  KCLoginAuthCodeVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCLoginAuthCodeVC.h"

#import "KCFillInfoView.h"
#import "KCBaseTabbarVC.h"

#import "UIImageView+WebCache.h"

#import "SWQRCodeViewController.h"
@interface KCLoginAuthCodeVC ()
@property (nonatomic, strong) KCFillInfoView *authCodeInfoView;
@end

@implementation KCLoginAuthCodeVC


#pragma mark - life cycle
/*
 * 生命周期
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
/*
 * 布局子视图
 */
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
    
    CGFloat imgwidth=82;
    CGFloat topspace=24;
    CGFloat butwidth=100;
    
    UIImageView *headIV=[[UIImageView alloc] init];
    [headIV setFrame:CGRectMake((KScreen_Width-imgwidth)/2.0, KSafeAreaTopNaviHeight+44, imgwidth, imgwidth)];
    [headIV setImage:KImage(@"超级好友")];
    headIV.tag=100;
    [self.view addSubview:headIV];
    
    UILabel *accountLab=[[UILabel alloc] init];
    [accountLab setFrame:CGRectMake(0, KSafeAreaTopNaviHeight+44+imgwidth+topspace, KScreen_Width, 20)];
    [accountLab setText:@"18249989599"];
    accountLab.tag=101;
    [accountLab setFont:AppointTextFontSecond];
    [accountLab setTextColor:APPOINTCOLORSecond];
    [accountLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:accountLab];
    
    self.authCodeInfoView = [[KCFillInfoView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+44+imgwidth+topspace*2+20, KScreen_Width-butwidth-20, 55)];
    _authCodeInfoView.textField.placeholder=@"请输入验证码";
    _authCodeInfoView.textField.textAlignment=NSTextAlignmentLeft;
    _authCodeInfoView.titleLab.text=@"验证码:";
    [self.view addSubview:self.authCodeInfoView];
    
    
    UIButton *getCodeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeBut setFrame:CGRectMake(KScreen_Width-butwidth-20, KSafeAreaTopNaviHeight+44+imgwidth+topspace*2+30, butwidth, 30)];
    [getCodeBut setTitle:@"验证码" forState:UIControlStateNormal];
    [getCodeBut.titleLabel setFont:AppointTextFontThird];
    [getCodeBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [getCodeBut addTarget:self action:@selector(getAuthCodeButClick:) forControlEvents:UIControlEventTouchUpInside];
    getCodeBut.layer.borderWidth=1;
    getCodeBut.layer.borderColor=APPOINTCOLORSecond.CGColor;
    getCodeBut.layer.cornerRadius=10;
    [self.view addSubview:getCodeBut];
    
    /* ****  登陆按钮  **** */
    UIButton *sureBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBut setFrame:CGRectMake(CWidth(15), KSafeAreaTopNaviHeight+44+imgwidth+topspace*3+20+55,KScreen_Width-CWidth(30), 50)];
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
 * 扫码登录
 */
-(void)scanButClick:(UIButton *)sender
{
    XLLog(@"  -  ");
    SWQRCodeViewController *VC=[[SWQRCodeViewController alloc] init];
    VC.jz_navigationBarHidden=YES;
    [self.navigationController pushViewController:VC animated:YES];
}
/*
 * <#description#>
 */
-(void)getAuthCodeButClick:(UIButton *)sender
{
    XLLog(@"- -");
    sender.selected=!sender.selected;
    [sender setTitle:@"重新获取" forState:UIControlStateNormal];
    [KCNetWorkManager POST:KNSSTR(@"/userController/sendSMSOfAppLogin") WithParams:@{@"phoneNum":self.datamodel.phone_Num} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([[NSString stringWithFormat:@"%@",response[@"code"]] isEqualToString:@"200"]) {
            [KCUIAlertTools showAlertWithTitle:@"" message:response[@"data"] cancelTitle:@"记住了" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
                
            }];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
/*
 * <#description#>
 */
-(void)sureButClick:(UIButton *)sender
{
    XLLog(@" - ");
    NSString *text=self.authCodeInfoView.textField.text;
    if (text.length==0) {
        [KCUIAlertTools showAlertWithTitle:@"" message:@"请填写验证码" cancelTitle:@"记住了" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
        return;
    }
    
    [KCNetWorkManager POST:KNSSTR(@"/userController/loginOfAppPhone") WithParams:@{@"phoneNum":_datamodel.phone_Num,@"authCode":text} ForSuccess:^(NSDictionary * _Nonnull response) {
        KCProfileInfoModel *model=[KCProfileInfoModel new];
        if ([response[@"success"] intValue]==1) {
            [model mj_setKeyValues:response[@"data"]];
            XLLog(@"model=%@",model);
            [KCUserDefaultManager setLoginStatus:YES];
            [KCUserDefaultManager setInfoModel:model];
            [KNotificationCenter postNotificationName:KCLoginInSuccessNoti object:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                KCBaseTabbarVC *TabbarVC=[[KCBaseTabbarVC alloc] init];
                self.view.window.rootViewController=TabbarVC;
            });
            
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark - delegate

#pragma mark - lazy loading


/*
 * 获取到了数据之后
 */
-(void)setDatamodel:(KCProfileInfoModel *)datamodel
{
    _datamodel=datamodel;
    UIImageView *iv=[self.view viewWithTag:100];
    UILabel *lab=[self.view viewWithTag:101];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",PhotoUrl,datamodel.headerIconStr];
    [iv sd_setImageWithURL:KNSURL(urlStr) placeholderImage:KImage(@"超级好友")];
    [lab setText:datamodel.phone_Num];
    
}
@end
