//
//  KCMessageAddSelectionView.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KCMessageAddSelectionViewDelegate <NSObject>
/*
 * 创建群聊
 */
-(void)creatGroupChatButClick:(UIButton *)sender;
/*
 * 添加好友
 */
-(void)addFriendsButClick:(UIButton *)sender;
/*
 * 扫一扫
 */
-(void)scanQRCodeButClick:(UIButton *)sender;

@end

@interface KCMessageAddSelectionView : KCBaseView

@property (nonatomic, weak) id<KCMessageAddSelectionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
