//
//  KCTContacsSelectFriendsCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/16.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContacsSelectFriendsCell.h"
@interface KCTContacsSelectFriendsCell()

/* ****  选中图片  **** */
@property (nonatomic, strong) UIImageView *selectIV;
/* ****  头像  **** */
@property (nonatomic, strong) UIImageView *headerIV;
/* ****  昵称  **** */
@property (nonatomic, strong) UILabel *nickNameLab;

@end

@implementation KCTContacsSelectFriendsCell

-(void)setUpSubviews
{
    [super setUpSubviews];
    self.selectIV=[[UIImageView alloc] init];
    [self.contentView addSubview:self.selectIV];
    
    self.headerIV=[[UIImageView alloc] init];
    [self.contentView addSubview:self.headerIV];
    
    self.nickNameLab=[[UILabel alloc] init];
    [self.nickNameLab setFont:AppointTextFontSecond];
    [self.nickNameLab setTextColor:APPOINTCOLORSecond];
    [self.contentView addSubview:self.nickNameLab];
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.selectIV setFrame:CGRectMake(CWidth(7), 15, 25, 25)];
    [self.headerIV setFrame:CGRectMake(CWidth(15)+25, 8, 40, 40)];
    [self.nickNameLab setFrame:CGRectMake(CWidth(20)+25+40, 0, 200, 56)];
}

-(void)setDataModel:(id)dataModel
{
    [super setDataModel:dataModel];
    ContactRLMModel *Model=dataModel;
    if (self.selected) {
        [self.selectIV setImage:KImage(@"KCContact-select")];
    }else
    {
        [self.selectIV setImage:KImage(@"KCContact-unselect")];
    }
    
    [self.headerIV sd_setImageWithURL:KNSPHOTOURL(Model.portraitUri) placeholderImage:KImage(@"")];
    [self.nickNameLab setText:Model.nickName];
}

@end
