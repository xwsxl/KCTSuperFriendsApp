//
//  KCTSearchVC.h
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/30.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseVC.h"

@interface KCTSearchVC : KCBaseVC

@property (nonatomic,copy) void(^selectPopElement)(id model);

@property (nonatomic,strong) NSArray * dataSource;

@property (nonatomic, assign) NSInteger searchType;
@end
