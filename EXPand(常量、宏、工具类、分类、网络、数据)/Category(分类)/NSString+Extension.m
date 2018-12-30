//
//  NSString+Extension.m
//  YFQChildPro
//
//  Created by ab on 2017/4/12.
//  Copyright © 2017年 YFQ. All rights reserved.
//

#import "NSString+Extension.h"
/*** MD5 ***/
typedef uint32_t CC_LONG;       /* 32 bit unsigned integer */
typedef uint64_t CC_LONG64;     /* 64 bit unsigned integer */

#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */
#define CC_MD5_BLOCK_BYTES      64          /* block size in bytes */
#define CC_MD5_BLOCK_LONG       (CC_MD5_BLOCK_BYTES / sizeof(CC_LONG))

typedef struct CC_MD5state_st
{
    CC_LONG A,B,C,D;
    CC_LONG Nl,Nh;
    CC_LONG data[CC_MD5_BLOCK_LONG];
    int num;
} CC_MD5_CTX;

extern int CC_MD5_Init(CC_MD5_CTX *c)
API_AVAILABLE(macos(10.4), ios(2.0));

extern int CC_MD5_Update(CC_MD5_CTX *c, const void *data, CC_LONG len)
API_AVAILABLE(macos(10.4), ios(2.0));

extern int CC_MD5_Final(unsigned char *md, CC_MD5_CTX *c)
API_AVAILABLE(macos(10.4), ios(2.0));

extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)
API_AVAILABLE(macos(10.4), ios(2.0));

@implementation NSString (Extension)

/**
 Description 计算文本尺寸

 @param font 文本字体
 @param maxSize 限制
 @return <#return value description#>
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *attrs = @{NSFontAttributeName: font};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 Description 是否是中文

 @return <#return value description#>
 */
-(BOOL)isChinese {
    
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    return [predicate evaluateWithObject:self];
}

/**
 *  检查手机号码
 *
 *  @return return Yes or No
 */
- (BOOL)phoneNumberIsCorrect {
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|7[0-9]|8[0-9])[0-9]|3456788)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 Description 检查是否为正确邮箱

 @return <#return value description#>
 */
- (BOOL)validateEmail
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

+(instancetype)stringWithPrice:(id)price andInterger:(id)interger
{

    price=[NSString stringWithFormat:@"%@",price];
    interger=[NSString stringWithFormat:@"%@",interger];

    if (!price||[price containsString:@"null"]||[price isEqualToString:@""]) {
        price=@"0.00";
    }
    if (!interger||[interger containsString:@"null"]||[interger isEqualToString:@""]) {
        interger=@"0.00";
    }

    return [NSString stringWithFormat:@"￥%.2f+%.2f积分",[price floatValue],[interger floatValue]];
}

-(NSString *)md5{
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
    NSMutableString *hash =[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

+(instancetype)randomNumString
{
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=8;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return [resultArray componentsJoinedByString:@""];
}
+ (instancetype)dateString{
    
    NSDate *confromTimesp = [NSDate date];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormat stringFromDate:confromTimesp];
    
}

//判断时间是否是今天 昨天 星期几 几月几日
+ (NSString *)achieveDayFormatByTimeString:(NSString *)timeString withOutTimeDetail:(BOOL)showTimeDetail
{
    if (!timeString || timeString.length < 10) {
        return @"时间未知";
    }
    //将时间戳转为NSDate类
    NSTimeInterval time = [[timeString substringToIndex:10] doubleValue];
    NSDate *inputDate=[NSDate dateWithTimeIntervalSince1970:time];
    //
    NSString *lastTime = [self compareDate:inputDate withBOOL:showTimeDetail];
    return lastTime;
}

//判断时间是否是今天 昨天 星期几 几月几日
+ (NSString *)achieveDayFormatByTimeString:(NSString *)timeString
{
    return [NSString achieveDayFormatByTimeString:timeString withOutTimeDetail:YES];
}

+ (NSString *)compareDate:(NSDate *)inputDate withBOOL:(BOOL)showTimeDetail{
    
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger goalInterval = [zone secondsFromGMTForDate: inputDate];
    NSDate *date = [inputDate  dateByAddingTimeInterval: goalInterval];
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSInteger localInterval = [zone secondsFromGMTForDate: currentDate];
    NSDate *localeDate = [currentDate  dateByAddingTimeInterval: localInterval];
    
    //今天／昨天／前天
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *today = localeDate;
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSDate *beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    //今年
    NSString *toYears = [[today description] substringToIndex:4];
    
    //目标时间拆分为 年／月
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        //时间
        NSString *time3 = [[date description] substringWithRange:(NSRange){11,5}];
        if ([dateString isEqualToString:todayString]){
            //今天
            dateContent = [NSString stringWithFormat:@"%@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            //昨天
            dateContent = [NSString stringWithFormat:@"昨天"];
            if (showTimeDetail) {
                dateContent=[dateContent stringByAppendingString:[NSString stringWithFormat:@" %@",time]];
            }
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            //前天
            dateContent = [NSString stringWithFormat:@"前天"];
            if (showTimeDetail) {
                dateContent=[dateContent stringByAppendingString:[NSString stringWithFormat:@" %@",time]];
            }
            return dateContent;
        }else{
            if ([self compareDateFromeWorkTimeToNow:time2]) {
                //一周之内，显示星期几
                dateContent=[NSString stringWithFormat:@"%@",[[self class] weekdayStringFromDate:inputDate]];
                if (showTimeDetail) {
                    dateContent=[dateContent stringByAppendingString:[NSString stringWithFormat:@" %@",time]];
                }
                return dateContent;
                
            }else{
                //一周之外，显示“月-日 时：分” ，如：05-23 06:22
                return time2;
            }
        }
    }else{
        //不同年，显示具体日期：如，2008-11-11
        return dateString;
    }
}
//比较在一周之内还是之外
+ (BOOL)compareDateFromeWorkTimeToNow:(NSString *)timeStr
{
    //获得当前时间并转为字符串 2017-07-16 07:54:36 +0000(NSDate类)
    NSDate *currentDate = [NSDate date];
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//实例化时间格式类
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//格式化
    NSString *timeString = [df stringFromDate:currentDate];
    timeString = [timeString substringFromIndex:5];
    
    int today = [timeString substringWithRange:(NSRange){3,2}].intValue;
    int workTime = [timeStr substringWithRange:(NSRange){3,2}].intValue;
    if ([[timeStr substringToIndex:2] isEqualToString:[timeString substringToIndex:2]]) {
        if (today - workTime <= 6) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
//返回星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
//获取消息时间毫秒
+ (long)getTimeStamp
{
    NSDate *currentDate = [NSDate date];
    long timeStamp=(long)([currentDate timeIntervalSince1970]*1000);
    return timeStamp;
}

//获取消息唯一id
+ (NSString *)getMessageChatId
{
    NSString *str=[[NSString alloc] init];
    
    str=[NSString stringWithFormat:@"%ld%@",[NSString getTimeStamp], [KCUserDefaultManager getAccount]];
    str=[str md5];
    return str;
}
@end
