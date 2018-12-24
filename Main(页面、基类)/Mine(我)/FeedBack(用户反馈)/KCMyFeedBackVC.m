//
//  KCMyFeedBackVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/23.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMyFeedBackVC.h"

@interface KCMyFeedBackVC ()

@end

@implementation KCMyFeedBackVC


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
/*
 * 布局
 */
-(void)setSubViews
{
    [super setSubViews];
    XLNaviView *navi=[[XLNaviView alloc] initWithMessage:@"用户反馈" ImageName:@""];
    __weak typeof(self) weakself=self;
    navi.qurtBlock = ^{
        [weakself qurtButClick];
    };
    [self.view addSubview:navi];
    
    [self.view setBackgroundColor:MAINSEPRATELINECOLOR];
    
    UIView *feedBackView=[[UIView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+CWidth(6), KScreen_Width, CWidth(271))];
    [feedBackView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:feedBackView];
    
    UIView *cellphoneBackView=[[UIView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+CWidth(6)+CWidth(271)+CWidth(6), KScreen_Width, 51)];
    [cellphoneBackView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:cellphoneBackView];
    
    UIButton *sureBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBut setFrame:CGRectMake(15, KSafeAreaTopNaviHeight+CWidth(6+271+6+62)+51, KScreen_Width-30, 50)];
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
    [sureBut setTitle:@"扫码登录" forState:UIControlStateNormal];
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
    XLLog(@"sureBut...");
}
#pragma mark - delegate

#pragma mark - lazy loading


@end
