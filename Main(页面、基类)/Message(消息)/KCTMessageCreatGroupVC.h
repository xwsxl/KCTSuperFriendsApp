//
//  KCTContactsCreatGroupVC.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/16.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCTMessageCreatGroupVC : KCBaseVC

/* ****  确定选择联系人  **** */
@property (nonatomic, copy) void (^sureSelectBlock)(NSArray <ContactRLMModel *>*contactsArr);

@end

NS_ASSUME_NONNULL_END
