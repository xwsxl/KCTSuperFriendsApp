//
//  KCFillInfoView.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCFillInfoView.h"
@interface KCFillInfoView ()

@property (nonatomic, strong) UIView *line;

@end

@implementation KCFillInfoView

/* ****  创建view  **** */
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

/* ****  设置子view  **** */
-(void)setSubviews
{
    
    self.titleLab=[[UILabel alloc] init];
    [self.titleLab setFont:AppointTextFontSecond];
    [self.titleLab setTextColor:APPOINTCOLORFifth];
    [self.titleLab setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.titleLab];
    
    self.textField=[[UITextField alloc] init];
    [self.textField setFont:AppointTextFontSecond];
    [self.textField setTextColor:APPOINTCOLORFifth];
    self.textField.keyboardType=UIKeyboardTypeASCIICapable;
    self.textField.textAlignment=NSTextAlignmentRight;
    [self addSubview:self.textField];
    
    self.line=[UIView new];
    _line.backgroundColor=MAINSEPRATELINECOLOR;
    [self addSubview:self.line];
    
}

/* ****  加载父视图的方法  **** */
-(void)layoutSubviews
{
    
    [super layoutSubviews];
    self.titleLab.frame=CGRectMake(CWidth(15), 15, 100, 15);
    self.textField.frame=CGRectMake(CWidth(30)+100, 12.5, KScreen_Width-CWidth(45)-100, 20);
    self.line.frame=CGRectMake(CWidth(15), 44, KScreen_Width-CWidth(30), 1);
    
}

@end
