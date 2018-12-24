//
//  KCMySettingVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/23.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMySettingVC.h"
#import "KCMySettingAssitantVC.h"
#import "KCMySettingVoiceLockVC.h"
#import "KCMySettingNewMsgNotiVC.h"
#import "KCMySettingAboutSuperFriendVC.h"

#import "KCLoginHomeVC.h"

#import "KCMySettingCell.h"




@interface KCMySettingVC ()<UITableViewDelegate,UITableViewDataSource>

/* ****  数据源  **** */
@property (nonatomic, strong) NSMutableArray *dataSource;
/* ****  表视图  **** */
@property (nonatomic, strong) UITableView *tableview;

@end

@implementation KCMySettingVC


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
/*
 * 布局
 */
-(void)setSubViews
{
    [super setSubViews];
    XLNaviView *navi=[[XLNaviView alloc] initWithMessage:@"设置" ImageName:@""];
    __weak typeof(self) weakself=self;
    navi.qurtBlock = ^{
        [weakself qurtButClick];
    };
    [self.view addSubview:navi];
    
    [self.view setBackgroundColor:MAINSEPRATELINECOLOR];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [_tableview registerClass:[KCMySettingCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
    
    UIButton *switchAccountBut=[UIButton buttonWithType:UIButtonTypeCustom];
    switchAccountBut.frame=CGRectMake(0,KSafeAreaTopNaviHeight+52*4+CWidth(10)*3+CWidth(20), KScreen_Width, 52);
    [switchAccountBut setBackgroundColor:[UIColor whiteColor]];
    [switchAccountBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [switchAccountBut.titleLabel setFont:AppointTextFontSecond];
    [switchAccountBut setTitle:@"切换帐号" forState:UIControlStateNormal];
    [switchAccountBut addTarget:self action:@selector(switchAccountButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchAccountBut];
    
    UIButton *logOutBut=[UIButton buttonWithType:UIButtonTypeCustom];
    logOutBut.frame=CGRectMake(0, KSafeAreaTopNaviHeight+52*4+CWidth(10)*3+CWidth(20)*2+52, KScreen_Width, 52);
    [logOutBut setBackgroundColor:[UIColor whiteColor]];
    [logOutBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [logOutBut.titleLabel setFont:AppointTextFontSecond];
    [logOutBut setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutBut addTarget:self action:@selector(logOutButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutBut];
    
}

#pragma mark - network

#pragma mark - events
/*
 * 切换账号
 */
-(void)switchAccountButClick:(UIButton *)sender
{
    XLLog(@"switch Account");
    [KCUserDefaultManager setLoginStatus:NO];
    KCLoginHomeVC *VC=[[KCLoginHomeVC alloc] init];
    UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:VC];
    VC.navigationController.navigationBar.hidden=YES;
    self.view.window.rootViewController=navi;
}
/*
 * 退出登录
 */
-(void)logOutButClick:(UIButton *)sender
{
    XLLog(@"log out");
    [KCUserDefaultManager setLoginStatus:NO];
    
    KCLoginHomeVC *VC=[[KCLoginHomeVC alloc] init];
    UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:VC];
    VC.navigationController.navigationBar.hidden=YES;
    self.view.window.rootViewController=navi;
}
#pragma mark - delegate
/* ****  分区  **** */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
/* ****  每一个分区的行数  **** */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return (section==2)?2:1;
}
/* ****  单元格  **** */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCMySettingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLab.text=[self.dataSource objectAtIndex:indexPath.section+indexPath.row];
    return cell;
}
/* ****  每一行的高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
/* ****  分区头高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CWidth(10);
}
/* ****  分区尾高度  **** */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
/* ****  分区头视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
/* ****  分区尾视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        /* ****  声音锁  **** */
        KCMySettingVoiceLockVC *VC=[[KCMySettingVoiceLockVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section==1)
    {
        /* ****  新消息通知  **** */
        KCMySettingNewMsgNotiVC *VC=[[KCMySettingNewMsgNotiVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else
    {
        if (indexPath.row==0) {
            /* ****  帮助与反馈  **** */
            KCMySettingAssitantVC *VC=[[KCMySettingAssitantVC alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }else
        {
            /* ****  关于超级好友  **** */
            KCMySettingAboutSuperFriendVC *VC=[[KCMySettingAboutSuperFriendVC alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}
#pragma mark - lazy loading

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@"声音密码",@"新消息通知",@"帮助与反馈",@"关于超级好友"]];
    }
    return _dataSource;
}

-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, 52*4+CWidth(10)*3) style:UITableViewStyleGrouped];
        _tableview.bounces=NO;
    }
    return _tableview;
}

@end
