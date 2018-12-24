//
//  KCProfileVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/17.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCProfileVC.h"

#import "KCMyInfoVC.h"
#import "KCMyAttensionVC.h"
#import "KCMyFansVC.h"
#import "KCMyDiaryVC.h"
#import "KCMyQRCodeVC.h"
#import "KCMyWorkVC.h"
#import "KCMyFeedBackVC.h"
#import "KCMySettingVC.h"

#import "KCProfileSelectTableviewCell.h"
#import "KCProfileheaderCell.h"

#import "KCProfileSelectModel.h"
#import "KCProfileInfoModel.h"

@interface KCProfileVC ()<UITableViewDelegate,UITableViewDataSource>
/*
 * 数据源
 */
@property (nonatomic, strong) NSMutableArray *datasource;
/*
 * 表视图
 */
@property (nonatomic, strong) UITableView *tableview;
/*
 * 个人信息
 */
@property (nonatomic, strong) KCProfileInfoModel *dataModel;
@end

@implementation KCProfileVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview registerClass:[KCProfileSelectTableviewCell class] forCellReuseIdentifier:@"cell"];
    [_tableview registerClass:[KCProfileheaderCell class] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:_tableview];
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    [header setTitle:@"willrefresh" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"idle" forState:MJRefreshStateIdle];
    [header setTitle:@"pulling" forState:MJRefreshStatePulling];
    _tableview.mj_header=header;
    [_tableview.mj_header beginRefreshing];
}

#pragma mark - setUI
/*
 * 调用父类的方法设置UI界面
 */
-(void)setSubViews
{
    [super setSubViews];

    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc] initWithTitle:@"我" style:UIBarButtonItemStylePlain target:self action:nil];
    [leftBar setTitleTextAttributes:@{NSFontAttributeName:AppointTextFontMain} forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithImage:[KImage(@"KCMine-扫一扫") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scanQRCodeButClick:)];
    [self.navigationItem setRightBarButtonItem:rightBar];
    
    
    
    
}
#pragma mark - network

#pragma mark - events
/*
 * 扫一扫
 */
-(void)scanQRCodeButClick:(UIButton *)sender
{
    XLLog(@"scan QRCode");
}

/*
 * refresh
 */
-(void)refreshHeader
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview.mj_header endRefreshing];
    });
}

#pragma mark - delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasource.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        KCProfileheaderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.dataModel=self.dataModel;
        return cell;
    }else
    {
        KCProfileSelectTableviewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.dataModel=[self.datasource objectAtIndex:indexPath.section-1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 140;
    }else
    {
      return 66;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        /* ****  个人信息  **** */
        KCMyInfoVC *VC=[[KCMyInfoVC alloc] init];
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section==1)
    {
        /* ****  我的二维码   **** */
        KCMyQRCodeVC *VC=[[KCMyQRCodeVC alloc] init];
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if(indexPath.section ==2)
    {
        /* ****  我的任务  **** */
        KCMyWorkVC *VC=[[KCMyWorkVC alloc] init];
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section ==3)
    {
        /* ****  用户反馈  **** */
        KCMyFeedBackVC *VC=[[KCMyFeedBackVC alloc] init];
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else
    {
        /* ****  设置  **** */
        KCMySettingVC *VC=[[KCMySettingVC alloc] init];
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController jz_pushViewController:VC animated:YES completion:nil];
        //[self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - lazy loading
/*
 * 数据源懒加载
 */
-(NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource=[[NSMutableArray alloc] init];
        NSArray *iconurlarr=@[@"KCMine-我的二维码",@"KCMine-我的任务",@"KCMine-用户反馈",@"KCMine-设置"];
        NSArray *titlearr=@[@"我的二维码",@"我的任务",@"用户反馈",@"设置"];
        for (int i=0; i<iconurlarr.count; i++) {
            KCProfileSelectModel *model=[KCProfileSelectModel new];
            model.iconStr=iconurlarr[i];
            model.title=titlearr[i];
            [_datasource addObject:model];
        }
    }
    return _datasource;
}
/*
 * 个人信息
 */
-(KCProfileInfoModel *)dataModel
{
    if (!_dataModel) {
        _dataModel=[KCProfileInfoModel new];
        _dataModel=[KCUserDefaultManager getInfoModel];
    }
    return _dataModel;
    
}

@end
