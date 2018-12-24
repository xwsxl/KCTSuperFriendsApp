//
//  KCMyInfoVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMyInfoVC.h"

@interface KCMyInfoVC ()

@end

@implementation KCMyInfoVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)setSubViews
{
    [super setSubViews];
    
    XLNaviView *navi=[[XLNaviView alloc] initWithMessage:@"我的资料" ImageName:@""];
    __weak typeof(self) weakself=self;
    navi.qurtBlock = ^{
        [weakself qurtButClick];
    };
    [self.view addSubview:navi];
}

@end
