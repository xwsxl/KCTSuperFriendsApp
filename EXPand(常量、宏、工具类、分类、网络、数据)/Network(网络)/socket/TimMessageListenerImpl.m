//
//  TimMessageListenerImpl.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/24.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "TimMessageListenerImpl.h"
#import <IMMessageExt/IMMessageExt.h>
#import "KCTReceiveDataManager.h"
@implementation TimMessageListenerImpl
/**
 *  新消息回调通知
 *
 *  @param msgs 新消息列表，TIMMessage 类型数组
 */
- (void)onNewMessage:(NSArray*) msgs
{
    XLLog(@"NewMessages: %@", msgs);
    
   // TIMMessage *msg=[msgs lastObject];
   // TIMConversation *conv=[msg getConversation];
    for (TIMMessage *message in msgs) {
        if ([[message getElem:0] isKindOfClass:[TIMTextElem class]]) {
            TIMTextElem *elem=(TIMTextElem *)[message getElem:0];
            if (!message.isSelf) {
                NSString *str=[elem text];
                str=[str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                XLLog(@"--%@",str);
                [[KCTReceiveDataManager instance] dealWithMessage:str];
            }
        }
       
    }
//    [conv getMessage:50 last:msg succ:^(NSArray *msgs) {
//        XLLog(@"lastMessages: %@", msgs);
//        XLLog(@"lastaccount=%ld",msgs.count);
//    } fail:^(int code, NSString *msg) {
//
//    }];
    
}
@end
