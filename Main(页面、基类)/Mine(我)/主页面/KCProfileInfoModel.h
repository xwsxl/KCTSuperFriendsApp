//
//  KCProfileInfoModel.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCProfileInfoModel : KCBaseModel
/* ****  头像地址  **** */
@property (nonatomic, copy) NSString *headerIconStr;
/* ****  昵称  **** */
@property (nonatomic, copy) NSString *nickName;
/* ****  账户  **** */
@property (nonatomic, copy) NSString *accountName;
/* ****  日记数  **** */
@property (nonatomic, copy) NSString *diaryNum;
/* ****  关注数目  **** */
@property (nonatomic, copy) NSString *attensionNum;
/* ****  粉丝数  **** */
@property (nonatomic, copy) NSString *fansNum;
/* ****  账户类型  **** */
@property (nonatomic, copy) NSString *account_type;
/* ****  性别 1:男 2:女  **** */
@property (nonatomic, copy) NSString *sex;
/* ****  服务器验证参数  **** */
@property (nonatomic, copy) NSString *authorization;
/* ****  数据h创建时间毫秒  **** */
@property (nonatomic, copy) NSString *created_time;
/* ****  绑定手机号  **** */
@property (nonatomic, copy) NSString *phone_Num;
/* ****  腾讯云id  **** */
@property (nonatomic, copy) NSString *sig;
/* ****  本地联系人头像  **** */
@property (nonatomic, copy) UIImage *headImage;
/* ****  是否已经注册  **** */
@property (nonatomic, assign) BOOL regirst;
/* ****  好友申请验证  **** */
@property (nonatomic, copy) NSString *content;
/* ****  好友申请id  **** */
@property (nonatomic, copy) NSString *id;
/* ****  结果类型  **** */
@property (nonatomic, copy) NSString *resultType;

/* ****  flypass的client_id  **** */
@property (nonatomic, copy) NSString *client_id;
/* ****  <#description#>  **** */
@property (nonatomic, copy) NSString *client_pwd;
/* ****  <#description#>  **** */
@property (nonatomic, copy) NSString *flypassSid;
/* ****  <#description#>  **** */
@property (nonatomic, copy) NSString *flypassToken;
/* ****  <#description#>  **** */
@property (nonatomic, copy) NSString *is_valid;
/* ****  <#description#>  **** */
@property (nonatomic, copy) NSString *modified_time;


@end

NS_ASSUME_NONNULL_END
