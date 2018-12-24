//
//  ContactRLMModel.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/17.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "RLMObject.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN
/* ****  联系人表table  **** */
@interface ContactRLMModel : RLMObject
/* ****  账户  **** */
@property (nonatomic, copy) NSString *account;
/* ****  绑定手机号  **** */
@property (nonatomic, copy) NSString *phoneNum;
/* ****  性别 1:男 2:女  **** */
@property (nonatomic, copy) NSString *sex;
/* ****  头像地址  **** */
@property (nonatomic, copy) NSString *portraitUri;
/* ****  昵称  **** */
@property (nonatomic, copy) NSString *nickName;
/* ****   备注 **** */
@property (nonatomic, copy) NSString *aliasName;
/* ****  账户类型  1.孩子端 2.家长端 **** */
@property (nonatomic, assign) int accountType;
/* ****  创建时间毫秒  **** */
@property (nonatomic, copy) NSString *createdTime;
/* ****  flypass视频id  **** */
@property (nonatomic, copy) NSString *clientId;
/* ****  0好友 1非好友  **** */
@property (nonatomic, assign) int friendType;


/* ****  忽略的  **** */
@property (nonatomic, strong) NSString *content;
@end
RLM_ARRAY_TYPE(ContactRLMModel)
NS_ASSUME_NONNULL_END


