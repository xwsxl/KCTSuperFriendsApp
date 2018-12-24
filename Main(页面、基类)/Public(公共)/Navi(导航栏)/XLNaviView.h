//
//  XLNaviView.h
//  XLTaoMall
//
//  Created by Hawky on 2018/5/29.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XLNaviView : UIView
/**
 初始化基本导航栏

 @param msg 导航栏title
 @param imgName 返回按钮图片
 @return 导航栏 默认为64个像素、适配了iphone X
 */
-(instancetype)initWithMessage:(NSString *)msg ImageName:(NSString *)imgName;
/**
 初始化基本导航栏

 @param frame 传入导航栏frame
 @param msg 导航栏title
 @param imgName 返回按钮图片
 @return 导航栏
 */
-(instancetype)initWithFrame:(CGRect )frame AndMessage:(NSString *)msg ImageName:(NSString *)imgName;

@property (nonatomic,copy)void (^qurtBlock)(void);

@end
