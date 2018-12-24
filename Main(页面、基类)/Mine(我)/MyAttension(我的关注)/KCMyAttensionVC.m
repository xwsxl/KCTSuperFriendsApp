//
//  KCMyAttensionVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/23.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMyAttensionVC.h"

#import "KCMyAttensionTableCell.h"

#import "KCProfileInfoModel.h"

@interface KCMyAttensionVC ()<UITableViewDelegate,UITableViewDataSource>

/* ****  表视图  **** */
@property (nonatomic, strong) UITableView *tableview;
/* ****  数据源  **** */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation KCMyAttensionVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
/*
 * 调用父类的方法设置界面UI
 */
-(void)setSubViews
{
    [super setSubViews];
    XLNaviView *Navi=[[XLNaviView alloc] initWithMessage:@"我的关注" ImageName:@""];
    __weak typeof(self) weakself=self;
    Navi.qurtBlock = ^{
        [weakself qurtButClick];
    };
    [self.view addSubview:Navi];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [_tableview registerClass:[KCMyAttensionTableCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    [header setTitle:@"willrefresh" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"idle" forState:MJRefreshStateIdle];
    [header setTitle:@"pulling" forState:MJRefreshStatePulling];
    _tableview.mj_header=header;
    [_tableview.mj_header beginRefreshing];
}


#pragma mark - network

#pragma mark - events
/*
 * 刷新数据
 */
-(void)refreshHeader
{
    [_tableview.mj_header endRefreshing];
    [_tableview reloadData];
}

#pragma mark - tableview delegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCMyAttensionTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.dataModel=[self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


#pragma mark - lazy loading
/*
 * 表视图
 */
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width,KScreen_Height- KSafeAreaTopNaviHeight-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    }
    return _tableview;
}
/*
 * 数据源
 */
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc] init];
        for (int i=0; i<10; i++) {
            KCProfileInfoModel *model=[KCProfileInfoModel new];
            model.headerIconStr=@"https://img2.woyaogexing.com/2018/10/18/dff8259a6d5d40728ae907d18d68e7d3!400x400.jpeg";
            model.nickName=@"nickName";
            model.accountName=@"accountName";
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}
@end
