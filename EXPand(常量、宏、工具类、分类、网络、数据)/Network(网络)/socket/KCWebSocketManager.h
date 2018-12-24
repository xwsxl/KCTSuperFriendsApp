//
//  KCWebSocketManager.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

NS_ASSUME_NONNULL_BEGIN

@interface KCWebSocketManager : NSObject
// 获取连接状态
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

+ (KCWebSocketManager *)instance;

- (void)SRWebSocketOpen;//开启连接
- (void)SRWebSocketClose;//关闭连接
- (void)sendData:(id)data;//发送数据

@end

NS_ASSUME_NONNULL_END




