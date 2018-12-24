//
//  KCBaseModel.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseModel.h"
@implementation KCBaseModel


-(NSString *)description
{
    return [self mj_JSONString];
}

@end
