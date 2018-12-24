//
//  KCContactsNewFriendsListVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactsNewFriendsListVC.h"
#import "KCTContactDetailInfoVC.h"

#import "KCTAddContactsFriendsCell.h"

@interface KCTContactsNewFriendsListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView  *tableview;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation KCTContactsNewFriendsListVC


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - setUI
-(void)setSubViews
{
    [super setSubViews];
    self.title=@"新朋友";
    
    self.tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
     [_tableview registerClass:[KCTAddContactsFriendsCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
//    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
//    [header setTitle:@"willrefresh" forState:MJRefreshStateWillRefresh];
//    [header setTitle:@"idle" forState:MJRefreshStateIdle];
//    [header setTitle:@"pulling" forState:MJRefreshStatePulling];
//    _tableview.mj_header=header;
//    [_tableview.mj_header beginRefreshing];
    
    [self refreshHeader];
    
}
#pragma mark - network
/*
 * <#description#>
 */
-(void)refreshHeader
{
    [self.dataSource removeAllObjects];
    [self getData];
    [self.tableview.mj_header endRefreshing];
}
/*
 * 获取好友申请l数据
 */
-(void)getData
{
    [KCNetWorkManager POST:KNSSTR(@"/friendController/getApplyList") WithParams:@{} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            NSArray *temp=response[@"data"];
            for (NSDictionary *dic in temp) {
                ContactRLMModel *model=[ContactRLMModel new];
                [model mj_setKeyValues:dic];
                [self.dataSource addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
            });
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark - events


#pragma mark - delegate
/* ****  分区  **** */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
/* ****  每一个分区的行数  **** */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
/* ****  单元格  **** */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCTAddContactsFriendsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.cellType=@"2";
    cell.dataModel=self.dataSource[indexPath.row];
    return cell;
}
/* ****  每一行的高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
/* ****  分区头高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
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
    KCTContactDetailInfoVC *VC=[[KCTContactDetailInfoVC alloc] init];
    VC.type=2;
    ContactRLMModel *model=_dataSource[indexPath.row];
    VC.account=model.account;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - lazy loading

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray new];
    }
    return _dataSource;
}

@end
