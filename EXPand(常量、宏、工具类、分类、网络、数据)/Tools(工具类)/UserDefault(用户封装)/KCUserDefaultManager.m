//
//  KCUserDefaultManager.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCUserDefaultManager.h"

@implementation KCUserDefaultManager
/* ****  登录状态  **** */
+(BOOL)getLoginStatus
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL loginStatus=[userDefaults boolForKey:@"loginStatus"];
    [userDefaults synchronize];
    return loginStatus;
}
+(void)setLoginStatus:(BOOL)status
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:status forKey:@"loginStatus"];
    [userDefaults synchronize];
}
/* ****  用户信息  **** */
+(KCProfileInfoModel *)getInfoModel
{
    KCProfileInfoModel *model=[KCProfileInfoModel new];
    model.phone_Num=[KCUserDefaultManager getPhoneNum];
    model.accountName=[KCUserDefaultManager getAccount];
    model.authorization=[KCUserDefaultManager getSigen];
    model.headerIconStr=[KCUserDefaultManager getHeaderIconStr];
    model.diaryNum=[KCUserDefaultManager getdiaryNum];
    model.attensionNum=[KCUserDefaultManager getAttensionNum];
    model.fansNum=[KCUserDefaultManager getfansNum];
    model.account_type=[KCUserDefaultManager getAccount_type];
    model.nickName=[KCUserDefaultManager getNickName];
    model.sex=[KCUserDefaultManager getSex];
    return model;
}
+(void)setInfoModel:(KCProfileInfoModel *)model
{
    XLLog(@"存储数据%@",model);
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [KCUserDefaultManager setPhone:model.phone_Num];
    [KCUserDefaultManager setAccount:model.accountName];
    [KCUserDefaultManager setSigen:model.authorization];
    [KCUserDefaultManager setHeaderIconStr:model.headerIconStr];
    [KCUserDefaultManager setDiaryNum:model.diaryNum];
    [KCUserDefaultManager setFansNum:model.fansNum];
    [KCUserDefaultManager setAttensionNum:model.attensionNum];
    [KCUserDefaultManager setAccount_type:model.account_type];
    [KCUserDefaultManager setNickName:model.nickName];
    [KCUserDefaultManager setSex:model.sex];
    [userDefaults synchronize];
}
/*****  用户名 *****/
+(NSString *)getAccount
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account=[userDefaults stringForKey:@"account"];
    [userDefaults synchronize];
    if (!account) {
        account=@"";
    }
    return account;
}
+(void)setAccount:(NSString *)account
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:@"account"];
    [userDefaults synchronize];
}
/*****  sigen值 *****/
+(NSString *)getSigen
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sigen=[userDefaults stringForKey:@"sigen"];
    [userDefaults synchronize];
    if (!sigen) {
        sigen=@"";
    }
    return sigen;
}
+(void)setSigen:(NSString *)Sigen
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:Sigen forKey:@"sigen"];
    [userDefaults synchronize];
}
/* ****  手机号  **** */
+(NSString *)getPhoneNum
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum=[userDefaults stringForKey:@"phone"];
    [userDefaults synchronize];
    if (!phoneNum) {
        phoneNum=@"";
    }
    return phoneNum;
}
+(void)setPhone:(NSString *)phoneNum
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:phoneNum forKey:@"phone"];
    [userDefaults synchronize];
}
/* ****  头像地址  **** */
+(NSString *)getHeaderIconStr
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *headerIconStr=[userDefaults stringForKey:@"headerIconStr"];
    [userDefaults synchronize];
    if (!headerIconStr) {
        headerIconStr=@"";
    }
    return headerIconStr;
}
+(void)setHeaderIconStr:(NSString *)headerIconStr
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:headerIconStr forKey:@"headerIconStr"];
    [userDefaults synchronize];
}
/* ****  日记数  **** */
+(NSString *)getdiaryNum
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *diaryNum=[userDefaults stringForKey:@"diaryNum"];
    [userDefaults synchronize];
    if (!diaryNum) {
        diaryNum=@"0";
    }
    return diaryNum;
}
+(void)setDiaryNum:(NSString *)diaryNum
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:diaryNum forKey:@"diaryNum"];
    [userDefaults synchronize];
}

/* ****  关注数目  **** */
+(NSString *)getAttensionNum
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *AttensionNum=[userDefaults stringForKey:@"AttensionNum"];
    [userDefaults synchronize];
    if (!AttensionNum) {
        AttensionNum=@"0";
    }
    return AttensionNum;
}
+(void)setAttensionNum:(NSString *)attensionNum
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:attensionNum forKey:@"AttensionNum"];
    [userDefaults synchronize];
}

/* ****  粉丝数  **** */
+(NSString *)getfansNum
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fansNum=[userDefaults stringForKey:@"fansNum"];
    [userDefaults synchronize];
    if (!fansNum) {
        fansNum=@"0";
    }
    return fansNum;
}
+(void)setFansNum:(NSString *)fansNum
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:fansNum forKey:@"fansNum"];
    [userDefaults synchronize];
}

/* ****  账户类型  **** */
+(NSString *)getAccount_type
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Account_type=[userDefaults stringForKey:@"Account_type"];
    [userDefaults synchronize];
    if (!Account_type) {
        Account_type=@"1";
    }
    return Account_type;
}
+(void)setAccount_type:(NSString *)Account_type
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:Account_type forKey:@"Account_type"];
    [userDefaults synchronize];
}
/* ****  昵称  **** */
+(NSString *)getNickName
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nickName=[userDefaults stringForKey:@"nickName"];
    [userDefaults synchronize];
    if (!nickName) {
        nickName=@"nick";
    }
    return nickName;
}
+(void)setNickName:(NSString *)nickName
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nickName forKey:@"nickName"];
    [userDefaults synchronize];
}
/* ****  性别  **** */
+(NSString *)getSex
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sex=[userDefaults stringForKey:@"sex"];
    [userDefaults synchronize];
    if (!sex) {
        sex=@"";
    }
    return sex;
}
+(void)setSex:(NSString *)sex
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sex forKey:@"sex"];
    [userDefaults synchronize];
}
/*****  删除用户信息 *****/
+(void)removeUserInfo
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"sigen"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults synchronize];
}
@end
