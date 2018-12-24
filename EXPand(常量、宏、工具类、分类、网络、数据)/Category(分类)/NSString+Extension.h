//
//  NSString+Extension.h
//  YFQChildPro
//
//  Created by ab on 2017/4/12.
//  Copyright © 2017年 YFQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

/**
 Description 是否是中文

 @return <#return value description#>
 */
-(BOOL)isChinese;

/**
 Description 是否是手机号格式

 @return <#return value description#>
 */
- (BOOL)phoneNumberIsCorrect;

/**
 Description 计算文本长度

 @param font 文本字体
 @param maxSize 文本限制尺寸
 @return <#return value description#>
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
/*
 * 生成0-9随机乱序的字符串
 */
+(instancetype)randomNumString;
/*
 * 生成时间字符串
 */
+ (instancetype)dateString;

+(instancetype)stringWithPrice:(id )price andInterger:(id )interger;

-(NSString *)md5;

+ (NSString *)achieveDayFormatByTimeString:(NSString *)timeString withOutTimeDetail:(BOOL)showTimeDetail;
//判断时间是否是今天 昨天 星期几 几月几日
+ (NSString *)achieveDayFormatByTimeString:(NSString *)timeString;
//获取消息时间毫秒
+ (long)getTimeStamp;
//获取消息唯一id
+ (NSString *)getMessageChatId;
@end
