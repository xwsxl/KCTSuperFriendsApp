//
//  KCContactGroupListVC.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/11/30.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCContactGroupListVC.h"
#import "KCTContactsTableHeaderView.h"
#import "KCTContactsTableViewCell.h"
#import "SSChatController.h"
#define HEADERID @"customHeaderID"
@interface KCContactGroupListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) RLMResults *ClassRS;

@property (nonatomic, strong) RLMResults *NormalRS;

@end

@implementation KCContactGroupListVC


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的群聊";
    [self getData];
   
    
}
#pragma mark - setUI
- (void)setSubViews
{
    [super setSubViews];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
     [_tableview registerClass:[KCTContactsTableHeaderView class] forHeaderFooterViewReuseIdentifier:HEADERID];
    [_tableview registerClass:[KCTContactsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
}
#pragma mark - network
-(void)getData
{
    [KCNetWorkManager Get:KNSSTR(@"/familyChatController/getFamilyChatList") WithParams:@{} ForSuccess:^(NSDictionary * _Nonnull response) {
        for (NSDictionary *dic in response[@"data"]) {
             GroupRLMModel *model=[[GroupRLMModel alloc] init];
             [model mj_setKeyValues:dic];
            [KCTRealmManager addOrUpdateObject:model];
        }
        self.ClassRS=[GroupRLMModel objectsWhere:@"groupType contains '1'"];
        self.NormalRS=[GroupRLMModel objectsWhere:@"groupType contains '2'"];
       
        [self.tableview reloadData];
//        {"groupPhoto":"default\/default_group.png","groupType":2,"groupName":"072505735群1","groupOwner":"072505735","codeImgUrl":"FsGuOTY_Xk_Baphs9LVxX6oeNS0N","groupNum":"957229"},{"groupPhoto":"default\/default_group.png","groupType":2,"groupName":"072505735群2","groupOwner":"072505735","codeImgUrl":"FiFr_ESoVbwzgmwMXKYEzumyfkKj","groupNum":"159410"},{"groupPhoto":"default\/default_group.png","groupType":2,"groupName":"昵称2群3","groupOwner":"072505735","codeImgUrl":"FoeGQHoYm36Wha1xS8fCAWrL16e8","groupNum":"393074"}
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark - events

#pragma mark - delegate
/* ****  分区  **** */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.ClassRS.count>0?1:0)+(self.NormalRS.count>0?1:0);
}
/* ****  每一个分区的行数  **** */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((section==0)&&(self.ClassRS.count>0)) {
        return self.ClassRS.count;
    }else
    {
        return self.NormalRS.count;
    }
    
    
}
/* ****  单元格  **** */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCTContactsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ((indexPath.section==0)&&(self.ClassRS.count>0)) {
        GroupRLMModel *Gmodel=[self.ClassRS objectAtIndex:indexPath.row];
        ContactRLMModel *model=[[ContactRLMModel alloc] init];
        model.nickName=Gmodel.groupName;
        model.portraitUri=Gmodel.groupPhoto;
        cell.dataModel=model;
    }else
    {
        GroupRLMModel *Gmodel=[self.NormalRS objectAtIndex:indexPath.row];
        ContactRLMModel *model=[[ContactRLMModel alloc] init];
        model.nickName=Gmodel.groupName;
        model.portraitUri=Gmodel.groupPhoto;
        cell.dataModel=model;
    }
   
    
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
    return 24;
}
/* ****  分区尾高度  **** */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
/* ****  分区头视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    KCTContactsTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADERID];
    
    if (!headerView) {
        headerView = [[KCTContactsTableHeaderView alloc] initWithReuseIdentifier:HEADERID];
    }
    
    if ((section==0)&&(self.ClassRS.count>0)) {
         headerView.titleLabel.text =@"班级群";
    }else
    {
         headerView.titleLabel.text =@"超级好友群";
    }
   ;
    return headerView;

}
/* ****  分区尾视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section==0)&&(self.ClassRS.count>0)) {
        GroupRLMModel *Gmodel=[self.ClassRS objectAtIndex:indexPath.row];
        RoomRLMModel *model=[KCTRealmManager roomModelWithGroupModel:Gmodel];
        SSChatController *VC=[[SSChatController alloc] init];
        VC.model=model;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else
    {
        GroupRLMModel *Gmodel=[self.NormalRS objectAtIndex:indexPath.row];
        RoomRLMModel *model=[KCTRealmManager roomModelWithGroupModel:Gmodel];
        SSChatController *VC=[[SSChatController alloc] init];
        VC.model=model;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
#pragma mark - lazy loading
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    }
    return _tableview;
}

//-(NSMutableArray *)dataSource
//{
//    if (!_dataSource) {
//        _dataSource=[[NSMutableArray alloc] init];
//    }
//    return _dataSource;
//}
@end



















