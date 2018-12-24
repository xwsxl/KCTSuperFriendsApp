//
//  MessageRLMModel.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/19.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "RLMObject.h"
#import "ContactRLMModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface MessageRLMModel : RLMObject
/* ****  消息ID  **** */
@property (nonatomic, copy) NSString *chatId;
/* ****  消息时间  **** */
@property (nonatomic, assign) long timeStamp;
/* ****  消息长度  **** */
@property (nonatomic, assign) double duration;
/* ****  图片宽度  **** */
@property (nonatomic, assign) CGFloat imageW;
/* ****  图片高度  **** */
@property (nonatomic, assign) CGFloat imageH;
/* ****  消息类型  **** */
@property (nonatomic, assign) NSInteger msgType;
/* ****  消息内容  **** */
@property (nonatomic, copy) NSString *msg;
/* ****  消息房间号  **** */
@property (nonatomic, copy) NSString *roomNo;
/* ****  消息联系人  **** */
@property (nonatomic, strong) ContactRLMModel *contact;

@end
RLM_ARRAY_TYPE(MessageRLMModel)
NS_ASSUME_NONNULL_END
