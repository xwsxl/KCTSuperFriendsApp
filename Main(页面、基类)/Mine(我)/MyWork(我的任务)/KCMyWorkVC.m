//
//  KCMyWorkVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/23.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMyWorkVC.h"

#import "KCMyWorkCell.h"

#import "KCMyWorkModel.h"
@interface KCMyWorkVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation KCMyWorkVC


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
/*
 * setUI
 */
-(void)setSubViews
{
    XLNaviView *navi=[[XLNaviView alloc] initWithMessage:@"我的任务" ImageName:@""];
    __weak typeof(self) weakself=self;
    navi.qurtBlock = ^{
        [weakself qurtButClick];
    };
    [self.view addSubview:navi];
    
    [self.view setBackgroundColor:MAINSEPRATELINECOLOR];
    UIButton *uncompletionWorkBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [uncompletionWorkBut setFrame:CGRectMake(0, KSafeAreaTopNaviHeight+CWidth(5), KScreen_Width/2.0, 41)];
    [uncompletionWorkBut setTitle:@"未完成清单" forState:UIControlStateNormal];
    [uncompletionWorkBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [uncompletionWorkBut.titleLabel setFont:AppointTextFontThird];
    [uncompletionWorkBut setBackgroundColor:[UIColor whiteColor]];
    [uncompletionWorkBut setImage:KImage(@"KCMine-下拉") forState:UIControlStateNormal];
    [uncompletionWorkBut addTarget:self action:@selector(uncompleteButClick:) forControlEvents:UIControlEventTouchUpInside];
    [uncompletionWorkBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageRight imageTitleSpace:20];
    [self.view addSubview:uncompletionWorkBut];
    
    UIButton *sortWorkBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [sortWorkBut setFrame:CGRectMake(KScreen_Width/2.0, KSafeAreaTopNaviHeight+CWidth(5), KScreen_Width/2.0, 41)];
    [sortWorkBut setTitle:@"按更新时间排序" forState:UIControlStateNormal];
    [sortWorkBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [sortWorkBut.titleLabel setFont:AppointTextFontThird];
    [sortWorkBut setBackgroundColor:[UIColor whiteColor]];
    [sortWorkBut setImage:KImage(@"KCMine-下拉") forState:UIControlStateNormal];
    [sortWorkBut addTarget:self action:@selector(sortWorkButClick:) forControlEvents:UIControlEventTouchUpInside];
    [sortWorkBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageRight imageTitleSpace:20];
    [self.view addSubview:sortWorkBut];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerClass:[KCMyWorkCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    [header setTitle:@"willrefresh" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"idle" forState:MJRefreshStateIdle];
    [header setTitle:@"pulling" forState:MJRefreshStatePulling];
    _tableview.mj_header=header;
    [_tableview.mj_header beginRefreshing];
    
    UIButton *addWorkBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [addWorkBut setFrame:CGRectMake(KScreen_Width-83, KScreen_Height-CHeight(46)-83, 83, 83)];
    [addWorkBut setAdjustsImageWhenHighlighted:NO];
    [addWorkBut setImage:KImage(@"KCMine-添加") forState:UIControlStateNormal];
    [addWorkBut addTarget:self action:@selector(addWorkButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:addWorkBut aboveSubview:_tableview];
    
    
}
#pragma mark - network

#pragma mark - events
/*
 * 刷新数据
 */
-(void)refreshHeader
{
    [super refreshHeader];
    [_tableview.mj_header endRefreshing];
}
/*
 * 完成状况转换
 */
-(void)uncompleteButClick:(UIButton *)sender
{
    XLLog(@"uncompletebut...");
}
/*
 * 任务排序
 */
-(void)sortWorkButClick:(UIButton *)sender
{
    XLLog(@"sort work");
}

/*
 * 添加任务
 */
-(void)addWorkButClick:(UIButton *)sender
{
    XLLog(@"add work ...");
}
#pragma mark - delegate
/* ****  分区  **** */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
/* ****  每一个分区的行数  **** */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
/* ****  单元格  **** */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCMyWorkCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    KCMyWorkModel *model=[self.dataSource objectAtIndex:indexPath.section];
    cell.dataModel=model;
    return cell;
}
/* ****  每一行的高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}
/* ****  分区头高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
/* ****  分区尾高度  **** */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
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

#pragma mark - lazy loading
/*
 * 懒加载表视图
 */
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+41+CWidth(10), KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-41-CWidth(10)-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    }
    return _tableview;
}

/*
 * 数据源
 */
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
        for (int i=0; i<10; i++) {
            KCMyWorkModel *model=[KCMyWorkModel new];
            model.name=@"去舞蹈室练舞";
            model.time=@"14:00-16:00【7月8日至8月28日】";
            model.publisher=@"妈妈";
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}
@end
