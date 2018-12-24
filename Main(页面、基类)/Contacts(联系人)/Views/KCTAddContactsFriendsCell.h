//
//  KCCAddContactsFriendsCell.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/26.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseTableViewCell.h"

@protocol KCCAddContactsFriendsCellDelegate <NSObject>

-(void)attensionButClick:(KCProfileInfoModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KCTAddContactsFriendsCell : KCBaseTableViewCell
/* ****  type 0:添加  1:手机联系人 邀请 2:查看 好友申请 **** */
@property (nonatomic, copy) NSString *cellType;

@property (nonatomic, weak) id<KCCAddContactsFriendsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
