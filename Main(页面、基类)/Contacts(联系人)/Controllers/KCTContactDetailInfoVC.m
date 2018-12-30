//
//  KCTContactDetailInfoVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactDetailInfoVC.h"

#import "KCTContactsFriendsNotifyVC.h"

/* ****  cell  **** */
#import "KCTContactsDetailInfoCell.h"
#import "KCTContactDetailRecordCell.h"
#import "KCTContactsMoreCell.h"
#import "SSChatController.h"

@interface KCTContactDetailInfoVC ()<UITableViewDelegate,UITableViewDataSource,KCContactsDetailTableFooterDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) ContactRLMModel *dataModel;

@end

@implementation KCTContactDetailInfoVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - setUI
/*
 * <#description#>
 */
-(void)setSubViews
{
    [super setSubViews];
    self.title=@"详细资料";
    self.tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    [self.tableview registerClass:[KCTContactsMoreCell class] forCellReuseIdentifier:@"more"];
    [self.tableview registerClass:[KCTContactsDetailInfoCell class] forCellReuseIdentifier:@"info"];
    [self.tableview registerClass:[KCTContactDetailRecordCell class] forCellReuseIdentifier:@"record"];
    [self.tableview registerClass:[KCTContactsDetailTableFooter class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:_tableview];
    
}
#pragma mark - network

/*
 * 获取好友详情
 */
-(void)getDetailInfo
{


 
    [self getFriendsDetailInfo];
}
/*
 * 查看好友详情
 */
-(void)getFriendsDetailInfo
{
    NSDictionary *dic;
    if (!_account) {
        dic=@{@"type":@2,@"friendAccount":_code};
    }
    if (!_code) {
        dic=@{@"friendAccount":_account};
    }
    WeakSelf
    [KCNetWorkManager POST:KNSSTR(@"/friendController/friendInfo") WithParams:dic ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            NSDictionary *dataDic=response[@"data"];
            if (![dataDic[@"friendRelation"] isEqual:[NSNull new]]) {
                //    typedef enum{
                //        KCContactsDetailTypeNormal=0,//默认模式详情
                //        KCContactsDetailTypeAddFriend,//不是好友的时候可以添加好友
                //        KCContactsDetailTypeControl//收到别人好友添加申请
                //    } KCContactsDetailType;
                if ([dataDic[@"friendRelation"] integerValue]==1) {
                    weakSelf.type=0;
                }else if ([dataDic[@"friendRelation"] integerValue]==2)
                {
                    weakSelf.type=1;
                }else if ([dataDic[@"friendRelation"] integerValue]==3)
                {
                    weakSelf.type=1;
                }
            }else
            {
                weakSelf.type=1;
            }
            if (![dataDic[@"applyNum"] isEqual:[NSNull new]]&&[[dataDic allKeys] containsObject:@"applyNum"]) {
                if ([dataDic[@"applyNum"] isEqualToString:[KCUserDefaultManager getAccount]]) {
                    
                }else
                {
                    weakSelf.type=2;
                }
            }
            ContactRLMModel *model=[[ContactRLMModel alloc] init];
            [model mj_setKeyValues:response[@"data"]];
            
            self.dataModel=model;
            [self.tableview reloadData];
        }
        
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}

/*
 * 处理好友申请请求 必须 applyStatus 2：同意  3：拉黑
 */
-(void)dealWithApplyWithApplyStatus:(NSString *)applyStatus
{
    [KCNetWorkManager POST:KNSSTR(@"/friendController/disposeApply") WithParams:@{@"account":_dataModel.account,@"applyStatus":[NSNumber numberWithInteger:[applyStatus integerValue]]} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        [MBProgressHUD showMessage:response[@"msg"]];
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark - events

#pragma mark - delegate
/* ****  分区  **** */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
/* ****  每一个分区的行数  **** */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
/* ****  单元格  **** */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        KCTContactsDetailInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"info" forIndexPath:indexPath];
        cell.dataModel=_dataModel;
        return cell;
    }else if (indexPath.section==1)
    {
        KCTContactsMoreCell *cell=[tableView dequeueReusableCellWithIdentifier:@"more" forIndexPath:indexPath];
        cell.dataModel=_dataModel;
        return cell;
    }else
    {
        KCTContactDetailRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"record" forIndexPath:indexPath];
        cell.dataModel=_dataModel;
        return cell;
    }
    
}
/* ****  每一行的高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 105;
    }else if(indexPath.section==1)
    {
        return 56;
    }else
    {
       return 94;
    }
}
/* ****  分区头高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
/* ****  分区尾高度  **** */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        
        return (_type==1)?110:175;
    }else
    {
        return 0.01;
    }
}
/* ****  分区头视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
/* ****  分区尾视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        KCTContactsDetailTableFooter *footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
        footer.delegate=self;
        footer.type=_type;
        return footer;
    }else
    {
      return [[UIView alloc] init];
    }
}

#pragma mark - footer delegate
/*
 * 添加好友、发送消息
 */
-(void)addFriendsButClick:(UIButton *)sender
{
    XLLog(@"添加好友、发送消息");
//    typedef enum{
//        KCContactsDetailTypeNormal=0,//默认模式详情
//        KCContactsDetailTypeAddFriend,//不是好友的时候可以添加好友
//        KCContactsDetailTypeControl//收到别人好友添加申请
//    } KCContactsDetailType;
    if (_type==0) {
        /* ****  默认发消息页面  **** */
         SSChatController *vc=[[SSChatController alloc] init];
        RoomRLMModel *model=[[RoomRLMModel alloc] init];
        model.type=0;
        model.contact=self.dataModel;
        /* ****  聊天房间号  md5(my account and @"_" and you account) **** */
        model.roomNo=[[NSString stringWithFormat:@"%@_%@",[KCUserDefaultManager getAccount],self.dataModel.account] md5];
        vc.model=model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_type==1)
    {
        /* ****  添加好友  **** */
//        KCTContactsFriendsNotifyVC *VC= [[KCTContactsFriendsNotifyVC alloc] init];
//        VC.dataModel=self.dataModel;
//        [self.navigationController pushViewController:VC animated:YES];
        
        [KCNetWorkManager POST:KNSSTR(@"/friendController/applyFriend") WithParams:@{@"toAccount":_dataModel.account} ForSuccess:^(NSDictionary * _Nonnull response) {
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
        /* ****  同意添加  **** */
        [self dealWithApplyWithApplyStatus:@"2"];
    }
    
}

/*
 * 加入黑名单、视频通话
 */
-(void)addBlackBoardButClick:(UIButton *)sender
{
    XLLog(@"加入黑名单、视频通话");
    if (_type==0) {
        /* ****  默认发消息页面  **** */
        SSChatController *VC=[[SSChatController alloc] init];
        
        [self.navigationController pushViewController:VC animated:YES];
    }else if (_type==1)
    {
        /* ****  1的时候没有这个按钮、、出错了进到这里就是出错了  **** */
        XLLog(@"出错了、、没有这个按钮");
    }else
    {
        /* ****  同意添加  **** */
        [self dealWithApplyWithApplyStatus:@"3"];
    }
}
#pragma mark - lazy loading

-(void)setAccount:(NSString *)account
{
    _account=account;
     [self getDetailInfo];
}

-(void)setCode:(NSString *)code
{
    _code=code;
    [self getDetailInfo];
}

@end
