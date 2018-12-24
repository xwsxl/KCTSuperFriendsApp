//
//  UIButton+UIButton_XLCategory.h
//  XLTaoMall
//
//  Created by Hawky on 2018/5/30.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <UIKit/UIKit.h>
// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, XLButtonEdgeInsetsStyle) {
    XLButtonEdgeInsetsStyleImageTop, // image在上，label在下
    XLButtonEdgeInsetsStyleImageLeft, // image在左，label在右
    XLButtonEdgeInsetsStyleImageBottom, // image在下，label在上
    XLButtonEdgeInsetsStyleImageRight // image在右，label在左
};

@interface UIButton (UIButton_XLCategory)
/**
 * 设置button的titleLabel和imageView的布局样式，及间距
 *
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;

@end
