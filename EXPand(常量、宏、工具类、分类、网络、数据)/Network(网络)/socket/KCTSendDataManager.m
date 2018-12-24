//
//  KCTSendDataManager.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/26.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTSendDataManager.h"
#import "MessageRLMModel.h"
#import "KCWebSocketManager.h"
#import "KCTModelManager.h"
@implementation KCTSendDataManager




/* ****  发送聊天消息  **** */
+(void)SendMessage:(MessageRLMModel *)model andRoom:(RoomRLMModel *)Rmodel
{
    RLMResults *rs=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo contains '%@'",Rmodel.roomNo]];
    if (rs.count>0) {
        RoomRLMModel *Rmodel=rs.lastObject;
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            Rmodel.chat=model;
            Rmodel.timestamp=model.timeStamp;
        }];
    }else
    {
        Rmodel.chat=model;
        Rmodel.timestamp=model.timeStamp;
        [KCTRealmManager addOrUpdateObject:Rmodel];
    }
    
    NSMutableDictionary *msgDic=[[NSMutableDictionary alloc] init];

    NSData *data1=[NSJSONSerialization dataWithJSONObject:@{@"url":model.msg,@"duration":@(model.duration*1000),@"width":@(model.imageW),@"height":@(model.imageH)}
                                                  options:NSJSONWritingPrettyPrinted
                                                    error:nil];
    NSString *str1=[[[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    [msgDic setObject:str1 forKey:@"url"];
    [msgDic setObject:model.chatId forKey:@"chatId"];
    [msgDic setObject:[KCUserDefaultManager getAccount] forKey:@"from_account"];
    [msgDic setObject:model.chatId forKey:@"id"];
    [msgDic setObject:@(model.timeStamp) forKey:@"time"];
    [msgDic setObject:[KCUserDefaultManager getNickName] forKey:@"from_name"];
    [msgDic setObject:[KCUserDefaultManager getHeaderIconStr] forKey:@"from_avatar"];
    
    
    if (model.msgType==0) {
        /*
         * 消息类型type: 1001:voice 1002:video 1003:live 1004:image 1005:local emoji 1006:remote emoji 1007:event  1008:text
         url: 语音视频图片为url 文本消息为文本信息
         duration 语音视频时长
         time //消息发送时间、长整型
         from_account //发送者账号
         from_name: d发送者昵称
         from_avater:发送者头像
         chatID:rtc视频通话ID
         group_owner:消息为群消息时账号
         id:消息id;
         serialNo:
         */
       
        //文本
        [msgDic setObject:@1008 forKey:@"type"];
        
        
    }else if (model.msgType==1)
    {//图片
        //图片
        [msgDic setObject:@1004 forKey:@"type"];
    }else if (model.msgType==2)
    {//语音
       
        
        //语音
        [msgDic setObject:@1001 forKey:@"type"];
        
    }else if (model.msgType==4)
    {
        //短视频
        [msgDic setObject:@1002 forKey:@"type"];
    }
    /*
     * type
     1    申请好友请求
     2    连接成功
     3    删除好友
     4    申请好友成功
     5    绑定账户申请通知
     6    绑定账户成功通知
     7    请求地理位置
     8    心跳
     9    发送地理位置
     10    停止请求地理位置
     11    任务消息
     15    雷达加好友成功通知
     16    群聊
     17    个人聊天
     18    通知手表打开视频
     19    未读消息的数量a
     */
    NSNumber *typeValue=[[NSNumber alloc] init];
    if (Rmodel.type==1) {
        typeValue=[NSNumber numberWithInt:16];
        
        [msgDic setObject:Rmodel.group.groupNum forKey:@"groupNum"];
        
        NSDictionary *dic=@{@"from":[KCUserDefaultManager getAccount],@"to":Rmodel.group.groupNum,@"type":typeValue,@"text":msgDic,@"deviceType":@"2",@"id":model.chatId};
        
        NSData *data=[NSJSONSerialization dataWithJSONObject:dic
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:nil];
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [[KCWebSocketManager instance] sendData:str];
    }else
    {
        typeValue=[NSNumber numberWithInt:17];
        NSDictionary *dic=@{@"from":[KCUserDefaultManager getAccount],@"to":Rmodel.contact.account,@"type":typeValue,@"text":msgDic,@"deviceType":@"2",@"id":model.chatId};
        
        
        NSData *data=[NSJSONSerialization dataWithJSONObject:dic
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:nil];
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [[KCWebSocketManager instance] sendData:str];
    }
    
}



+(BOOL)sendReceiptWithChatID:(NSString *)chatID to:(NSString *)to
{
    NSDictionary *dic=@{@"to":to,@"type":@20,@"deviceType":@"2",@"id":chatID};
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic
                                                 options:NSJSONWritingPrettyPrinted
                                                   error:nil];
    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[KCWebSocketManager instance] sendData:str];
    return YES;
}



@end
