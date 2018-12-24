//
//  KCMessageAddSelectionView.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMessageAddSelectionView.h"
#import "SWQRCodeViewController.h"
@interface KCMessageAddSelectionView ()
@property (nonatomic, strong) UIButton *creatGroupChatBut;
@property (nonatomic, strong) UIButton *addFriendsBut;
@property (nonatomic, strong) UIButton *scanQRCodeBut;
@end
@implementation KCMessageAddSelectionView


- (void)layoutSubviews
{
    CGRect rect=CGRectMake(KScreen_Width-15-154, 76+KSafeTopHeight, 154, 237);
    CGFloat width=rect.size.width;
    CGFloat height=rect.size.height;
    if (height>20) {
        height=(height-20)/3.0;
    }else
    {
        height=0;
    }
    self.creatGroupChatBut.frame=CGRectMake(0, 10, width, height);
    self.addFriendsBut.frame=CGRectMake(0, 10+height, width, height);
    self.scanQRCodeBut.frame=CGRectMake(0, 10+2*height, width, height);
}

-(void)setSubviews
{
    [super setSubviews];
    self.layer.backgroundColor=[UIColor whiteColor].CGColor;
    self.layer.cornerRadius=10;
    self.userInteractionEnabled=YES;
    [self setClipsToBounds:YES];
    UIButton *creatGroupChatBut=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [creatGroupChatBut setImage:KImage(@"KCMessage-群聊") forState:UIControlStateNormal];
    [creatGroupChatBut setTitle:@"创建群聊" forState:UIControlStateNormal];
    [creatGroupChatBut setTitleColor:APPOINTCOLORFifth forState:UIControlStateNormal];
    [creatGroupChatBut.titleLabel setFont:AppointTextFontThird];
    [creatGroupChatBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageLeft imageTitleSpace:10];
    [creatGroupChatBut addTarget:self action:@selector(creatGroupChatButClick:) forControlEvents:UIControlEventTouchUpInside];
    self.creatGroupChatBut=creatGroupChatBut;
    [self addSubview:self.creatGroupChatBut];
    
    UIButton *addFriendsBut=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [addFriendsBut setImage:KImage(@"KCMessage-联系人") forState:UIControlStateNormal];
    [addFriendsBut setTitle:@"添加好友" forState:UIControlStateNormal];
    [addFriendsBut setTitleColor:APPOINTCOLORFifth forState:UIControlStateNormal];
    [addFriendsBut.titleLabel setFont:AppointTextFontThird];
    [addFriendsBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageLeft imageTitleSpace:10];
    [addFriendsBut addTarget:self action:@selector(addFriendsButClick:) forControlEvents:UIControlEventTouchUpInside];
    self.addFriendsBut=addFriendsBut;
    [self addSubview:self.addFriendsBut];
    
    UIButton *scanQRCodeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [scanQRCodeBut setImage:KImage(@"KCMessage-扫一扫") forState:UIControlStateNormal];
    [scanQRCodeBut setTitle:@"扫一扫" forState:UIControlStateNormal];
    [scanQRCodeBut setTitleColor:APPOINTCOLORFifth forState:UIControlStateNormal];
    [scanQRCodeBut.titleLabel setFont:AppointTextFontThird];
    [scanQRCodeBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageLeft imageTitleSpace:10];
    [scanQRCodeBut addTarget:self action:@selector(scanQRCodeButClick:) forControlEvents:UIControlEventTouchUpInside];
    self.scanQRCodeBut=scanQRCodeBut;
    [self addSubview:self.scanQRCodeBut];
    
}

/*
 * 创建群聊
 */
-(void)creatGroupChatButClick:(UIButton *)sender
{
    XLLog(@"creat group chat...");
    if (_delegate&&[_delegate respondsToSelector:@selector(creatGroupChatButClick:)]) {
        [_delegate creatGroupChatButClick:sender];
    }
}
/*
 * 添加好友
 */
-(void)addFriendsButClick:(UIButton *)sender
{
    XLLog(@"add friends...");
    if (_delegate&&[_delegate respondsToSelector:@selector(addFriendsButClick:)]) {
        [_delegate addFriendsButClick:sender];
    }
}

/*
 * 扫一扫
 */
-(void)scanQRCodeButClick:(UIButton *)sender
{
    XLLog(@"scan QR code...");
    if (_delegate&&[_delegate respondsToSelector:@selector(scanQRCodeButClick:)]) {
        [_delegate scanQRCodeButClick:sender];
    }
}

@end
