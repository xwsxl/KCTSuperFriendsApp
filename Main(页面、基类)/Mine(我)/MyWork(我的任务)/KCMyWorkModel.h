//
//  KCMyWorkModel.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/24.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCMyWorkModel : KCBaseModel
/* ****  任务名  **** */
@property (nonatomic, copy) NSString *name;
/* ****  时间  **** */
@property (nonatomic, copy) NSString *time;
/* ****  任务发布人  **** */
@property (nonatomic, copy) NSString *publisher;

@end

NS_ASSUME_NONNULL_END
