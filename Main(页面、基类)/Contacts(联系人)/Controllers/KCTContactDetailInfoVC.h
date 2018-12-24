//
//  KCTContactDetailInfoVC.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseVC.h"

#import "KCTContactsDetailTableFooter.h"


NS_ASSUME_NONNULL_BEGIN

@interface KCTContactDetailInfoVC : KCBaseVC

@property (nonatomic, strong) NSString *account;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, assign)  KCContactsDetailType type;

@end

NS_ASSUME_NONNULL_END
