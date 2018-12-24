//
//  KCTSendDataManager.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/26.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCTSendDataManager : NSObject


+(BOOL)sendReceiptWithChatID:(NSString *)chatID to:(NSString *)to;

/* ****  andChatType  **** */
+(void)SendMessage:(MessageRLMModel *)model andRoom:(RoomRLMModel *)Rmodel;

@end

NS_ASSUME_NONNULL_END
