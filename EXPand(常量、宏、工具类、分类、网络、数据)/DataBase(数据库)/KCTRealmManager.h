//
//  KCTRealmManager.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/17.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm.h"
#import "RoomRLMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCTRealmManager : NSObject

/* ****  根据用户名设置默认的config  **** */
+ (void)setDefaultRealmForUser:(NSString *)username;


/* ****  添加或修改数据  **** */
+(void)addOrUpdateObject:(RLMObject *)obj;
+(void)addOrUpdateObjects:(NSArray *)arr;

/* ****  删除数据  **** */
+(void)deleteObject:(RLMObject *)obj;
+(void)deleteObjects:(NSArray *)arr;

/* ****  删除所有数据  **** */
+(void)deleteAllObjects;

/* ****  根据联系人信息创建一个roomModel  **** */
+(RoomRLMModel *)roomModelWithContactModel:(ContactRLMModel *)model;
/* ****  根据群组信息创建一个roomModel  **** */
+(RoomRLMModel *)roomModelWithGroupModel:(GroupRLMModel *)model;

+(ContactRLMModel *)getSelfContact;
@end

NS_ASSUME_NONNULL_END
