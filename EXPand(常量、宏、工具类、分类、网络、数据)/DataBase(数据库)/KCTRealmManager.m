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
    RLMRealm *realm=[RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        [realm addOrUpdateObject:obj];
    }];
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


/* ****  删除联系人  **** */
+(void)deleteContactWithAccout:(NSString *)account
{
    ContactRLMModel *model=[ContactRLMModel objectsWhere:[NSString stringWithFormat:@"account = '%@'",account]].lastObject;
    [KCTRealmManager deleteContactWithModel:model];
}
/* ****  删除消息  **** */
+(void)deleteMessageWithChatId:(NSString *)chatId
{
    MessageRLMModel *model=[MessageRLMModel objectsWhere:[NSString stringWithFormat:@"account = '%@'",chatId]].lastObject;
    [KCTRealmManager deleteMessageWithModel:model];
}
/* ****  删除群组  **** */
+(void)deleteGroupWithGroupNum:(NSString *)groupNum
{
    GroupRLMModel *model=[GroupRLMModel objectsWhere:[NSString stringWithFormat:@"account = '%@'",groupNum]].lastObject;
    [KCTRealmManager deleteGroupWithModel:model];
}
/* ****  删除房间  **** */
+(void)deleteRoomWithRoomNo:(NSString *)roomNo
{
     RoomRLMModel *model=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"account = '%@'",roomNo]].lastObject;
     [KCTRealmManager deleteRoomWithModel:model];
}

/* ****  删除联系人  **** */
+(void)deleteContactWithModel:(ContactRLMModel *)obj
{
    
    NSString *roomNo=[[[[KCUserDefaultManager getAccount] stringByAppendingString:@"_"] stringByAppendingString:obj.account] md5];
    RoomRLMModel *Rmodel=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo = '%@'",roomNo]].lastObject;
    if (obj!=nil) {
        [KCTRealmManager deleteObject:obj];
    }
    if (Rmodel!=nil) {
        [KCTRealmManager deleteObject:Rmodel];
    }
    
}
/* ****  删除消息  **** */
+(void)deleteMessageWithModel:(MessageRLMModel *)obj
{
    
    if (obj!=nil) {
        [KCTRealmManager deleteObject:obj];
    }
}
/* ****  删除群组  **** */
+(void)deleteGroupWithModel:(GroupRLMModel *)obj
{
    
    NSString *roomNo=[[[[KCUserDefaultManager getAccount] stringByAppendingString:@"_"] stringByAppendingString:obj.groupNum] md5];
    RoomRLMModel *Rmodel=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo = '%@'",roomNo]].lastObject;
    if (obj!=nil) {
        [KCTRealmManager deleteObject:obj];
    }
    if (Rmodel!=nil) {
        [KCTRealmManager deleteObject:Rmodel];
    }
}
/* ****  删除房间  **** */
+(void)deleteRoomWithModel:(RoomRLMModel *)obj
{
   
    if (obj!=nil) {
        [KCTRealmManager deleteObject:obj];
    }
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
