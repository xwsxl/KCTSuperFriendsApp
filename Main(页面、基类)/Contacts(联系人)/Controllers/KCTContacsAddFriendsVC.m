//
//  KCContacsAddFriendsVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/25.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTContacsAddFriendsVC.h"
#import "KCTContactsLocalContactFriendsVC.h"
#import "SWQRCodeViewController.h"
#import "KCTContactDetailInfoVC.h"
#import "KCRadarAddFriendsVC.h"
#import "KCMyQRCodeVC.h"
#import "PYSearch.h"

@interface KCTContacsAddFriendsVC ()<PYSearchViewControllerDelegate>

@end

@implementation KCTContacsAddFriendsVC


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
/*
 * 调用父类方法布局
 */
-(void)setSubViews
{
    [super setSubViews];
    self.title=@"添加好友";
    [self.view setBackgroundColor:MAINSEPRATELINECOLOR];
    
    UIView *searchView=[[UIView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, 55)];
    [searchView setBackgroundColor:RGB(244, 244, 244)];
    [self.view addSubview:searchView];
    
    UIButton *searchBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBackButton.frame=CGRectMake(10, 10, KScreen_Width-20, 35);
    searchBackButton.layer.cornerRadius=17.5;
    [searchBackButton.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [searchBackButton addTarget:self action:@selector(searchBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBackButton];
    
    UIButton *searchButton=[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame=CGRectMake(10, 0, 200, 35);
    [searchButton addTarget:self action:@selector(searchBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:KImage(@"KCMessage-搜索") forState:UIControlStateNormal];
    [searchButton setTitle:@"输入手机号/账号搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:APPOINTCOLORFifth forState:UIControlStateNormal];
    [searchButton.titleLabel setFont:AppointTextFontSecond];
    [searchBackButton addSubview:searchButton];
    
    /* ****  扫一扫加好友  **** */
    UIView *scanAddfriendsBackView=[[UIView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+55, KScreen_Width, 52)];
    [scanAddfriendsBackView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scanAddfriendsBackView];
    UIButton *scanAddBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [scanAddBut setFrame:CGRectMake(0, 0, 160, 51)];
    [scanAddBut setImage:KImage(@"KCContacts-扫一扫") forState:UIControlStateNormal];
    [scanAddBut setTitle:@"扫一扫加好友" forState:UIControlStateNormal];
    [scanAddBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [scanAddBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageLeft imageTitleSpace:10];
    [scanAddBut.titleLabel setFont:AppointTextFontSecond];
    
    [scanAddfriendsBackView addSubview:scanAddBut];
    UIButton *scanAddFriendsBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [scanAddFriendsBut setFrame:scanAddfriendsBackView.bounds];
    [scanAddFriendsBut addTarget:self action:@selector(scanAddFriendButClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanAddfriendsBackView  insertSubview:scanAddFriendsBut aboveSubview:scanAddBut];

    /* ****  分割线  **** */
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(50, KSafeAreaTopNaviHeight+55+51, KScreen_Width-50, 1)];
    [line setBackgroundColor:MAINSEPRATELINECOLOR];
    [self.view addSubview:line];
    
    /* ****  添加手机联系人  **** */
    UIView *addPhoneContactsView=[[UIView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+55+52, KScreen_Width, 52)];
    [addPhoneContactsView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:addPhoneContactsView];
    UIButton *addPhoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [addPhoneBut setFrame:CGRectMake(0, 0, 178, 51)];
    [addPhoneBut setImage:KImage(@"KCContacts-通讯录") forState:UIControlStateNormal];
    [addPhoneBut setTitle:@"添加手机联系人" forState:UIControlStateNormal];
    [addPhoneBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [addPhoneBut.titleLabel setFont:AppointTextFontSecond];
    [addPhoneBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageLeft imageTitleSpace:10];
    [addPhoneContactsView addSubview:addPhoneBut];
    UIButton *addPhoneContactsBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [addPhoneContactsBut setFrame:addPhoneContactsView.bounds];
    [addPhoneContactsBut addTarget:self action:@selector(addPhoneContactsButClick:) forControlEvents:UIControlEventTouchUpInside];
    [addPhoneContactsView  insertSubview:addPhoneContactsBut aboveSubview:addPhoneBut];
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(50, 51, KScreen_Width-50, 1)];
    [line2 setBackgroundColor:MAINSEPRATELINECOLOR];
    [addPhoneContactsView addSubview:line2];
    /* ****  添加手机联系人  **** */
    UIView *radarAddPhoneContactsView=[[UIView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight+55+52+52, KScreen_Width, 51)];
    [radarAddPhoneContactsView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:radarAddPhoneContactsView];
    UIButton *radarAddPhoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [radarAddPhoneBut setFrame:CGRectMake(0, 0, 160, 51)];
    [radarAddPhoneBut setImage:KImage(@"KCContact-radar") forState:UIControlStateNormal];
    [radarAddPhoneBut setTitle:@"雷达添加好友" forState:UIControlStateNormal];
    [radarAddPhoneBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [radarAddPhoneBut.titleLabel setFont:AppointTextFontSecond];
    [radarAddPhoneBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageLeft imageTitleSpace:10];
    [radarAddPhoneContactsView addSubview:radarAddPhoneBut];
    UIButton *radarAddPhoneContactsBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [radarAddPhoneContactsBut setFrame:radarAddPhoneContactsView.bounds];
    [radarAddPhoneContactsBut addTarget:self action:@selector(radarAddContactsButClick:) forControlEvents:UIControlEventTouchUpInside];
    [radarAddPhoneContactsView  insertSubview:radarAddPhoneContactsBut aboveSubview:radarAddPhoneBut];
    
    /* ****  我的账号  **** */
    UIButton *myAccountBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [myAccountBut setFrame:CGRectMake(0, KSafeAreaTopNaviHeight+55+52+51+52, KScreen_Width-50, 50)];
    [myAccountBut setImage:KImage(@"KCContacts-二维码") forState:UIControlStateNormal];
    NSString *title=[[NSString stringWithFormat:@"我的账号:%@",[KCUserDefaultManager getAccount]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [myAccountBut setTitle:title forState:UIControlStateNormal];
    [myAccountBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [myAccountBut.titleLabel setFont:AppointTextFontThird];
    [myAccountBut layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleImageRight imageTitleSpace:2];
    [myAccountBut addTarget:self action:@selector(myAccountButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myAccountBut];
    
}

#pragma mark - network

#pragma mark - events
/*
 * 搜索
 */
-(void)searchBarButtonClick:(UIButton *)sender
{
    XLLog(@"search ...");
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
    //    // Push search view controller
    searchViewController.jz_navigationBarHidden=NO;
    [self.navigationController pushViewController:searchViewController animated:YES];
}
/*
 * 扫一扫加好友
 */
-(void)scanAddFriendButClick:(UIButton *)sender
{
    XLLog(@"scan add friend...");
    SWQRCodeViewController *VC=[[SWQRCodeViewController alloc] init];
    [VC setScanOptions:KCScanOptionsHelpLogin];
    [self.navigationController pushViewController:VC animated:YES];
}
/*
 * 添加手机联系人
 */
-(void)addPhoneContactsButClick:(UIButton *)sender
{
    XLLog(@"add phonr Contacts...");
    KCTContactsLocalContactFriendsVC *VC=[[KCTContactsLocalContactFriendsVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
/*
 * 雷达添加好友
 */
-(void)radarAddContactsButClick:(UIButton *)sender
{
    XLLog(@"radar add phone Contacts...");
    KCRadarAddFriendsVC *VC=[[KCRadarAddFriendsVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/*
 * 查看我的二维码
 */
-(void)myAccountButClick:(UIButton *)sender
{
    XLLog(@"myAccountBut");
    KCMyQRCodeVC *VC=[[KCMyQRCodeVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - delegate

/*
 * 搜索代理
 */
-(void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)searchBar searchText:(NSString *)searchText
{
    
}

#pragma mark - lazy loading
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
