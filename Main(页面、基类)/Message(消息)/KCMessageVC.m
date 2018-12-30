//
//  KCMessageVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/17.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMessageVC.h"
#import "KCLoginBDPhoneVC.h"
#import "SWQRCodeViewController.h"
#import "SSChatController.h"
#import "KCTMessageCreatGroupVC.h"
#import "KCTSearchVC.h"

#import "KCMessageTableViewCell.h"
#import "KCMessageAddSelectionView.h"

#import "KCTRealmManager.h"
#import "KCTSearchHeaderView.h"
#import "UIImage+GIF.h"
#import <GTSDK/GeTuiSdk.h>
//#import "SWQRCodeViewController.h"
@interface KCMessageVC ()<UITableViewDelegate,UITableViewDataSource,KCMessageAddSelectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    BOOL isShowAddFriends;
}

/* ****  <#description#>  **** */
@property (nonatomic, strong) UITableView *tableview;
/* ****  <#description#>  **** */
@property (nonatomic, strong) NSMutableArray *dataSource;
/* ****  <#description#>  **** */
@property (nonatomic, strong) KCMessageAddSelectionView *addSelectionView;
/* ****  <#description#>  **** */
@property (nonatomic, strong) UIControl *backControl;
/* ****  <#description#>  **** */
@property (nonatomic, strong) KCTSearchHeaderView *searchView;
/* ****  <#description#>  **** */
@property (nonatomic, strong) RLMNotificationToken *RLMNotificationToken;
@end
@implementation KCMessageVC

#pragma mark - life cycle
/*
 * 加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    
    self.dataSource = (NSMutableArray *)[[RoomRLMModel allObjects] sortedResultsUsingKeyPath:@"timestamp" ascending:NO];
    self.tableview  = [[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+55, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-55-KSafeAreaBottomHeight-49) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.emptyDataSetSource=self;
    _tableview.emptyDataSetDelegate=self;
    [_tableview registerClass:[KCMessageTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
    if ([KCUserDefaultManager getPhoneNum].length==0) {
        KCLoginBDPhoneVC *VC=[[KCLoginBDPhoneVC alloc] init];
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
    NSInteger count=0;
    for (RoomRLMModel *model in self.dataSource) {
        count+=model.unreadNum;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    WeakSelf
    self.RLMNotificationToken= [[RoomRLMModel allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        XLLog(@"收到通知了");
        [weakSelf reloadData];
        
    }];
    XLLog(@"getuiSdkstatus=%d",[GeTuiSdk status]);
    if ([GeTuiSdk status] == SdkStatusStoped) {
        NSLog(@"\n\n>>>[GeTui]:%@\n\n", @"启动APP");
    } else if ([GeTuiSdk status] == SdkStatusStarted) {
       // [GeTuiSdk destroy];
        NSLog(@"\n\n>>>[GeTui]:%@\n\n", @"停止APP");
    }
}
-(void)reloadData
{
    [self.tableview reloadData];
}
/*
 * 重写父类的方法加载子视图
 */
-(void)setSubViews
{
    
    [super setSubViews];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc] init];
    [leftBar setTitle:@"超级好友"];
    [leftBar setTitleTextAttributes:@{NSForegroundColorAttributeName:APPOINTCOLORSecond,NSFontAttributeName:AppointTextFontMain} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=leftBar;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"超级好友" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] init];
    UIButton *rightIV=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightIV setFrame:CGRectMake(0, 0, 25, 25)];
    [rightIV setImage:KImage(@"KCMessage-添加") forState:UIControlStateNormal];
    [rightBar setCustomView:rightIV];
    [rightIV addTarget:self action:@selector(addFriendsAndMoreButClick:) forControlEvents:UIControlEventTouchUpInside];
    rightIV.tag=100;
    
    [self.navigationItem setRightBarButtonItem:rightBar];
    self.searchView=[[KCTSearchHeaderView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, 55)];
    WeakSelf;
    self.searchView.searchButClick = ^{
        XLLog(@"处理点击事件");
        
        [weakSelf searchBarButtonClick:nil];
    };
    [self.view addSubview:self.searchView];
}

#pragma mark - events
/*
 * 顶部右侧按钮点击、添加好友创建群聊等等
 */
-(void)addFriendsAndMoreButClick:(UIBarButtonItem *)sender
{
    XLLog(@"添加好友");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->isShowAddFriends) {
            [self openTheAddSelectionView];
        }else
        {
            [self closeTheAddSelectionView];
        }
    });
}
/*
 * 搜索框点击
 */
-(void)searchBarButtonClick:(UIButton *)sender
{
    XLLog(@"searchButCLick");
    KCTSearchVC *VC=[[KCTSearchVC alloc] init];
    WeakSelf;
    VC.searchType=2;
    VC.dataSource=(NSArray *)[MessageRLMModel objectsWhere:@"msgType = 1001"];
    VC.selectPopElement = ^(id model) {
        SSChatController *vc = [[SSChatController alloc] init];
        vc.model=model;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
    
}
/*
 * refresh data
 */
-(void)refreshHeader
{
    [super refreshHeader];
    //  [self.dataSource removeAllObjects];
    // [self addData];
    [self.tableview.mj_header endRefreshing];
}
/*
 * load more data
 */
-(void)loadMoreData
{
    [super loadMoreData];
   // [self addData];
    [self.tableview.mj_footer endRefreshing];
}
#pragma mark - reuse


/*
 * 判断是打开添加好友视图
 */
-(void)openTheAddSelectionView
{
    XLLog(@"open");
    UIButton *more=[self.view viewWithTag:100];
    isShowAddFriends=YES;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *1.25];
    animation.duration = 0.5;
    animation.autoreverses = NO;
    animation.removedOnCompletion=NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [more.layer addAnimation:animation forKey:nil];
    [UIView animateWithDuration:0.5 animations:^{
        [self.addSelectionView setFrame:CGRectMake(KScreen_Width-15-154, 76+KSafeTopHeight, 154, 237)];
        [self.backControl setAlpha:0.5];
        [self.tabBarController.tabBar setHidden:YES];
    }];
}
/*
 * 判断是关闭好友视图
 */
-(void)closeTheAddSelectionView
{
    XLLog(@"close");
    UIButton *more=[self.view viewWithTag:100];
    isShowAddFriends=NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:M_PI *1.25];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.duration = 0.5;
    animation.autoreverses = NO;
    animation.removedOnCompletion=NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [more.layer addAnimation:animation forKey:nil];
    [UIView animateWithDuration:0.5 animations:^{
        [self.addSelectionView setFrame:CGRectMake(KScreen_Width-15, 76+KSafeTopHeight, 0, 0)];
        [self.backControl setAlpha:0];
        [self.tabBarController.tabBar setHidden:NO];
    }];
}
#pragma mark - tableviewDelegate & tabeviewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.dataModel=[self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47+12+12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
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
    SSChatController *vc = [[SSChatController alloc] init];
    RoomRLMModel *model = self.dataSource[indexPath.row];
    vc.model=model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//2
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
//3
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//4
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    //删除数据，和删除动画
    [KCTRealmManager deleteRoomWithModel:[self.dataSource objectAtIndex:indexPath.row]];
}
#pragma mark - DZNEmptyDataSource
/*
 * 无消息代理 
 */
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return KImage(@"没有消息");
}

#pragma mark - KCMessageAddSelectsionViewDelegate
/*
 * 创建群聊
 */
-(void)creatGroupChatButClick:(UIButton *)sender
{
    
    XLLog(@"creat group chat");
    [self closeTheAddSelectionView];
    KCTMessageCreatGroupVC *VC=[[KCTMessageCreatGroupVC alloc] init];
    VC.dataSource=(NSMutableArray *)[ContactRLMModel objectsWhere:@"friendType == 0"];
    WeakSelf;
    VC.sureSelectBlock = ^(NSArray<ContactRLMModel *> * _Nonnull contactsArr) {
        XLLog(@"%@",contactsArr);
        [weakSelf.navigationController popViewControllerAnimated:NO];
        [self creatGroupChat:contactsArr];
    };
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];

}
/*
 * 添加好友
 */
-(void)addFriendsButClick:(UIButton *)sender
{
    XLLog(@"add friend");
    [self closeTheAddSelectionView];
}
/*
 * 扫一扫
 */
-(void)scanQRCodeButClick:(UIButton *)sender
{
    XLLog(@"scan QRCode");
    [self closeTheAddSelectionView];
    SWQRCodeViewController *VC=[[SWQRCodeViewController alloc] init];
    VC.scanOptions=KCScanOptionsHelpLogin;
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
}


/* ****  创建群聊  **** */
-(void)creatGroupChat:(NSArray <ContactRLMModel *>*)contactsArr
{
    NSMutableArray *tempArrM=[NSMutableArray new];
    for (ContactRLMModel *model in contactsArr) {
        [tempArrM addObject:model.account];
    }
//  WeakSelf;
    NSDictionary *params=@{@"groupType":@2,@"members":[tempArrM componentsJoinedByString:@","]};
    [KCNetWorkManager POST:KNSSTR(@"/chatGroupController/createChatGroup") WithParams:params ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
//            "groupPhoto":"default\/default_group.png","members":[{"portraitUri":"tmp_d7b8c18d3584862a9b74c4bf8f79eef2.jpg","nickName":"第二个账号","account":"072505735","aliasName":"第二个账号","friendType":1},{"portraitUri":"default\/default_boy.png","nickName":"昵称1","account":"172457985","aliasName":"昵称1","friendType":0}],"groupType":2,"groupIntro":"","groupName":"第二个账号群4","codeImgUrl":"FrTSqYFHf_g5CA88vNxVWgrbOL-7","groupNum":"796079","groupOwner":"072505735"}
            GroupRLMModel *model=[[GroupRLMModel alloc] init];
            [model mj_setKeyValues:response[@"data"]];
            [KCTRealmManager addOrUpdateObject:model];
            RoomRLMModel *roomModel=[KCTRealmManager roomModelWithGroupModel:model];
            SSChatController *VC=[[SSChatController alloc] init];
            VC.model=roomModel;
            VC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark - lazy loading
/*
 * 数据源
 */
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource=[NSMutableArray new];
        
    }
    return _dataSource;
}

/*
 * 选择框
 */
-(KCMessageAddSelectionView *)addSelectionView
{
    if (!_addSelectionView) {
        _addSelectionView=[[KCMessageAddSelectionView alloc] initWithFrame:CGRectMake(KScreen_Width-15, 76+KSafeTopHeight, 0, 0)];
        _addSelectionView.delegate=self;
        [self.tabBarController.view insertSubview:_addSelectionView atIndex:200];
    }
    return _addSelectionView;
      
}

/*
 * 背景
 */
-(UIControl *)backControl
{
    if (!_backControl) {
        _backControl=[[UIControl alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KScreen_Height)];
        [_backControl setBackgroundColor:RGB(0, 0, 0)];
        [_backControl setAlpha:0];
        [_backControl addTarget:self action:@selector(closeTheAddSelectionView) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarController.view insertSubview:_backControl belowSubview:_addSelectionView];
    }
    return _backControl;
    
}



@end
