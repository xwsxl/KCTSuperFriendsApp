//
//  KCCAddContactsFriendsVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/26.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactsLocalContactFriendsVC.h"

#import "KCTAddContactsFriendsCell.h"

#import "KCTContactsFriendsNotifyVC.h"
#define UNSIGNEDSTR @"未开通超级好友"

@interface KCTContactsLocalContactFriendsVC ()<UITableViewDelegate,UITableViewDataSource,KCCAddContactsFriendsCellDelegate>

/* ****  表视图  **** */
@property (nonatomic, strong) UITableView *tableview;
/* ****  数据源  **** */
@property (nonatomic, strong) NSMutableArray *dataSource;
/* ****  已注册  **** */
@property (nonatomic, strong) NSMutableArray *rigistDataArr;
/* ****  未注册  **** */
@property (nonatomic, strong) NSMutableArray *unRigistDataArr;

@end

@implementation KCTContactsLocalContactFriendsVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
/*
 * 父类的方法 布局子视图
 */
-(void)setSubViews
{
    [super setSubViews];
    
    [self setTitle:@"通讯录朋友"];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.estimatedSectionHeaderHeight=0.01;
    [_tableview registerClass:[KCTAddContactsFriendsCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
    [self getContactsData];

}
#pragma mark - network
/*
 * 获取数据 不需要网络
 */
-(void)getContactsData
{
    XLLog(@"获取联系人数据");
    __weak typeof(self) weakself = self;
    self.contactBlock = ^(NSArray * _Nonnull contactsArr) {
        
        XLLog(@"length=%lu",(unsigned long)contactsArr.count);
        [weakself.dataSource addObjectsFromArray:contactsArr];
        [weakself getDatas];
        
    };
    [self requestContactAuthorAfterSystemVersion9];
}

-(void)getDatas
{
    
    NSMutableArray *temp=[NSMutableArray new];
    for (ContactRLMModel *model in self.dataSource) {
        [temp addObject:model.phoneNum];
    }
    NSString *phoneNumArrStr=[temp componentsJoinedByString:@","];
    [KCNetWorkManager POST:KNSSTR(@"/friendController/addressList") WithParams:@{@"phoneNumList":phoneNumArrStr} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            for (NSDictionary *dic in response[@"data"]) {
                ContactRLMModel *model=[ContactRLMModel new];
                [model mj_setKeyValues:dic];
                [tempArr addObject:model];
            }
            [self dealWithAllCantacts:tempArr];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark - reuse
/*
 * 根据已注册的账户 重新 处理数据源、
 */
-(void)dealWithAllCantacts:(NSArray *)registArr
{
    NSMutableArray *temp=[NSMutableArray new];
    [self.rigistDataArr removeAllObjects];
    [self.unRigistDataArr removeAllObjects];
    for (int i=0; i<self.dataSource.count; i++) {
        ContactRLMModel *model=self.dataSource[i];
        for (int j=0; j<registArr.count; j++) {
            ContactRLMModel *model2=registArr[j];
            if ([model.phoneNum isEqualToString:model2.phoneNum]) {
                [temp addObject:model];
            }
        }
    }
    [self.dataSource removeObjectsInArray:temp];
    [self.rigistDataArr addObjectsFromArray:registArr];
    [self.unRigistDataArr addObjectsFromArray:self.dataSource];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
}

#pragma mark - events
/*
 * 获取分区数
 */
-(NSInteger)getSectionCount
{
    NSInteger sectionCount=0;
    sectionCount=self.rigistDataArr.count>0?(sectionCount+1):sectionCount;
    sectionCount=self.unRigistDataArr.count>0?(sectionCount+1):sectionCount;
    return sectionCount;
}

#pragma mark - delegate
/* ****  分区  **** */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionCount=0;
    sectionCount=self.rigistDataArr.count>0?(sectionCount+1):sectionCount;
    sectionCount=self.unRigistDataArr.count>0?(sectionCount+1):sectionCount;
    return sectionCount;
}
/* ****  每一个分区的行数  **** */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /* ****  只有是第一个分区并且注册数组长度大于0 才是注册分区  **** */
    if ((section==0)&&(self.rigistDataArr.count>0))
    {
       return self.rigistDataArr.count;
    }else
    {
        return self.unRigistDataArr.count;
    }
}
/* ****  单元格  **** */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KCTAddContactsFriendsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     /* ****  只有是第一个分区并且注册数组长度大于0 才是注册分区  **** */
    if ((indexPath.section==0)&&(self.rigistDataArr.count>0))
    {
        cell.cellType=@"0";
        cell.dataModel=[self.rigistDataArr objectAtIndex:indexPath.row];
    }else
    {
        cell.cellType=@"1";
        cell.dataModel=[self.unRigistDataArr objectAtIndex:indexPath.row];
    }
    cell.delegate=self;
    return cell;
}
/* ****  每一行的高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
/* ****  分区头高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /* ****  只有是第一个分区并且注册数组长度大于0 才是注册分区 其他都是未注册分区 **** */
    if ((section==0)&&(self.rigistDataArr.count>0))
    {
        return 0.01;
    }else
    {
        return 25;
    }
    
}
/* ****  分区尾高度  **** */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ((section==0)&&(self.rigistDataArr.count>0))
    {
        return @"";
    }else
    {
        return UNSIGNEDSTR;
    }
}
/* ****  分区尾视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

#pragma mark - cell deleagte

-(void)attensionButClick:(ContactRLMModel *)model
{
    if ([self.rigistDataArr containsObject:model]) {
        /* ****  添加  **** */
//        KCTContactsFriendsNotifyVC *VC=[[KCTContactsFriendsNotifyVC alloc] init];
//        VC.dataModel=model;
//        [self.navigationController pushViewController:VC animated:YES];
        [KCNetWorkManager POST:KNSSTR(@"/friendController/applyFriend") WithParams:@{@"toAccount":model.account} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                [MBProgressHUD showMessageWithImageName:@"KCContact-添加成功" message:@"已发送添加邀请"];
            }else
            {
                [MBProgressHUD showMessage:response[@"msg"]];
            }
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
    }else
    {
        /* ****  邀请  **** */
        XLLog(@"发送邀请信息");
    }
  //  NSInteger
}

#pragma mark - lazy loading
/*
 * 表视图
 */
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    }
    return _tableview;
}
/*
 * 数据源
 */
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)rigistDataArr
{
    if (!_rigistDataArr) {
        _rigistDataArr=[NSMutableArray new];
    }
    return _rigistDataArr;
}

-(NSMutableArray *)unRigistDataArr
{
    if (!_unRigistDataArr) {
        _unRigistDataArr=[NSMutableArray new];
    }
    return _unRigistDataArr;
}
@end
