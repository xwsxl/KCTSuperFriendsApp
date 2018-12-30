//
//  KCProfileInfoModel.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCProfileInfoModel.h"

@implementation KCProfileInfoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"headerIconStr":@"portraitUri",
            // @"nickName":@"nick_name",
             @"accountName":@"account",
             @"phone_Num":@"phoneNum",
             @"account_type":@"accountType",
             @"client_id":@"clientId",
             @"sig":@"accountSig"
            
             };
}
/* ****  头像地址  **** */
-(NSString *)headerIconStr
{
    if (!_headerIconStr) {
        _headerIconStr=@"";
    }
    return _headerIconStr;
}

/* ****  昵称  **** */
-(NSString *)nickName
{
    if (!_nickName) {
        _nickName=@"";
    }
    return _nickName;
}
/* ****  账户  **** */
-(NSString *)accountName
{
    if (!_accountName) {
        _accountName=@"";
    }
    return _accountName;
}
/* ****  日记数  **** */
-(NSString *)diaryNum
{
    if (!_diaryNum) {
        _diaryNum=@"";
    }
    return _diaryNum;
}
/* ****  关注数目  **** */
-(NSString *)attensionNum
{
    if (!_attensionNum) {
        _attensionNum=@"";
    }
    return _attensionNum;
}
/* ****  粉丝数  **** */
-(NSString *)fansNum
{
    if (!_fansNum) {
        _fansNum=@"";
    }
    return _fansNum;
}
/* ****  账户类型  **** */
-(NSString *)account_type
{
    if (!_account_type) {
        _account_type=@"";
    }
    return _account_type;
}
/* ****  服务器验证参数  **** */
-(NSString *)authorization
{
    if (!_authorization) {
        _authorization=@"";
    }
    return _authorization;
}
/* ****  flypass的client_id  **** */
-(NSString *)client_id
{
    if (!_client_id) {
        _client_id=@"";
    }
    return _client_id;
}
/* ****  <#description#>  **** */
-(NSString *)client_pwd
{
    if (!_client_pwd) {
        _client_pwd=@"";
    }
    return _client_pwd;
}
/* ****  数据h创建时间毫秒  **** */
-(NSString *)created_time
{
    if (!_created_time) {
        _created_time=@"";
    }
    return _created_time;
}
/* ****  <#description#>  **** */
-(NSString *)flypassSid
{
    if (!_flypassSid) {
        _flypassSid=@"";
    }
    return _flypassSid;
}
/* ****  <#description#>  **** */
-(NSString *)flypassToken
{
    if (!_flypassToken) {
        _flypassToken=@"";
    }
    return _flypassToken;
}
/* ****  性别 1:男 2:女  **** */
-(NSString *)sex
{
    if (!_sex) {
        _sex=@"";
    }
    return _sex;
}
/* ****  <#description#>  **** */
-(NSString *)is_valid
{
    if (!_is_valid) {
        _is_valid=@"";
    }
    return _is_valid;
}
/* ****  <#description#>  **** */
-(NSString *)modified_time
{
    if (!_modified_time) {
        _modified_time=@"";
    }
    return _modified_time;
}
/* ****  <#description#>  **** */
-(NSString *)phone_Num
{
    if (!_phone_Num) {
        _phone_Num=@"";
    }
    return _phone_Num;
}


@end
