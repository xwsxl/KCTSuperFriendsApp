//
//  UIView+VC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/15.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "UIView+VC.h"

@implementation UIView (VC)
-(UIViewController *)findViewController:(UIView*)view
{
    id target=view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}
@end
