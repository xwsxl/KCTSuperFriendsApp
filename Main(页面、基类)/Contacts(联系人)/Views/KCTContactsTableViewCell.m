//
//  KCContactsTableViewCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactsTableViewCell.h"
#import "ContactRLMModel.h"
@interface KCTContactsTableViewCell()
/* ****  头像  **** */
@property (nonatomic, strong) UIImageView *icon;
/* ****  名字  **** */
@property (nonatomic, strong) UILabel *nameLab;

@end

@implementation KCTContactsTableViewCell

-(void)setUpSubviews
{
    [super setUpSubviews];
    self.icon=[[UIImageView alloc] init];
    [self.contentView addSubview:self.icon];
    
    self.nameLab =[[UILabel alloc] init];
    [self.nameLab setTextColor:APPOINTCOLORSecond];
    [self.nameLab setFont:AppointTextFontSecond];
    [self.contentView addSubview:self.nameLab];
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    [self.icon setFrame:CGRectMake(15, 9, 39, 39)];
    [self.nameLab setFrame:CGRectMake(39+15+10, 9, KScreen_Width-64, 39)];
    
}

-(void)setDataModel:(id)dataModel
{
    
    [super setDataModel:dataModel];
    ContactRLMModel *model=(ContactRLMModel *)dataModel;
    [self.icon sd_setImageWithURL:KNSPHOTOURL(model.portraitUri) placeholderImage:KImage(@"超级好友")];
    [self.nameLab setText:model.aliasName];
    
}
- (void)setCellAttributeString:(NSMutableAttributedString *)attributeString
{
    if (attributeString == nil) {
        return;
    }
    _nameLab.attributedText = attributeString;
}
@end
