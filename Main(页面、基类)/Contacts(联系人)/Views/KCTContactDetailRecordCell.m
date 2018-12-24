//
//  KCTContactDetailRecordCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactDetailRecordCell.h"

@interface KCTContactDetailRecordCell ()

/* ****  <#description#>  **** */
@property (nonatomic, strong) UILabel *titleLab;


@end

@implementation KCTContactDetailRecordCell

/*
 * <#description#>
 */
-(void)setUpSubviews
{
    [super setUpSubviews];
    self.titleLab=[[UILabel alloc] init];
    [self.titleLab setFont:AppointTextFontSecond];
    [self.titleLab setTextColor:APPOINTCOLORSecond];
    [self.contentView addSubview:self.titleLab];
    
}
/*
 * <#description#>
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLab setFrame:CGRectMake(CWidth(15), 38, 50, 16)];
}

/*
 * <#description#>
 */
-(void)setDataModel:(id)dataModel
{
    [super setDataModel:dataModel];
    [self.titleLab setText:@"读播圈"];
}

@end
