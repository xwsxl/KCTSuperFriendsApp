//
//  KCMyAttensionTableCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/23.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMyAttensionTableCell.h"
#import "KCProfileInfoModel.h"

@interface KCMyAttensionTableCell()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *nickNameLab;

@property (nonatomic, strong) UILabel *accountNameLab;

@property (nonatomic, strong) UIButton *attensionBut;

@end

@implementation KCMyAttensionTableCell

-(void)setUpSubviews
{
    [super setUpSubviews];
    self.icon=[[UIImageView alloc] init];
    [self.contentView addSubview:self.icon];
    
    self.nickNameLab=[[UILabel alloc] init];
    [self.nickNameLab setFont:AppointTextFontSecond];
    [self.nickNameLab setTextColor:APPOINTCOLORSecond];
    [self.contentView addSubview:self.nickNameLab];
    
    self.accountNameLab=[[UILabel alloc] init];
    [self.accountNameLab setFont:AppointTextFontThird];
    [self.accountNameLab setTextColor:APPOINTCOLORFifth];
    [self.contentView addSubview:self.accountNameLab];
    
    self.attensionBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.attensionBut setTitleColor:APPOINTCOLORThird forState:UIControlStateNormal];
    [self.attensionBut.titleLabel setFont:AppointTextFontSecond];
    [self.attensionBut addTarget:self action:@selector(attensionButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.attensionBut];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon setFrame:CGRectMake(15, 11, 47, 47)];
    [self.nickNameLab setFrame:CGRectMake(74, 13, 130, 16)];
    [self.accountNameLab setFrame:CGRectMake(74, 38, 130, 14)];
    [self.attensionBut.layer setFrame:CGRectMake(KScreen_Width-65-13, 15, 65, 34)];
    [self.attensionBut.layer setCornerRadius:3];
    [self.attensionBut.layer setBackgroundColor:MAINSEPRATELINECOLOR.CGColor];
}

-(void)setDataModel:(id)dataModel
{
    [super setDataModel:dataModel];
    KCProfileInfoModel *model=(KCProfileInfoModel *)dataModel;
    [self.icon sd_setImageWithURL:KNSPHOTOURL(model.headerIconStr) placeholderImage:KImage(@"")];
    [self.nickNameLab setText:model.nickName];
    [self.accountNameLab setText:model.accountName];
    [self.attensionBut setTitle:@"+ 关注" forState:UIControlStateNormal];
    
}

/*
 * 关注按钮
 */
-(void)attensionButClick:(UIButton *)sender
{
    XLLog(@"add attension");
}
@end
