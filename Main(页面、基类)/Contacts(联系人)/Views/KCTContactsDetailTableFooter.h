//
//  KCContactsDetailTableFooter.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KCContactsDetailTableFooterDelegate <NSObject>

-(void)addFriendsButClick:(UIButton *)sender;

-(void)addBlackBoardButClick:(UIButton *)sender;

@end

typedef enum{
    KCContactsDetailTypeNormal=0,//默认模式详情
    KCContactsDetailTypeAddFriend,//不是好友的时候可以添加好友
    KCContactsDetailTypeControl//收到别人好友添加申请
} KCContactsDetailType;

NS_ASSUME_NONNULL_BEGIN

@interface KCTContactsDetailTableFooter : UITableViewHeaderFooterView

@property (nonatomic, assign) KCContactsDetailType type;

@property (nonatomic, weak) id<KCContactsDetailTableFooterDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
