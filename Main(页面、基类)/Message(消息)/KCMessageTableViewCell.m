//
//  KCMessageTableViewCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "KCTRealmManager.h"
@interface KCMessageTableViewCell ()
/* ****  头像  **** */
@property (nonatomic, strong) UIImageView *icon;
/* ****  标题  **** */
@property (nonatomic, strong) UILabel *titleLab;
/* ****  最后一条消息  **** */
@property (nonatomic, strong) UILabel *lastMessageLab;
/* ****  时间  **** */
@property (nonatomic, strong) UILabel *timeLab;
/* ****  未读消息数目  **** */
@property (nonatomic, strong) UILabel *unreadNumLab;
@end

@implementation KCMessageTableViewCell

-(void)setUpSubviews
{
    [super setUpSubviews];
    self.icon=[[UIImageView alloc] init];
    [self.contentView addSubview:self.icon];
    
    self.titleLab=[[UILabel alloc] init];
    [self.titleLab setTextColor:APPOINTCOLORSecond];
    [self.titleLab setFont:AppointTextFontSecond];
    [self.contentView addSubview:self.titleLab];
    
    self.lastMessageLab=[[UILabel alloc] init];
    [self.lastMessageLab setTextColor:APPOINTCOLORFirst];
    [self.lastMessageLab setFont:AppointTextFontThird];
    [self.contentView addSubview:self.lastMessageLab];
    
    
    self.timeLab=[[UILabel alloc] init];
    [self.timeLab setTextColor:APPOINTCOLORFirst];
    [self.timeLab setFont:AppointTextFontFourth];
    [self.timeLab setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.timeLab];
    self.unreadNumLab=[[UILabel alloc] init];
    [self.unreadNumLab setTextColor:[UIColor whiteColor]];
    [self.unreadNumLab setFont:AppointTextFontFourth];
    [self.unreadNumLab setTextAlignment:NSTextAlignmentCenter];
    [self.unreadNumLab setBackgroundColor:RGBHex(0xff6464)];
    [self.contentView addSubview:self.unreadNumLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.icon setFrame:CGRectMake(15, 12, 47, 47)];
    [self.titleLab setFrame:CGRectMake(15+47+12, 13, KScreen_Width-15-47-12-80-14, 16)];
    [self.lastMessageLab setFrame:CGRectMake(15+47+12, 13+16+9, KScreen_Width-15-47-12-80-14, 16)];
    [self.timeLab setFrame:CGRectMake(KScreen_Width-15-80, 15, 80, 13)];
    [self.unreadNumLab.layer setFrame:CGRectMake(KScreen_Width-13-20, 33, 20, 20)];
    self.unreadNumLab.clipsToBounds=YES;
    [self.unreadNumLab.layer setCornerRadius:10];
    
}

-(void)setDataModel:(id)dataModel
{
    
    [super setDataModel:dataModel];
    RoomRLMModel *model=(RoomRLMModel*)dataModel;
   
    
    if (model.type==0) {
        ContactRLMModel *cmodel=model.contact;
        NSString *name=cmodel.aliasName;
        [self.titleLab setText:name];
        [self.icon sd_setImageWithURL:KNSPHOTOURL(model.contact.portraitUri) placeholderImage:KImage(@"超级好友")];
    }else if(model.type==1)
    {
        [self.titleLab setText:model.group.groupName];
        [self.icon sd_setImageWithURL:KNSPHOTOURL(model.group.groupPhoto) placeholderImage:KImage(@"超级好友")];
    }
    
    [self.timeLab setText:[NSString achieveDayFormatByTimeString:[NSString stringWithFormat:@"%ld",model.timestamp] withOutTimeDetail:NO]];
    
    if (model.unreadNum>0) {
        self.unreadNumLab.hidden=NO;
    }else
    {
        self.unreadNumLab.hidden=YES;
    }
    [self.unreadNumLab setText:[NSString stringWithFormat:@"%d",model.unreadNum]];
    if (model.chat.msgType==1001) {
        [self.lastMessageLab setText:model.chat.msg];
    }else if (model.chat.msgType==1002)
    {
        [self.lastMessageLab setText:@"[图片]"];
    }else if (model.chat.msgType==1003)
    {
        [self.lastMessageLab setText:@"[语音]"];
    }else if (model.chat.msgType==1004)
    {
        [self.lastMessageLab setText:@"[小视频]"];
    }
}
- (void)setCellAttributeString:(NSMutableAttributedString *)attributeString
{
    if (attributeString == nil) {
        return;
    }
    _lastMessageLab.attributedText = attributeString;
}
@end
