//
//  NSObject+Category.h
//  aTaohMall
//
//  Created by DingDing on 2017/8/17.
//  Copyright © 2017年 ysy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)
/**
 *  自动生成属性列表
 *
 *  @param dict JSON字典/模型字典
 */
+(void)printPropertyWithDict:(NSDictionary *)dict;
@end
