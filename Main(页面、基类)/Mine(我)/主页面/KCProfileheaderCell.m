//
//  KCProfileheaderCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCProfileheaderCell.h"

#import "KCProfileInfoModel.h"

@interface KCProfileheaderCell ()

@property (nonatomic, strong) UIImageView *headerIcon;

@property (nonatomic, strong) UILabel *nickName;

@property (nonatomic, strong) UILabel *accountName;

@property (nonatomic, strong) UIImageView *more;

@property (nonatomic, strong) UILabel *diaryLab;

@property (nonatomic, strong) UILabel *attensionLab;

@property (nonatomic, strong) UILabel *fansLab;

@end

@implementation KCProfileheaderCell

-(void)setUpSubviews
{
    [super setUpSubviews];
    self.headerIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.headerIcon];
    
    self.nickName = [[UILabel alloc] init];
    [self.nickName setFont:AppointTextFontMain];
    [self.nickName setTextColor:APPOINTCOLORSecond];
    [self.contentView addSubview:self.nickName];
    
    self.accountName = [[UILabel alloc] init];
    [self.accountName setFont:AppointTextFontThird];
    [self.accountName setTextColor:APPOINTCOLORFifth];
    [self.contentView addSubview:self.accountName];
    
    self.more = [[UIImageView alloc] init];
    [self.contentView addSubview:self.more];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 83, KScreen_Width, 1)];
    [line setBackgroundColor:MAINSEPRATELINECOLOR];
    [self.contentView addSubview:line];
    
    
    self.diaryLab = [[UILabel alloc] init];
    self.diaryLab.numberOfLines=0;
    [self.diaryLab setFont:AppointTextFontThird];
    [self.diaryLab setTextColor:APPOINTCOLORSecond];
    [self.diaryLab setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.diaryLab];
    
    self.attensionLab = [[UILabel alloc] init];
    self.attensionLab.numberOfLines=0;
    [self.attensionLab setFont:AppointTextFontThird];
    [self.attensionLab setTextColor:APPOINTCOLORSecond];
    [self.attensionLab setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.attensionLab];
    
    self.fansLab = [[UILabel alloc] init];
    self.fansLab.numberOfLines=0;
    [self.fansLab setFont:AppointTextFontThird];
    [self.fansLab setTextColor:APPOINTCOLORSecond];
    [self.fansLab setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.fansLab];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.headerIcon setFrame:CGRectMake(13, 12, 55, 55)];
    [self.nickName setFrame:CGRectMake(83, 19, 130, 21)];
    [self.accountName setFrame:CGRectMake(83, 54, 130, 14)];
    
    [self.more setFrame:CGRectMake(KScreen_Width-30, 38, 9, 16)];
    
    [self.diaryLab setFrame:CGRectMake(0, 83, KScreen_Width/3.0, 57)];
    [self.attensionLab setFrame:CGRectMake(KScreen_Width/3.0, 83, KScreen_Width/3.0, 57)];
    [self.fansLab setFrame:CGRectMake(KScreen_Width/3.0*2, 83, KScreen_Width/3.0, 57)];
    
    
}

-(void)setDataModel:(id)dataModel
{
    
    [super setDataModel:dataModel];
    KCProfileInfoModel *model = (KCProfileInfoModel *)dataModel;
    [self.headerIcon sd_setImageWithURL:KNSPHOTOURL(model.headerIconStr)];
    [self.nickName setText:model.nickName];
    [self.accountName setText:model.accountName];
    [self.more setImage:KImage(@"KCContact-More")];
    
    NSString *diary=[NSString stringWithFormat:@"%@\n日记",model.diaryNum];
    NSString *attension=[NSString stringWithFormat:@"%@\n关注",model.attensionNum];
    NSString *fans=[NSString stringWithFormat:@"%@\n粉丝",model.fansNum];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 6; //设置行间距
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:diary];
    NSRange range=[diary rangeOfString:@"日记"];
    [attr addAttribute:NSForegroundColorAttributeName value:APPOINTCOLORFifth range:range];
    [attr addAttribute:NSFontAttributeName value:AppointTextFontFourth range:range];
    [attr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attr.length)];
    [self.diaryLab setAttributedText:attr];
    
    NSMutableAttributedString *attr1=[[NSMutableAttributedString alloc] initWithString:attension];
    NSRange range1=[attension rangeOfString:@"关注"];
    [attr1 addAttribute:NSForegroundColorAttributeName value:APPOINTCOLORFifth range:range1];
    [attr1 addAttribute:NSFontAttributeName value:AppointTextFontFourth range:range1];
    [attr1 addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attr1.length)];
    [self.attensionLab setAttributedText:attr1];
    
    NSMutableAttributedString *attr2=[[NSMutableAttributedString alloc] initWithString:fans];
    NSRange range2=[fans rangeOfString:@"粉丝"];
    [attr2 addAttribute:NSForegroundColorAttributeName value:APPOINTCOLORFifth range:range2];
    [attr2 addAttribute:NSFontAttributeName value:AppointTextFontFourth range:range2];
    [attr2 addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attr2.length)];
    [self.fansLab setAttributedText:attr2];
    
}
@end
