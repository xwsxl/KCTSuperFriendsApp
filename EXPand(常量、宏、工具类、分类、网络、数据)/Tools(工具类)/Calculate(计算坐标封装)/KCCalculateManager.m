//
//  KCCalculateManager.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCCalculateManager.h"

@implementation KCCalculateManager

+ (CGFloat)calculateWidthWithNum:(NSInteger)num {
    // 750x1334
    CGFloat scale = num / 375.0;
    CGFloat width = KScreen_Width * scale;
    
    return width;
}

+ (CGFloat)calculateHeightWithNum:(NSInteger)num {
    
    CGFloat scale = num / 667.0;
    CGFloat heigth = KScreen_Height * scale;
    if (KScreen_Height==812.0) {
        heigth=667*scale;
    }else if (KScreen_Height==896.0)
    {
        heigth=751*scale;
    }
    return heigth;
}

@end
