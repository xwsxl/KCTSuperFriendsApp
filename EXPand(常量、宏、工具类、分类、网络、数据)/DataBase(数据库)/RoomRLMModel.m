//
//  RoomRLMModel.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/19.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "RoomRLMModel.h"

@implementation RoomRLMModel

+(NSString *)primaryKey
{
    return @"roomNo";
}

-(int)unreadNum
{
    if (!_unreadNum) {
        _unreadNum=0;
    }
    return _unreadNum;
}

@end
