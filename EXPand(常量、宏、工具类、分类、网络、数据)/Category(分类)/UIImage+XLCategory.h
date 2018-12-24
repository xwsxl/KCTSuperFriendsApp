//
//  UIImage+XLCategory.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/24.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XLCategory)
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGSize )size;
//获取启动图
+ (UIImage *)getLaunchImage;
//获取二维码
+ (UIImage *)createQRCodeImageWithString:(nonnull NSString *)codeString andSize:(CGSize)size andBackColor:(nullable UIColor *)backColor andFrontColor:(nullable UIColor *)frontColor andCenterImage:(nullable UIImage *)centerImage;
@end

NS_ASSUME_NONNULL_END
