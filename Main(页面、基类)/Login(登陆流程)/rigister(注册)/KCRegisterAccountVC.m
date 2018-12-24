//
//  KCRegisterAccountVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCRegisterAccountVC.h"
#import "KCSetVoicePasswordVC.h"

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

    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(15, 42+KSafeTopHeight, 40,20)];
    [but setTitle:@"取消" forState:UIControlStateNormal];
    [but setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [but.titleLabel setFont:AppointTextFontSecond];
    [but addTarget:self action:@selector(qurtButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UILabel *titleLab=[[UILabel alloc] init];
    titleLab.frame=CGRectMake(0, KSafeTopHeight+CHeight(149), KScreen_Width, 18);
    titleLab.font=AppointTextFontSecond;
    titleLab.textColor=APPOINTCOLORSecond;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.text=@"你终于来了";
    [self.view addSubview:titleLab];
    
    UILabel *plzSelectGender=[[UILabel alloc] init];
    plzSelectGender.frame=CGRectMake(0, KSafeTopHeight+CHeight(169)+18, KScreen_Width, 16);
    plzSelectGender.textColor=APPOINTCOLORFifth;
    plzSelectGender.font=AppointTextFontThird;
    plzSelectGender.textAlignment=NSTextAlignmentCenter;
    plzSelectGender.text=@"现在请选择你的性别吧";
    [self.view addSubview:plzSelectGender];
    
    CGFloat butwidth=121;
    CGFloat butheight=121+16+20;
    CGFloat space=(KScreen_Width-butwidth*2)/3;
    
    UIButton *femailBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [femailBut setAdjustsImageWhenHighlighted:NO];
    femailBut.frame=CGRectMake(space, KSafeTopHeight+CHeight(230)+34, butwidth, butheight);
    [femailBut setImage:KImage(@"KCLogin-女孩") forState:UIControlStateNormal];
    [femailBut setTitle:@"女孩" forState:UIControlStateNormal];
    [femailBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [femailBut.titleLabel setFont:AppointTextFontSecond];
    [femailBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageTop imageTitleSpace:10];
    [femailBut addTarget:self action:@selector(femailButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:femailBut];
    
    UIButton *mailBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [mailBut setAdjustsImageWhenHighlighted:NO];
    mailBut.frame=CGRectMake(space*2+butwidth, KSafeTopHeight+CHeight(230)+34, butwidth, butheight);
    [mailBut setImage:KImage(@"KCLogin-男孩") forState:UIControlStateNormal];
    [mailBut setTitle:@"男孩" forState:UIControlStateNormal];
    [mailBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [mailBut.titleLabel setFont:AppointTextFontSecond];
    [mailBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageTop imageTitleSpace:10];
    [mailBut addTarget:self action:@selector(mailButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mailBut];
    
    
    
}

#pragma mark - events
/*
 * 选择女孩
 */
-(void)femailButClick:(UIButton *)sender
{
  
    sender.transform=CGAffineTransformIdentity;
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            
            sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            
            sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
        XLLog(@"选择了女孩");
        [KUserDefaults setObject:@"2" forKey:@"tempsex"];
        KCSetVoicePasswordVC *VC=[[KCSetVoicePasswordVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
/*
 * 选择男孩
 */
-(void)mailButClick:(UIButton *)sender
{
    XLLog(@"选择了男孩");
//    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//同上
//    anima.fromValue=[NSNumber numberWithFloat:0.8f];
//    anima.toValue = [NSNumber numberWithFloat:1.2f];
//    anima.duration = 0.5f;
//    [sender.layer addAnimation:anima forKey:@"scaleAnimation"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        XLLog(@"选择了女孩");
//        KCSetVoicePasswordVC *VC=[[KCSetVoicePasswordVC alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//    });
    sender.transform=CGAffineTransformIdentity;
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        
    } completion:^(BOOL finished) {
        XLLog(@"选择了女孩");
        [KUserDefaults setObject:@"1" forKey:@"tempsex"];
        KCSetVoicePasswordVC *VC=[[KCSetVoicePasswordVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
@end
