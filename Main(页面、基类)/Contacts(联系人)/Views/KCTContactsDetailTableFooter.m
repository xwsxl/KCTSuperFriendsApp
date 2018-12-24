//
//  KCContactsDetailTableFooter.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactsDetailTableFooter.h"
@interface KCTContactsDetailTableFooter()

@property (nonatomic, strong) UIButton *addFriendsBut;

@property (nonatomic, strong) UIButton *addBlackBoardBut;

@end
@implementation KCTContactsDetailTableFooter

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews
{
    self.userInteractionEnabled=YES;
    self.addFriendsBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addFriendsBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addFriendsBut.layer setBackgroundColor:RGBHex(0x008FFB).CGColor];
    [self.contentView addSubview:self.addFriendsBut];
    [self.addFriendsBut addTarget:self action:@selector(addFriendsButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addBlackBoardBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBlackBoardBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [self.addBlackBoardBut.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [self.addBlackBoardBut.layer setCornerRadius:15];
    [self.contentView addSubview:self.addBlackBoardBut];
    [self.addBlackBoardBut addTarget:self action:@selector(addBlackBoardButClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.addBlackBoardBut.layer setFrame:CGRectMake(CWidth(15), 30+50+15, KScreen_Width-CWidth(30), 50)];
    [self.addFriendsBut.layer setCornerRadius:15];
    [self.addFriendsBut.layer setFrame:CGRectMake(CWidth(15), 30, KScreen_Width-CWidth(30), 50)];
    CAGradientLayer *galayer=[CAGradientLayer layer];
    galayer.frame=self.addFriendsBut.bounds;
    galayer.startPoint=CGPointMake(0, 0);
    galayer.endPoint=CGPointMake(1, 1);
    galayer.locations=@[@(0),@(1)];
    [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
    galayer.cornerRadius=15;
    [self.addFriendsBut.layer addSublayer:galayer];
}

-(void)setType:(KCContactsDetailType)type
{
    _type=type;
    self.addBlackBoardBut.hidden=NO;
    if (_type==0) {
        /* ****  默认  **** */
        [self.addFriendsBut setTitle:@"发送消息" forState:UIControlStateNormal];
        [self.addBlackBoardBut setTitle:@"视频通话" forState:UIControlStateNormal];
    }else if(_type==1)
    {
        /* ****  添加好友  **** */
        [self.addFriendsBut setTitle:@"添加好友" forState:UIControlStateNormal];
         self.addBlackBoardBut.hidden=YES;
    }else
    {
        /* ****  收到好友申请  **** */
        [self.addFriendsBut setTitle:@"同意添加" forState:UIControlStateNormal];
        [self.addBlackBoardBut setTitle:@"加入黑名单" forState:UIControlStateNormal];
    }
        
    
}

-(void)addFriendsButClick:(UIButton *)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(addFriendsButClick:)]) {
        [_delegate addFriendsButClick:sender];
    }
}

-(void)addBlackBoardButClick:(UIButton *)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(addBlackBoardButClick:)]) {
        [_delegate addBlackBoardButClick:sender];
    }
}

@end
