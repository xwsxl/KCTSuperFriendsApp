//
//  NSURL+KC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/13.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "NSURL+KC.h"
#import <objc/message.h>
#import <objc/runtime.h>
@implementation NSURL (KC)

+(void)load
{
    /*
     * 获取l两个方法的imp指针、并交换
     * 外界调用系统的urlWithString: 方法的时候会改为调用 KCURLWithStr: 方法
     */
    Method systemUrlM = class_getClassMethod([self class], @selector(URLWithString:));
    Method KCUrl = class_getClassMethod([self class], @selector(KC_URLWithStr:));
    method_exchangeImplementations(systemUrlM, KCUrl);
}

/* ****  添加url判断  **** */
+(instancetype)KC_URLWithStr:(NSString *)str
{
    /*
     * 注意由于imp指针交换 这里调用KC_URLWithStr: 方法就是调用了系统的URLWithString:方法
     * 如果调用NSURL的URLWithString:方法 会造成循环
     */
    NSURL *url=[NSURL KC_URLWithStr:str];
    if (!url) {
        XLLog(@"url is nil");
    }
    return url;
}

@end
