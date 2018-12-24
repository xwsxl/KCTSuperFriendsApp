//
//  ContactRLMModel.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/17.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "ContactRLMModel.h"

@implementation ContactRLMModel

+(NSString *)primaryKey
{
    return @"account";
}

+(NSArray<NSString *> *)ignoredProperties
{
    return @[@"content"];
}
-(NSString *)aliasName
{
    if (!_aliasName) {
        _aliasName=_nickName;
    }
    return _aliasName;
}
@end
