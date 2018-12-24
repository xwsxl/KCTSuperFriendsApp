//
//  KCCalculateManager.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCCalculateManager : NSObject
/*
 * 封装width和height
 */
+ (CGFloat)calculateWidthWithNum:(NSInteger)num;
+ (CGFloat)calculateHeightWithNum:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
