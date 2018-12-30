//
//  KCCAddContactsFriendsCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/26.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTAddContactsFriendsCell.h"



@interface KCTAddContactsFriendsCell ()

/* ****  头像  **** */
@property (nonatomic,strong)UIImageView *headIcon;
/* ****  名字  **** */
@property (nonatomic, strong) UILabel *nameLabel;
/* ****  手机号  **** */
@property (nonatomic, strong) UILabel *phoneNumLab;
/* ****  关注按钮  **** */
@property (nonatomic, strong) UIButton *attensionBut;

@property (nonatomic, strong) KCProfileInfoModel *Model;
@end

@implementation KCTAddContactsFriendsCell

-(void)setUpSubviews
{
    
    [super setUpSubviews];
    self.headIcon=[[UIImageView alloc] init];
    [self.contentView addSubview:self.headIcon];
    
    self.nameLabel =[[UILabel alloc] init];
    [self.nameLabel setFont:AppointTextFontSecond];
    [self.nameLabel setTextColor:APPOINTCOLORSecond];
    [self.contentView addSubview:self.nameLabel];
    
    self.phoneNumLab = [[UILabel alloc] init];
    [self.phoneNumLab setFont:AppointTextFontThird];
    [self.phoneNumLab setTextColor:APPOINTCOLORFifth];
    [self.contentView addSubview:self.phoneNumLab];
    
    self.attensionBut =[UIButton buttonWithType:UIButtonTypeCustom];
    self.attensionBut.clipsToBounds=YES;
    [self.attensionBut.layer setCornerRadius:5];
    self.attensionBut.layer.backgroundColor=MAINSEPRATELINECOLOR.CGColor;
    [self.attensionBut.titleLabel setFont:AppointTextFontSecond];
    [self.attensionBut setTitleColor:APPOINTCOLORThird forState:UIControlStateNormal];
    [self.contentView addSubview:self.attensionBut];
    
    
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    [self.headIcon setFrame:CGRectMake(15, 9, 48, 48)];
    [self.nameLabel setFrame:CGRectMake(73, 13, 200, 16)];
    [self.phoneNumLab setFrame:CGRectMake(73, 38, 200, 14)];
    [self.attensionBut.layer setFrame:CGRectMake(KScreen_Width-65-10, 16, 65, 33)];
    
}

-(void)setDataModel:(id)dataModel
{
    
    [super setDataModel:dataModel];
    ContactRLMModel *model=dataModel;
    self.Model=dataModel;
   // [self.phoneNumLab setText:model.content];
    [self.headIcon sd_setImageWithURL:KNSPHOTOURL(model.portraitUri) placeholderImage:KImage(@"超级好友")];
   
    if ([_cellType isEqualToString:@"2"]) {
        [self.nameLabel setText:model.nickName];
       // [self.phoneNumLab setText:model.content];
        [self.attensionBut setTitle:@"查看" forState:UIControlStateNormal];
        self.attensionBut.userInteractionEnabled=NO;
    }else
    {
        /* ****  最后在写默认的  **** */
        [self.nameLabel setText:model.nickName];
        [self.phoneNumLab setText:model.phoneNum];
        
        if ([_cellType isEqualToString:@"0"]) {
            [self.attensionBut setTitle:@"添加" forState:UIControlStateNormal];
        }else
        {
            [self.attensionBut setTitle:@"邀请" forState:UIControlStateNormal];
        }
        [self.attensionBut addTarget:self action:@selector(attensionButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


-(void)attensionButClick:(UIButton *)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(attensionButClick:)]) {
        [_delegate attensionButClick:self.Model];
    }
}

-(NSString *)cellType
{
    if (!_cellType) {
        _cellType=@"1";
    }
    return _cellType;
}

@end






