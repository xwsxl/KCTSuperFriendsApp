//
//  MessageRLMModel.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/19.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "MessageRLMModel.h"

@implementation MessageRLMModel
+(NSString *)primaryKey
{
    return @"chatId";
}
-(double)duration
{
    if (!_duration) {
        _duration=0.f;
    }
    return _duration;
}
-(CGFloat)imageW
{
    if (!_imageW) {
        _imageW=0.1f;
    }
    return _imageW;
}
-(CGFloat)imageH
{
    if (!_imageH) {
        _imageH=0.1f;
    }
    return _imageH;
}
+(NSArray<NSString *> *)ignoredProperties
{
    return @[@"attributedString"];
}
@end
