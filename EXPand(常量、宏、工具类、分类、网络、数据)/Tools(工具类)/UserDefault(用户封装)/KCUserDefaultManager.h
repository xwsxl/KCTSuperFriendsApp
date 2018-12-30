//
//  KCUserDefaultManager.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCProfileInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KCUserDefaultManager : NSObject

/* ****  用户信息  **** */
+(KCProfileInfoModel *)getInfoModel;
+(void)setInfoModel:(KCProfileInfoModel *)model;

/* ****  登录状态  **** */
+(BOOL)getLoginStatus;
+(void)setLoginStatus:(BOOL)status;
/* ****  登录腾讯云  **** */
+(BOOL)getIsTimServer;
+(void)setIsTimServer:(BOOL)status;

/*****  用户名 *****/
+(NSString *)getAccount;
+(void)setAccount:(NSString *)account;

/*****  sigen值 *****/
+(NSString *)getSigen;
+(void)setSigen:(NSString *)Sigen;
/*****  腾讯云值 *****/
+(NSString *)getSig;
+(void)setSig:(NSString *)Sig;

/* ****  手机号  **** */
+(NSString *)getPhoneNum;
+(void)setPhone:(NSString *)phoneNum;

/* ****  头像地址  **** */
+(NSString *)getHeaderIconStr;
+(void)setHeaderIconStr:(NSString *)headerIconStr;

/* ****  日记数  **** */
+(NSString *)getdiaryNum;
+(void)setDiaryNum:(NSString *)diaryNum;

/* ****  关注数目  **** */
+(NSString *)getAttensionNum;
+(void)setAttensionNum:(NSString *)attensionNum;

/* ****  粉丝数  **** */
+(NSString *)getfansNum;
+(void)setFansNum:(NSString *)fansNum;

/* ****  账户类型  **** */
+(NSString *)getAccount_type;
+(void)setAccount_type:(NSString *)Account_type;

/* ****  昵称  **** */
+(NSString *)getNickName;
+(void)setNickName:(NSString *)nickName;
/* ****  性别  **** */
+(NSString *)getSex;
+(void)setSex:(NSString *)sex;

/*****  删除用户信息 *****/
+(void)removeUserInfo;

@end

NS_ASSUME_NONNULL_END
