//
//  KCUIAlertTools.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCUIAlertTools.h"

@implementation KCUIAlertTools
/**
 创建alert   titleArray数组为nil时,不创建确定按钮，否则都会创建
 
 @param title 标题
 @param message  信息
 @param cancelTitle  取消按钮的标题
 @param titleArray 按钮数组
 @param vc 由哪个vc推出
 @param confirm 按钮点击回调 -1为取消，0为确定，其它为titleArray下标
 */
+ (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                              cancelTitle:(NSString *)cancelTitle
                               alertStyle:(UIAlertControllerStyle)style
                               titleArray:(NSArray *)titleArray
                           viewController:(UIViewController *)vc
                                  confirm:(AlertViewBlock)confirm
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    if (cancelTitle) {
        UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [cancleAction setValue:APPOINTCOLORFirst forKey:@"_titleTextColor"];
        [alert addAction:cancleAction];
    }
    if (titleArray)
    {
        
        if (titleArray.count>0) {
            for (NSInteger i = 0; i<titleArray.count; i++) {
                UIAlertAction  *action = [UIAlertAction actionWithTitle:titleArray[i]
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    if (confirm)confirm(i);
                                                                }];
                [action setValue:APPOINTCOLORFirst forKey:@"_titleTextColor"];
                [alert addAction:action];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alert animated:YES completion:nil];
    });
    
    return alert;
}
@end
