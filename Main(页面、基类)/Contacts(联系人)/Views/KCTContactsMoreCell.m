//
//  KCTContactsMoreCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactsMoreCell.h"
#import "ContactRLMModel.h"


@interface KCTContactsMoreCell()

@property (nonatomic, strong) UIImageView *headIV;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *moreIV;

@property (nonatomic, strong) UILabel *statusLab;

@end

@implementation KCTContactsMoreCell

-(void)setUpSubviews
{
    [super setUpSubviews];
    self.headIV=[[UIImageView alloc] init];
    [self.contentView addSubview:self.headIV];
    
    self.titleLab=[[UILabel alloc] init];
    self.titleLab.font=AppointTextFontSecond;
    self.titleLab.textColor=APPOINTCOLORSecond;
    [self.contentView addSubview:self.titleLab];
    
    self.moreIV=[[UIImageView alloc] init];
    [self.contentView addSubview:self.moreIV];
    
    self.statusLab=[[UILabel alloc] init];
    self.statusLab.font=AppointTextFontThird;
    self.statusLab.textColor=[UIColor whiteColor];
    self.statusLab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.statusLab];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.headIV setFrame:CGRectMake(CWidth(12), 12, 32, 32)];
    
    [self.titleLab setFrame:CGRectMake(CWidth(12)+32+16, 18, 120, 20)];
    
    [self.moreIV setFrame:CGRectMake(KScreen_Width-CWidth(14)-9, 20, 9, 16)];
    
    if (_isShowNew) {
    NSString *str=self.statusLab.text;
    CGSize size=[str sizeWithFont:AppointTextFontThird maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.statusLab.layer setFrame:CGRectMake(KScreen_Width-CWidth(14)-9-5-size.width-20, 18, size.width+20, 20)];
    [self.statusLab.layer setCornerRadius:10];
    [self.statusLab.layer setBackgroundColor:RGBHex(0xff6464).CGColor];
    }else
    {
        self.statusLab.hidden=YES;
    }
    
}

-(void)setDataModel:(id)dataModel
{
    [super setDataModel:dataModel];
    ContactRLMModel *model=dataModel;
    [_headIV setImage:KImage(model.portraitUri)];
    [_titleLab setText:model.account];
    [_moreIV setImage:KImage(@"KCContact-More")];
    [self.statusLab setText:@"新"];
}

@end
