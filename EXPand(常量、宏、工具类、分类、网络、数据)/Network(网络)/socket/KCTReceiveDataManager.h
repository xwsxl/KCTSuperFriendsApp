//
//  KCTReceiveDataManager.h
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCTReceiveDataManager : NSObject
+ (KCTReceiveDataManager *)instance;

-(void)dealWithMessage:(id)message;

@end
