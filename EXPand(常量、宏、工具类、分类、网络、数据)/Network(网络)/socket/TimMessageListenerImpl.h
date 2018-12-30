//
//  TimMessageListenerImpl.h
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/24.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
@interface TimMessageListenerImpl : NSObject<TIMMessageListener>

/**
 *  新消息回调通知
 *
 *  @param msgs 新消息列表，TIMMessage 类型数组
 */
- (void)onNewMessage:(NSArray*) msgs;

@end
