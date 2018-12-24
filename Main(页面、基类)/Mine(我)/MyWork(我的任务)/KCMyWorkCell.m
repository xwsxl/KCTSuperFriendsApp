//
//  KCMyWorkCell.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/24.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMyWorkCell.h"
#import "KCMyWorkModel.h"
@interface KCMyWorkCell ()
/* ****  任务名  **** */
@property (nonatomic, strong) UILabel *workNameLab;
/* ****  任务时间  **** */
@property (nonatomic, strong) UILabel *workTimeLab;
/* ****  任务发布人  **** */
@property (nonatomic, strong) UILabel *publisherLab;

@end
@implementation KCMyWorkCell
/*
 * 调用父类方法添加子视图
 */
- (void)setUpSubviews
{
    [super setUpSubviews];
    self.workNameLab=[[UILabel alloc] init];
    self.workNameLab.font=AppointTextFontSecond;
    self.workNameLab.textColor=APPOINTCOLORSecond;
    [self.contentView addSubview:self.workNameLab];
    
    self.workTimeLab=[[UILabel alloc] init];
    self.workTimeLab.font=AppointTextFontThird;
    self.workTimeLab.textColor=APPOINTCOLORFifth;
    [self.contentView addSubview:self.workTimeLab];
    
    self.publisherLab=[[UILabel alloc] init];
    self.publisherLab.font=AppointTextFontThird;
    self.publisherLab.textColor=APPOINTCOLORFifth;
    self.publisherLab.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.publisherLab];
    
}
/*
 * 调用父类方法布局子视图
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.workNameLab setFrame:CGRectMake(20, 15, KScreen_Width-40, 16)];
    [self.workTimeLab setFrame:CGRectMake(20, 43, KScreen_Width-40-60, 14)];
    [self.publisherLab setFrame:CGRectMake(KScreen_Width-20-60, 43, 60, 14)];
    
}
/*
 * 调用父类方法设置数据
 */
-(void)setDataModel:(id)dataModel
{
    [super setDataModel:dataModel];
    KCMyWorkModel *model=(KCMyWorkModel *)dataModel;
    [self.workNameLab setText:model.name];
    [self.workTimeLab setText:model.time];
    [self.publisherLab setText:model.publisher];
}

@end
