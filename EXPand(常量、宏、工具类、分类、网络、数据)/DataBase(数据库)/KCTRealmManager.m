//
//  KCTRealmManager.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/17.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTRealmManager.h"

@implementation KCTRealmManager

+ (void)setDefaultRealmForUser:(NSString *)username {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    XLLog(@"config.version=%lld",config.schemaVersion);
    config.schemaVersion=1;
    // Use the default directory, but replace the filename with the username
    config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
        XLLog(@"old config.version=%lld",oldSchemaVersion);
    };
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                       URLByAppendingPathComponent:username]
                      URLByAppendingPathExtension:@"realm"];
    
    // Set this as the configuration used for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    
}

/* ****  添加或修改数据  **** */
+(void)addOrUpdateObject:(RLMObject *)obj
{
    [KCTRealmManager addOrUpdateObjects:@[obj]];
}
+(void)addOrUpdateObjects:(NSArray *)arr
{
    RLMRealm *realm=[RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
       [realm addOrUpdateObjects:arr];
    }];
}

/* ****  删除数据  **** */
+(void)deleteObject:(RLMObject *)obj
{
    [KCTRealmManager deleteObjects:@[obj]];
}
+(void)deleteObjects:(NSArray *)arr
{
    RLMRealm *realm=[RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:arr];
    }];
}
/* ****  删除所有数据  **** */
+(void)deleteAllObjects
{
    RLMRealm *realm=[RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteAllObjects];
    }];
}

/* ****  根据联系人信息创建一个roomModel  **** */
+(RoomRLMModel *)roomModelWithContactModel:(ContactRLMModel *)model
{
    NSString *roomNo=[[[[KCUserDefaultManager getAccount] stringByAppendingString:@"_"] stringByAppendingString:model.account] md5];
    RLMResults *rs=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo contains '%@'",roomNo]];
    
    if (rs.count>0) {
        return  rs.lastObject;
    }else
    {
        RoomRLMModel *Rmodel=[[RoomRLMModel alloc] init];
        Rmodel.type=0;
        Rmodel.roomNo=roomNo;
        Rmodel.contact=model;
        return Rmodel;
    }
}
/* ****  根据群组信息创建一个roomModel  **** */
+(RoomRLMModel *)roomModelWithGroupModel:(GroupRLMModel *)model
{
    NSString *roomNo=[[[[KCUserDefaultManager getAccount] stringByAppendingString:@"_"] stringByAppendingString:model.groupNum] md5];
    RLMResults *rs=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo contains '%@'",roomNo]];
    
    if (rs.count>0) {
        return  rs.lastObject;
    }else
    {
        RoomRLMModel *Rmodel=[[RoomRLMModel alloc] init];
        Rmodel.type=1;
        Rmodel.roomNo=roomNo;
        Rmodel.group=model;
        return Rmodel;
    }
}
+(ContactRLMModel *)getSelfContact
{
    
    RLMResults *rs=[ContactRLMModel objectsWhere:[NSString stringWithFormat:@"account contains '%@'",[KCUserDefaultManager getAccount]]];
    if (rs.count>0) {
        return rs.lastObject;
    }else
    {
        ContactRLMModel *model=[[ContactRLMModel alloc] init];
        model.phoneNum=[KCUserDefaultManager getPhoneNum];
        model.account=[KCUserDefaultManager getAccount];
        model.portraitUri=[KCUserDefaultManager getHeaderIconStr];
        model.accountType=[[KCUserDefaultManager getAccount_type] intValue];
        model.nickName=[KCUserDefaultManager getNickName];
        model.sex=[KCUserDefaultManager getSex];
        return model;
    }
}

@end
