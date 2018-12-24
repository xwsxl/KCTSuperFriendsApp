//
//  KCTContactsFriendsNotifyVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/15.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactsFriendsNotifyVC.h"

@interface KCTContactsFriendsNotifyVC ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *notifyTV;

@end

@implementation KCTContactsFriendsNotifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setSubViews
{
    [super setSubViews];
    self.title=@"朋友验证";
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(qurtButClick)];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAddFriendsBarClick)];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    [self.navigationItem setRightBarButtonItem:rightBar];
    
    self.view.backgroundColor=MAINSEPRATELINECOLOR;
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(CWidth(15), KSafeAreaTopNaviHeight, KScreen_Width-CWidth(30), 20)];
    lab.font=AppointTextFontThird;
    lab.textColor=APPOINTCOLORFifth;
    lab.text=@"你需要发送验证申请，等对方通过";
    [self.view addSubview:lab];
    
    _notifyTV=[[UITextView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+20, KScreen_Width, 46)];
    _notifyTV.delegate=self;
    _notifyTV.backgroundColor=[UIColor whiteColor];
    _notifyTV.keyboardType=UIKeyboardTypeDefault;
    _notifyTV.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_notifyTV];
    
}

-(void)sureAddFriendsBarClick
{
    XLLog(@"确定添加");
    [_notifyTV resignFirstResponder];
    [KCNetWorkManager POST:KNSSTR(@"/friendController/applyFriend") WithParams:@{@"toAccount":_dataModel.account,@"content":_notifyTV.text} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        [MBProgressHUD showMessage:response[@"msg"]];
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}



@end
