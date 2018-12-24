//
//  GroupRLMModel.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/21.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "RLMObject.h"
#import "MJExtension.h"
#import "ContactRLMModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface GroupRLMModel : RLMObject
/* ****  群号  **** */
@property (nonatomic, copy) NSString *groupNum;
/* ****  群名字  **** */
@property (nonatomic, copy) NSString *groupName;
/* ****  群主  **** */
@property (nonatomic, copy) NSString *groupOwner;
/* ****  群类型 1。班级群 2。普通群 3.家庭群   **** */
@property (nonatomic, copy) NSString *groupType;
/* ****  群简介  **** */
@property (nonatomic, copy) NSString *groupIntro;
/* ****  二维码  **** */
@property (nonatomic, copy) NSString *codeImgUrl;
/* ****  群头像  **** */
@property (nonatomic, copy) NSString *groupPhoto;
///* ****  成员  **** */
//@property (nonatomic, strong) RLMArray<ContactRLMModel *><ContactRLMModel> *members;

@end

NS_ASSUME_NONNULL_END
