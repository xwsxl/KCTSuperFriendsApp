//
//  KCSetVoicePasswordVC.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/6.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseVC.h"
typedef enum{
    KCSetVoicePasswordTypeFirst = 0, // 第一次
    KCSetVoicePasswordTypeSecond, // 第二次
    KCSetVoicePasswordTypeNotify
} KCSetVoiceOptions;
NS_ASSUME_NONNULL_BEGIN


@interface KCSetVoicePasswordVC : KCBaseVC

@property (nonatomic, assign) KCSetVoiceOptions voiceOptions;

@property (nonatomic, assign) BOOL isReset;
@end

NS_ASSUME_NONNULL_END
