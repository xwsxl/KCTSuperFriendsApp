//
//  KCMacros.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/11.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#ifndef KCMacros_h
#define KCMacros_h

#pragma mark - 系统常用

#define KApplication [UIApplication sharedApplication]
#define KUserDefaults [NSUserDefaults standardUserDefaults]
#define KNotificationCenter [NSNotificationCenter defaultCenter]
#define KDeviceID [[UIDevice currentDevice].identifierForVendor UUIDString] //设备唯一标识
#define CurrentSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue] //获取系统版本

#pragma mark - 常用代码
/*****  APP版本号 *****/
#define KVersion_XL [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
/*****  APPBuild版本号 *****/
#define KVersionBuild_XL [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
/*****  URL *****/
#define KNSURL(A) [NSURL URLWithString:A]
#define KNSPHOTOURL(A) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,A]]
#define KNSSTR(A) [NSString stringWithFormat:@"%@%@",ServerUrl,A]
/*****  图片 *****/
#define KImage(A) [UIImage imageNamed:A]
/*****  最大的size *****/
#define KMAXSIZE CGSizeMake(MAXFLOAT, MAXFLOAT)
/*****  RGB颜色 *****/
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
/*****  hex颜色 *****/
#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

/*****  手机屏幕尺寸 *****/
#define KScreen_Size [UIScreen mainScreen].bounds.size
/*****  手机屏幕Bounds *****/
#define KScreen_Bounds [UIScreen mainScreen].bounds
/*****  屏高 *****/
#define KScreen_Height [UIScreen mainScreen].bounds.size.height
/*****  屏宽 *****/
#define KScreen_Width [UIScreen mainScreen].bounds.size.width
/*****  iphone X适配 *****/
#define KIsBangScreen (KScreen_Height==812.0?YES:(KScreen_Height==896.0?YES:NO))
#define KSafeTopHeight (KIsBangScreen?24:0)
#define KSafeAreaTopNaviHeight (KIsBangScreen ? 88 : 64)
#define KSafeAreaBottomHeight (KIsBangScreen ? 34 : 0)
#define WeakSelf  __weak __typeof(&*self)weakSelf = self;

/*****  封装的计算坐标 *****/
#define CWidth(x) [KCCalculateManager calculateWidthWithNum:x]
#define CHeight(y) [KCCalculateManager calculateHeightWithNum:y]

/*****  重写NSLog,DeBug模式下打印当前日志和当前行数 *****/
#if DEBUG
#define XLLog(FORMAT, ...) fprintf(stderr,"%s line:%d ------->---> %s\n\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define XLLogRect(rect) XLLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define XLLogSize(size) XLLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define XLLogPoint(point) XLLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)
#else
#define XLLog(FORMAT, ...) nil
#endif
#pragma mark - 约定
/*****  APP约定色调 *****/
#define APPOINTCOLORFirst RGBHex(0x858c96)
#define APPOINTCOLORSecond RGBHex(0x252525)
#define APPOINTCOLORThird RGBHex(0x1b88ee)
#define APPOINTCOLORFourth RGBHex(0x7fcffb)
#define APPOINTCOLORFifth RGBHex(0x727272)
#define APPOINTCOLORSixth RGBHex(0xafb2b5)

#define kGrayColor  RGB(196, 197, 198)
#define kGreenColor kBlueColor    //绿色主调
#define kBlueColor  RGBHex(0x0e92dd)          //蓝色主调

/*****  APP约定字号 *****/
#define AppointTextFontMain [UIFont fontWithName:@"PingFangSC-Regular" size:20]
#define AppointTextFontFirst [UIFont fontWithName:@"PingFangSC-Regular" size:27]
#define AppointTextFontSecond [UIFont fontWithName:@"MicrosoftYaHei" size:16]
#define AppointTextFontThird [UIFont fontWithName:@"MicrosoftYaHei" size:14]
#define AppointTextFontFourth [UIFont fontWithName:@"MicrosoftYaHei" size:12]

/*****  灰色分割线 *****/
#define MAINSEPRATELINECOLOR RGB(224, 224, 224)


#endif /* KCMacros_h */
