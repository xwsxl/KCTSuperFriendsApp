//
//  KCTAlertView.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/6.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTAlertView.h"
#import "UIImageView+WebCache.h"
@interface KCTAlertView()

//弹窗
@property (nonatomic,retain) UIView *alertView;

@end

@implementation KCTAlertView


#pragma mark - 联系人信息

-(instancetype)initCantactsAlertViewWithModel:(ContactRLMModel *)model
{
    if (self=[super init]) {
        // 底面蒙版
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        
        // 白色弹框
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor clearColor];
        self.alertView.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.alertView.bounds = CGRectMake(0, 0, KScreen_Width-CWidth(60), 210);
        self.alertView.center = self.center;
        [self addSubview:self.alertView];

        UIView *whitView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width-CWidth(60), 100)];
        whitView.layer.cornerRadius=10;
        whitView.layer.backgroundColor=[UIColor whiteColor].CGColor;
        [self.alertView addSubview:whitView];
        
        UIImageView *HeadIV=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 70, 70)];
        [HeadIV sd_setImageWithURL:KNSPHOTOURL(model.portraitUri) placeholderImage:KImage(@"")];
        [whitView addSubview:HeadIV];
        
        // 标题
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.font = [UIFont systemFontOfSize:16];
        nameLab.textColor = [UIColor blackColor];
        [whitView addSubview:nameLab];
        nameLab.frame = CGRectMake(90, 20, 100, 30);
        nameLab.text = model.aliasName.length>0?model.aliasName:@"请设置备注";
        
        // 标题
        UILabel *nickNameLab = [[UILabel alloc] init];
        nickNameLab.font = [UIFont systemFontOfSize:12];
        nickNameLab.textColor = [UIColor blackColor];
        [whitView addSubview:nickNameLab];
        nickNameLab.frame = CGRectMake(90, 20+30+15, 100, 12);
        nickNameLab.text =[NSString stringWithFormat:@"昵称:%@",model.nickName];
        
        
        UIView *whitView2=[[UIView alloc] initWithFrame:CGRectMake(0, 110, KScreen_Width-CWidth(60), 100)];
        whitView2.layer.cornerRadius=10;
        whitView2.layer.backgroundColor=[UIColor whiteColor].CGColor;
        [self.alertView addSubview:whitView2];
        CGFloat Bwidth=(KScreen_Width-CWidth(60))/3.0;
        CGFloat Bheight=100;
        UIButton *messageBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [messageBut setImage:KImage(@"KCContact-message") forState:UIControlStateNormal];
        [messageBut setTitle:@"消息" forState:UIControlStateNormal];
        [messageBut setTitleColor:RGBHex(0x7a7676) forState:UIControlStateNormal];
        messageBut.titleLabel.font=AppointTextFontFourth;
        messageBut.frame=CGRectMake(0, 0, Bwidth, Bheight);
        [messageBut addTarget:self action:@selector(messageButClick:) forControlEvents:UIControlEventTouchUpInside];
        [messageBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageTop imageTitleSpace:10];
        [whitView2 addSubview:messageBut];
        
        UIButton *ReadOnBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [ReadOnBut setImage:KImage(@"KCContact-readAndPlay") forState:UIControlStateNormal];
        [ReadOnBut setTitle:@"读播" forState:UIControlStateNormal];
        [ReadOnBut setTitleColor:RGBHex(0x7a7676) forState:UIControlStateNormal];
        ReadOnBut.titleLabel.font=AppointTextFontFourth;
        ReadOnBut.frame=CGRectMake(Bwidth, 0, Bwidth, Bheight);
        [ReadOnBut addTarget:self action:@selector(readOnButClick:) forControlEvents:UIControlEventTouchUpInside];
        [ReadOnBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageTop imageTitleSpace:10];
        [whitView2 addSubview:ReadOnBut];
        
        UIButton *videoBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [videoBut setImage:KImage(@"KCContact-video") forState:UIControlStateNormal];
        [videoBut setTitle:@"视频" forState:UIControlStateNormal];
        [videoBut setTitleColor:RGBHex(0x7a7676) forState:UIControlStateNormal];
        videoBut.titleLabel.font=AppointTextFontFourth;
        videoBut.frame=CGRectMake(Bwidth*2, 0, Bwidth, Bheight);
        [videoBut addTarget:self action:@selector(videoButClick:) forControlEvents:UIControlEventTouchUpInside];
        [videoBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageTop imageTitleSpace:10];
        [whitView2 addSubview:videoBut];
        // 点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressInAlertViewGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
/* ****  备注  **** */
-(void)aliasButClick:(UIButton *)sender
{
    if (self.aliasBlock) {
        self.aliasBlock();
    }
    [self removeFromSuperview];
}
/* ****  消息  **** */
-(void)messageButClick:(UIButton *)sender
{
    if (self.messageBlock) {
        self.messageBlock();
    }
    [self removeFromSuperview];
}
/* ****  读播  **** */
-(void)readOnButClick:(UIButton *)sender
{
    if (self.readOnBlock) {
        self.readOnBlock();
    }
    [self removeFromSuperview];
}
/* ****  视频  **** */
-(void)videoButClick:(UIButton *)sender
{
    if (self.videoBlock) {
        self.videoBlock();
    }
    [self removeFromSuperview];
}




// 点击其他区域关闭弹窗
- (void)handletapPressInAlertViewGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![_alertView pointInside:[_alertView convertPoint:location fromView:_alertView.window] withEvent:nil]){
            [_alertView.window removeGestureRecognizer:sender];
            [self removeFromSuperview];
        }
    }
}


#pragma mark - 弹出 -
- (void)showRSAlertView
{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    
    [rootWindow addSubview:self];
    
    [self creatShowAnimation];
}

#pragma mark - 弹出的动画
- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

@end
