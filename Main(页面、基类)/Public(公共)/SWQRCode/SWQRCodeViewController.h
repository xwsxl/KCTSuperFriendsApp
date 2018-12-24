//
//  SWQRCodeViewController.h
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCode.h"
typedef enum{
    KCScanOptionsLogin=0,
    KCScanOptionsHelpLogin
} KCScanOptions;

@interface SWQRCodeViewController : UIViewController

@property (nonatomic, assign) KCScanOptions scanOptions;

@property (nonatomic, strong) SWQRCodeConfig *codeConfig;

@end
