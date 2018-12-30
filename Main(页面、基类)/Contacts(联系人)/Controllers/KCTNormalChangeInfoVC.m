//
//  KCTSetAliasNameVC.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/4.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTNormalChangeInfoVC.h"

@interface KCTNormalChangeInfoVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *TF;

@end

@implementation KCTNormalChangeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设置备注";
    if (_titleStr) {
        self.navigationItem.title=self.titleStr;
    }
   
    [self.view setBackgroundColor:RGBHex(0xf7f9fa)];
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+14, KScreen_Width, 43)];
    [backView setBackgroundColor:RGBHex(0xffffff)];
    [self.view addSubview:backView];
    self.TF=[[UITextField alloc] initWithFrame:CGRectMake(15, 0, KScreen_Width-30, 43)];
    _TF.delegate=self;
    _TF.keyboardType=UIKeyboardTypeDefault;
    _TF.returnKeyType=UIReturnKeyDone;
    _TF.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    _TF.placeholder=@"请输入备注名";
    if (_placehodle) {
        _TF.placeholder=self.placehodle;
    }
    [backView addSubview:_TF];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_TF.text.length>0) {
        if (self.sureChangeTextBlock) {
            self.sureChangeTextBlock(_TF.text);
        }
    }else
    {
        [_TF resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr=titleStr;
    self.navigationItem.title=titleStr;
}
-(void)setPlacehodle:(NSString *)placehodle
{
    _placehodle=placehodle;
    _TF.placeholder=placehodle;
}

@end
