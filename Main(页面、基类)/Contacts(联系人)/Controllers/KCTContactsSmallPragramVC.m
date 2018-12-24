//
//  KCTContactsSmallPragramVC.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/11/30.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactsSmallPragramVC.h"
#import "KCTContactsTableViewCell.h"
#import "SSChatController.h"
#import "KCTAlertView.h"
@interface KCTContactsSmallPragramVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation KCTContactsSmallPragramVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
-(void)setSubViews
{
    self.title=@"小程序好友";
    
    [super setSubViews];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
     [_tableview registerClass:[KCTContactsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
}

#pragma mark - network
-(void)getData
{
    [KCNetWorkManager POST:KNSSTR(@"/friendController/getFriendList") WithParams:@{@"type":@"2"} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            NSArray *tempArray=response[@"data"];
            for (NSDictionary *dic in tempArray) {
                ContactRLMModel *model=[ContactRLMModel new];
                [model mj_setKeyValues:dic];
                [self.dataSource addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [KCTRealmManager addOrUpdateObjects:self.dataSource];
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
    KCTContactsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.dataModel=self.dataSource[indexPath.row];
    return cell;
}
/* ****  每一行的高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
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
    XLLog(@"点击了单元格");
    ContactRLMModel *model=self.dataSource[indexPath.row];
    KCTAlertView *alertView=[[KCTAlertView alloc] initCantactsAlertViewWithModel:model];
    alertView.aliasBlock = ^{
        XLLog(@"备注");
    };
    alertView.messageBlock = ^{
        RoomRLMModel *Rmodel= [KCTRealmManager roomModelWithContactModel:model];
        SSChatController *VC=[[SSChatController alloc] init];
        VC.model=Rmodel;
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:YES];
        XLLog(@"消息");
    };
    alertView.readOnBlock = ^{
        XLLog(@"读播");
    };
    alertView.videoBlock  = ^{
        XLLog(@"视频");
    };
    [alertView showRSAlertView];
    
}

#pragma mark - lazy loading

-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    }
    return _tableview;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
