//
//  RoomRLMModel.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/19.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "RLMObject.h"
#import "MessageRLMModel.h"
#import "GroupRLMModel.h"
NS_ASSUME_NONNULL_BEGIN
@class GroupRLMModel,ContactRLMModel,MessageRLMModel;
@interface RoomRLMModel : RLMObject
/* ****  聊天房间号  md5(my account and @"_" and you account) **** */
@property (nonatomic, copy) NSString *roomNo;

/* ****  未读消息数目  **** */
@property (nonatomic, assign) int unreadNum;
/* ****  0个人 1、群  **** */
@property (nonatomic, assign) int type;

/* ****  最后消息时间  **** */
@property (nonatomic, assign) long timestamp;

@property (nonatomic, strong) GroupRLMModel *group;

@property (nonatomic, strong) ContactRLMModel *contact;

@property (nonatomic, strong) MessageRLMModel *chat;

@end

NS_ASSUME_NONNULL_END
