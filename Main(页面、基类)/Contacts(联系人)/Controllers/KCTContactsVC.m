//
//  KCContactsVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/17.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContactsVC.h"
#import "KCTContacsAddFriendsVC.h"
#import "KCTContactsNewFriendsListVC.h"
#import "KCTSetAliasNameVC.h"
#import "KCTContactsSmallPragramVC.h"
#import "KCContactGroupListVC.h"
#import "SSChatController.h"

#import "PYSearch.h"//搜索页面
#import "KCTContactDetailInfoVC.h"

#import "KCTAlertView.h"

#import "KCTContactsMoreCell.h"
#import "KCTContactsTableViewCell.h"

#import "KCTContactsTableHeaderView.h"
#import "KCTSearchHeaderView.h"
#import "KCTRealmManager.h"

#define HEADERID @"customHeaderID"

@interface KCTContactsVC ()<UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDelegate>

/* ****  数据源  **** */
@property (nonatomic, strong) NSMutableArray *dataSource;
/* ****  表视图  **** */
@property (nonatomic, strong) UITableView *tableview;
/* ****  分区头数据源  **** */
@property (nonatomic, strong) NSMutableArray *sectionTitleArr;
/* ****  数据源  **** */
@property (nonatomic, strong) NSMutableArray *anArrayOfArrays;
/* ****  第一个分区的数据  **** */
@property (nonatomic, strong) NSMutableArray *firstSectionDatasource;

@end

@implementation KCTContactsVC

#pragma mark - life cycle
/*
 * 控制器生命周期
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [KNotificationCenter addObserver:self selector:@selector(refreshHeader) name:KCContactsChangeNoti object:nil];
}

/*
 * 调用父类的方法设置UI界面
 */
-(void)setSubViews
{
    [super setSubViews];

    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc] init];
    [leftBar setTitle:@"联系人"];
    [leftBar setTitleTextAttributes:@{NSForegroundColorAttributeName:APPOINTCOLORSecond,NSFontAttributeName:AppointTextFontMain} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=leftBar;

    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithImage:[KImage(@"KCContact-AddContacts") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addFriendsAndMoreButClick:)];
    rightBar.tag=100;
    [self.navigationItem setRightBarButtonItem:rightBar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"联系人" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    KCTSearchHeaderView *searchView=[[KCTSearchHeaderView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, 55)];
    WeakSelf;
    searchView.searchButClick = ^{
        XLLog(@"处理点击事件");
        [weakSelf searchBarButtonClick:nil];
    };
    [self.view addSubview:searchView];
    XLLog(@"contacts=%@",self.dataSource);
    self.tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+55, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-55-KSafeAreaBottomHeight-49) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview registerClass:[KCTContactsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableview registerClass:[KCTContactsMoreCell class] forCellReuseIdentifier:@"morecell"];
    [self.view addSubview:_tableview];
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    [header setTitle:@"willrefresh" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"idle" forState:MJRefreshStateIdle];
    [header setTitle:@"pulling" forState:MJRefreshStatePulling];
    _tableview.mj_header=header;
    [_tableview.mj_header beginRefreshing];
    
}
#pragma mark - network
/*
 * 获取数据
 */
-(void)getdatas
{
    
    [KCNetWorkManager POST:KNSSTR(@"/friendController/getFriendList") WithParams:@{@"type":@"1"} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            NSArray *tempArray=response[@"data"];
            for (NSDictionary *dic in tempArray) {
                ContactRLMModel *model=[ContactRLMModel new];
                [model mj_setKeyValues:dic];
                [self.dataSource addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [KCTRealmManager addOrUpdateObjects:self.dataSource];
                [self method2];
               // [self.tableview reloadData];
                
            });
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark - events
/*
 * 添加好友
 */
-(void)addFriendsAndMoreButClick:(UIButton *)sender
{
    XLLog(@"add friends button click...");
    KCTContacsAddFriendsVC *VC=[[KCTContacsAddFriendsVC alloc] init];
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
}
/*
 * 搜索框点击
 */
-(void)searchBarButtonClick:(UIButton *)sender
{
    XLLog(@"searchButCLick");
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"搜索用户名和手机名" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        /* ****  回调  **** */
        if (searchText.length>0) {
            [KCNetWorkManager POST:KNSSTR(@"/userController/beforeLogin") WithParams:@{@"account":searchText} ForSuccess:^(NSDictionary * _Nonnull response) {
                if ([response[@"code"] integerValue]==200) {
                    ContactRLMModel *model=[ContactRLMModel new];
                    [model mj_setKeyValues:response[@"data"]];
                    KCTContactDetailInfoVC *VC=[[KCTContactDetailInfoVC alloc] init];
                    VC.type=1;
                    VC.account=model.account;
                    VC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            } AndFaild:^(NSError * _Nonnull error) {
                
            }];
        }
        
    }];
    // 3. Set style for popular search and search history
    searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    searchViewController.searchBarBackgroundColor=RGBHex(0xf7f7f9);
    // 4. Set delegate
    searchViewController.delegate = self;
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    searchViewController.hidesBottomBarWhenPushed=YES;
    //    // Push search view controller
    searchViewController.jz_navigationBarHidden=NO;
    [self.navigationController pushViewController:searchViewController animated:YES];
    
}

/*
 * refresh data
 */
-(void)refreshHeader
{
    [super refreshHeader];
    [self.dataSource removeAllObjects];
    [self getdatas];
    [self.tableview.mj_header endRefreshing];
    
}

#pragma mark -reuse

/* ****  排序  **** */
- (void)method2 {
    
    @autoreleasepool {
        
        self.anArrayOfArrays = [NSMutableArray array];
        _sectionTitleArr=nil;
        for (int i = 0; i < self.sectionTitleArr.count; i++) {
            NSMutableArray *tmpMArray = [NSMutableArray array];
            [self.anArrayOfArrays addObject:tmpMArray];
        }
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        for (ContactRLMModel *model in self.dataSource) {
            if (model.account) {
                NSInteger section = [collation sectionForObject:model collationStringSelector:@selector(aliasName)];
                [(NSMutableArray *)self.anArrayOfArrays[section] addObject:model];
            }
        }
        
        for (NSMutableArray *arr in self.anArrayOfArrays) {
            NSArray *sortArr = [collation sortedArrayFromArray:arr collationStringSelector:@selector(aliasName)];
            [arr removeAllObjects];
            [arr addObjectsFromArray:sortArr];
        }
        
        //去掉无数据的数组
        //同步 sectionTitleArr
        NSMutableArray *tmpArrA = [NSMutableArray array];
        NSMutableArray *tmpArrB = [NSMutableArray array];
        for (int i = 0; i < self.anArrayOfArrays.count; i++) {
            
            if (((NSMutableArray *)self.anArrayOfArrays[i]).count == 0) {
                [tmpArrA addObject:self.sectionTitleArr[i]];
                [tmpArrB addObject:self.anArrayOfArrays[i]];
            }
            
        }
        
        for (int i = 0; i < tmpArrA.count; i++) {
            [self.sectionTitleArr removeObject:tmpArrA[i]];
            [self.anArrayOfArrays removeObject:tmpArrB[i]];
        }
        
        
    }
    [self.tableview reloadData];
}


#pragma mark - delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.anArrayOfArrays.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.firstSectionDatasource.count;
    }else
    {
       return ((NSArray *)self.anArrayOfArrays[section-1]).count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        KCTContactsMoreCell *cell=[tableView dequeueReusableCellWithIdentifier:@"morecell" forIndexPath:indexPath];
        cell.dataModel=self.firstSectionDatasource[indexPath.row];
        return cell;
    }else
    {
        KCTContactsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.dataModel=self.anArrayOfArrays[indexPath.section-1][indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 20;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return NO;
    }else
    {
        return YES;
    }
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        ContactRLMModel *model=self.anArrayOfArrays[indexPath.section-1][indexPath.row];
        
        [KCNetWorkManager POST:KNSSTR(@"/friendController/updateFriend") WithParams:@{@"friendAccount":model.account,@"relationStatus":@3} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {

            }
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
        [self.anArrayOfArrays[indexPath.section-1] removeObject:model];
        [KCTRealmManager deleteObject:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        XLLog(@"点击了删除");
        
    }];
    action0.backgroundColor=RGBHex(0xFF6464);
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"备注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        XLLog(@"点击了备注");
        ContactRLMModel *model=self.anArrayOfArrays[indexPath.section-1][indexPath.row];
        KCTSetAliasNameVC *VC=[[KCTSetAliasNameVC alloc] init];
        VC.model=model;
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:YES];
      
    }];
   action1.backgroundColor=RGBHex(0x0198F8);
    return @[action0, action1];
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==1) {
    KCTContactsTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADERID];
    
    if (!headerView) {
        headerView = [[KCTContactsTableHeaderView alloc] initWithReuseIdentifier:HEADERID];
    }
    
    headerView.titleLabel.text = @"☆我的超级好友";
    return headerView;
    }else {
        return [[UIView alloc] init];
    }
}

//返回索引数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitleArr;
}
//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+1]
                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return self.sectionTitleArr.count;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            XLLog(@"新朋友");
            KCTContactsNewFriendsListVC *VC=[[KCTContactsNewFriendsListVC alloc] init];
            VC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:VC animated:YES];
        }else if(indexPath.row==1)
        {
            XLLog(@"小程序好友");
            KCTContactsSmallPragramVC *VC=[[KCTContactsSmallPragramVC alloc] init];
            VC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:VC animated:YES];
        }else
        {
            XLLog(@"群聊");
            KCContactGroupListVC *VC=[[KCContactGroupListVC alloc] init];
            VC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else
    {
        ContactRLMModel *model=self.anArrayOfArrays[indexPath.section-1][indexPath.row];
        KCTAlertView *alertView=[[KCTAlertView alloc] initCantactsAlertViewWithModel:model];
        alertView.aliasBlock = ^{
            XLLog(@"备注");
        };
        alertView.messageBlock = ^{
            XLLog(@"消息");
         
            RoomRLMModel *Rmodel= [KCTRealmManager roomModelWithContactModel:model];
            SSChatController *VC=[[SSChatController alloc] init];
            VC.model=Rmodel;
            VC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:VC animated:YES];
            
        };
        alertView.readOnBlock = ^{
            XLLog(@"读播");
        };
        alertView.videoBlock  = ^{
            XLLog(@"视频");
        };
        [alertView showRSAlertView];
        
//            KCTContactDetailInfoVC *VC=[[KCTContactDetailInfoVC alloc] init];
//            VC.type=0;
//            ContactRLMModel *model=self.anArrayOfArrays[indexPath.section-1][indexPath.row];
//            VC.account=model.account;
//            VC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:VC animated:YES];
    }
    
}


#pragma mark - lazy loading
/*
 * 懒加载数据源
 */
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableArray *)sectionTitleArr {
    
    if (!_sectionTitleArr) {
        _sectionTitleArr = [NSMutableArray arrayWithArray:[UILocalizedIndexedCollation currentCollation].sectionTitles];
    }
    
    return _sectionTitleArr;
}

- (NSMutableArray *)anArrayOfArrays {
    
    if (!_anArrayOfArrays) {
        _anArrayOfArrays = [NSMutableArray array];
    }
    
    return _anArrayOfArrays;
}

-(NSMutableArray *)firstSectionDatasource{
    
    if (!_firstSectionDatasource){
        _firstSectionDatasource=[NSMutableArray new];
        NSArray *arr=@[@"新朋友",@"小程序好友",@"我的群聊"];
        NSArray *photoNameArr=@[@"KCContact-NewFriends",@"KCContact-smallPragram",@"KCContact-MyGroup"];
        for (int i=0; i<arr.count; i++) {
            ContactRLMModel *model=[[ContactRLMModel alloc] init];
            model.account=arr[i];
            model.portraitUri=photoNameArr[i];
            [_firstSectionDatasource addObject:model];
        }
    }
    return _firstSectionDatasource;
    
}

@end
