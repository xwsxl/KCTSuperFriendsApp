//
//  KCTAlertView.h
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/6.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseView.h"

@interface KCTAlertView : KCBaseView

-(instancetype)initCantactsAlertViewWithModel:(ContactRLMModel *)model;
// 备注的block
@property (nonatomic, copy) void(^aliasBlock)(void);
// 消息的block
@property (nonatomic, copy) void(^messageBlock)(void);
// 读播的block
@property (nonatomic, copy) void(^readOnBlock)(void);
// 视频的block
@property (nonatomic, copy) void(^videoBlock)(void);


- (void)showRSAlertView;

@end
