//
//  KCProfileSelectTableviewCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCProfileSelectTableviewCell.h"
#import "KCProfileSelectModel.h"
@interface KCProfileSelectTableviewCell ()
/* ****  图标  **** */
@property (nonatomic, strong) UIImageView *icon;
/* ****  右侧更多图标  **** */
@property (nonatomic, strong) UIImageView *more;
/* ****  标题  **** */
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation KCProfileSelectTableviewCell

-(void)setUpSubviews
{
    [super setUpSubviews];
    
    self.icon=[[UIImageView alloc] init];
    [self.contentView addSubview:self.icon];
    
    self.more=[[UIImageView alloc] init];
    [self.contentView addSubview:self.more];
    
    self.titleLab=[[UILabel alloc] init];
    [self.titleLab setFont:AppointTextFontSecond];
    [self.titleLab setTextColor:APPOINTCOLORSecond];
    [self.contentView addSubview:self.titleLab];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.icon setFrame:CGRectMake(20, 17, 32, 32)];
    [self.titleLab setFrame:CGRectMake(62, 25, KScreen_Width-62-60, 16)];
    [self.more setFrame:CGRectMake(KScreen_Width-25-9, 25, 9, 16)];
}

-(void)setDataModel:(id)dataModel
{
    [super setDataModel:dataModel];
    KCProfileSelectModel *model=(KCProfileSelectModel *)dataModel;
    [self.icon setImage:KImage(model.iconStr)];
    [self.titleLab setText:model.title];
    [self.more setImage:KImage(@"KCContact-More")];
}

@end
