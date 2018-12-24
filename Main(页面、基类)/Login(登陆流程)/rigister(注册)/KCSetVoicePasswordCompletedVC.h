//
//  KCSetVoicePasswordCompletedVC.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseVC.h"

typedef enum{
    KCSetVoicePasswordTypeSuccess = 0, // 第一次
    KCSetVoicePasswordTypeFailed, // 第二次
    KCSetVoicePasswordTypeNotifyFailed
} KCSetVoiceStatusOptions;

NS_ASSUME_NONNULL_BEGIN

@interface KCSetVoicePasswordCompletedVC : KCBaseVC

@property (nonatomic, assign) KCSetVoiceStatusOptions voiceStatusOption;

@property (nonatomic, assign) BOOL isReset;

@end

NS_ASSUME_NONNULL_END
