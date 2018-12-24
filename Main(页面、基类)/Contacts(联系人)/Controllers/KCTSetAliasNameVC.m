//
//  KCTSetAliasNameVC.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/4.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTSetAliasNameVC.h"

@interface KCTSetAliasNameVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *TF;

@end

@implementation KCTSetAliasNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设置备注";
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
    [backView addSubview:_TF];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_TF.text.length>0) {
        WeakSelf
        [KCNetWorkManager POST:KNSSTR(@"/friendController/updateFriend") WithParams:@{@"friendAccount":_model.account,@"aliasName":_TF.text} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    weakSelf.model.aliasName=weakSelf.TF.text;
                }];
                 [weakSelf qurtButClick];
                 [KNotificationCenter postNotificationName:KCContactsChangeNoti object:nil];
            }
            [MBProgressHUD showMessage:response[@"msg"]];
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
    }else
    {
        [_TF resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
