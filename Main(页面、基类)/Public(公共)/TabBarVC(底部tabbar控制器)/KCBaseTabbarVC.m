//
//  KCBaseTabbarVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/17.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseTabbarVC.h"
#import "KCMessageVC.h"
#import "KCTContactsVC.h"
#import "KCDiaryVC.h"
#import "KCProfileVC.h"
#import "KCLoginBDPhoneVC.h"

@interface KCBaseTabbarVC ()

/**
 Description 4个模块导航栏
 */
@property (nonatomic, strong) UINavigationController                *messageNavi;
@property (nonatomic, strong) UINavigationController                *contactsNavi;
@property (nonatomic, strong) UINavigationController                *diaryNavi;
@property (nonatomic, strong) UINavigationController                *profileNavi;

@end

@implementation KCBaseTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarItems];
    // Do any additional setup after loading the view.
}

/**
 Description 设置4个Tab
 */
- (void)setupTabBarItems {
    
    NSMutableArray *controllers = [NSMutableArray array];
    
    //首页
    KCMessageVC *messageVC = [[KCMessageVC alloc] init];
    UIImage *homeUnselectedImage = [[UIImage imageNamed:@"KCTabbar-消息"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *homeSelectedImage = [[UIImage imageNamed:@"KCTabbar-消息-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.messageNavi = [[UINavigationController alloc] initWithRootViewController:messageVC]; //tabbar_chatsHL
    self.messageNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:homeUnselectedImage selectedImage:homeSelectedImage];
    self.messageNavi.navigationBar.barTintColor = [UIColor whiteColor];
    self.messageNavi.navigationItem.title = @"消息";
    self.messageNavi.navigationBar.tintColor =APPOINTCOLORSecond;
    [self.messageNavi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : APPOINTCOLORSecond}];
  //  messageVC.jz_navigationBarHidden = YES;
    [controllers addObject:self.messageNavi];
    
    //分类
    KCTContactsVC *contactsVC = [[KCTContactsVC alloc] init];
    UIImage *classifyUnselectedImage = [[UIImage imageNamed:@"KCTabbar-联系人"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *classifySelectedImage = [[UIImage imageNamed:@"KCTabbar-联系人-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.contactsNavi = [[UINavigationController alloc] initWithRootViewController:contactsVC];
    self.contactsNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:classifyUnselectedImage selectedImage:classifySelectedImage];
    self.contactsNavi.navigationBar.barTintColor = [UIColor whiteColor];
//    contactsVC.jz_navigationBarHidden = YES;
//    self.messageNavi.navigationBar.barTintColor = [UIColor blackColor];
    self.contactsNavi.navigationBar.tintColor =APPOINTCOLORSecond;
    [self.contactsNavi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : APPOINTCOLORSecond}];
    [controllers addObject:self.contactsNavi];
    
    //购物车
    KCDiaryVC *diaryVC = [[KCDiaryVC alloc] init];
    UIImage *classifyshoppingCartUnselectedImage = [[UIImage imageNamed:@"KCTabbar-日记圈"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *classifyshoppingCartSelectedImage = [[UIImage imageNamed:@"KCTabbar-日记圈-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.diaryNavi = [[UINavigationController alloc] initWithRootViewController:diaryVC];
    self.diaryNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"日记圈" image:classifyshoppingCartUnselectedImage selectedImage:classifyshoppingCartSelectedImage];
    self.diaryNavi.navigationBar.barTintColor = [UIColor whiteColor];
    self.diaryNavi.navigationItem.title = @"日记圈";
    self.diaryNavi.navigationBar.tintColor =APPOINTCOLORSecond;
    [self.diaryNavi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : APPOINTCOLORSecond}];
//    diaryVC.jz_navigationBarHidden = YES;
    [controllers addObject:self.diaryNavi];
    
    //我的
    KCProfileVC *profileVC = [[KCProfileVC alloc] init];
    UIImage *profileUnselectedImage = [[UIImage imageNamed:@"KCTabbar-我"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *profileSelectedImage = [[UIImage imageNamed:@"KCTabbar-我-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.profileNavi = [[UINavigationController alloc] initWithRootViewController:profileVC];
    self.profileNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:profileUnselectedImage selectedImage:profileSelectedImage];
    self.profileNavi.navigationBar.barTintColor = [UIColor whiteColor];
    self.profileNavi.navigationItem.title = @"我";
    self.profileNavi.navigationBar.tintColor =APPOINTCOLORSecond;
    [self.profileNavi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : APPOINTCOLORSecond}];
//    profileVC.jz_navigationBarHidden = YES;
    [controllers addObject:self.profileNavi];
    
    [self setViewControllers:@[self.messageNavi,self.contactsNavi,self.diaryNavi,self.profileNavi]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:APPOINTCOLORThird,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:APPOINTCOLORSecond,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                     NSForegroundColorAttributeName:APPOINTCOLORSecond,
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    
    
}

/**
 Description 模态到某个控制器
 
 @param viewController <#viewController description#>
 @param animated <#animated description#>
 @param completion <#completion description#>
 */
- (void)presentToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    if([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController *)self.selectedViewController;
        [navigation presentViewController:viewController animated:animated completion:completion];
    }
}
@end
