//
//  KCContactsDetailInfoCell.m
//  FMDB
//
//  Created by Hawky on 2018/11/14.
//

#import "KCTContactsDetailInfoCell.h"
@interface KCTContactsDetailInfoCell()

/* ****  <#description#>  **** */
@property (nonatomic, strong) UIImageView *headIcon;
/* ****  <#description#>  **** */
@property (nonatomic, strong) UILabel *nickNameLab;
/* ****  <#description#>  **** */
@property (nonatomic, strong) UILabel *accountNameLab;
/* ****  <#description#>  **** */
@property (nonatomic, strong) UIImageView *genderHeader;

@end

@implementation KCTContactsDetailInfoCell

/*
 * <#description#>
 */
-(void)setUpSubviews
{
    [super setUpSubviews];
    self.headIcon=[[UIImageView alloc] init];
    [self.contentView addSubview:_headIcon];
    
    self.nickNameLab=[[UILabel alloc] init];
    [self.nickNameLab setFont:AppointTextFontMain];
    [self.nickNameLab setTextColor:APPOINTCOLORSecond];
    [self.contentView addSubview:self.nickNameLab];
    
    self.accountNameLab=[[UILabel alloc] init];
    [self.accountNameLab setFont:AppointTextFontThird];
    [self.accountNameLab setTextColor:APPOINTCOLORFifth];
    [self.contentView addSubview:self.accountNameLab];
    
}
/*
 * <#description#>
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.headIcon setFrame:CGRectMake(CWidth(15), 20, 65, 65)];
    [self.nickNameLab setFrame:CGRectMake(CWidth(25)+65, 23, 200, 20)];
    [self.accountNameLab setFrame:CGRectMake(CWidth(25)+65, 50, 200, 14)];
}
/*
 * <#description#>
 */
-(void)setDataModel:(id)dataModel
{
    
    [super setDataModel:dataModel];
    ContactRLMModel *model=dataModel;
    [self.headIcon sd_setImageWithURL:KNSPHOTOURL(model.portraitUri) placeholderImage:KImage(@"超级好友")];
    [self.nickNameLab setText:model.nickName];
    [self.accountNameLab setText:[NSString stringWithFormat:@"账号:%@",model.account]];
    
}

@end
