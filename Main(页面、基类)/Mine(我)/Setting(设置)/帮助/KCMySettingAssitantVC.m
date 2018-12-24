//
//  KCMySettingAssitantVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/24.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMySettingAssitantVC.h"

@interface KCMySettingAssitantVC ()

@end

@implementation KCMySettingAssitantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setSubViews
{
    [super setSubViews];
    XLNaviView *navi=[[XLNaviView alloc] initWithMessage:@"帮助" ImageName:@""];
    __weak typeof(self) weakself=self;
    navi.qurtBlock = ^{
        [weakself qurtButClick];
    };
    [self.view addSubview:navi];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
