//
//  KCTSetAliasNameVC.h
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/4.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseVC.h"

@interface KCTNormalChangeInfoVC : KCBaseVC

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *placehodle;

@property (nonatomic, copy) void(^sureChangeTextBlock)(NSString *text);

@end
