//
//  KCMySettingCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/24.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMySettingCell.h"
@interface KCMySettingCell()


@property (nonatomic, strong) UIImageView *moreIV;

@end

@implementation KCMySettingCell

-(void)setUpSubviews
{
    [super setUpSubviews];
    self.titleLab=[[UILabel alloc] init];
    [self.titleLab setFont:AppointTextFontSecond];
    [self.titleLab setTextColor:APPOINTCOLORSecond];
    [self.contentView addSubview:self.titleLab];

    self.moreIV=[[UIImageView alloc] init];
    [self.moreIV setImage:KImage(@"KCContact-More")];
    [self.contentView addSubview:self.moreIV];
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLab setFrame:CGRectMake(15, 0, KScreen_Width-50, 52)];
    [self.moreIV setFrame:CGRectMake(KScreen_Width-18-9, 18, 9, 16)];
}

-(void)setDataModel:(id)dataModel
{
    [super setDataModel:dataModel];
}
@end
