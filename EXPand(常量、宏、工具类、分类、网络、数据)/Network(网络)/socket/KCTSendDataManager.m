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
#import <ImSDK/ImSDK.h>
@implementation KCTSendDataManager


/*
 * 消息类型type:
 int TYPE_TEXT = 1001;
 int TYPE_IMAGE = 1002;
 int TYPE_AUDIO = 1003;
 int TYPE_VIDEO = 1004;
 int TYPE_LIVE = 1005;
 int TYPE_CARD = 1006;
 int TYPE_LOC = 1007;
 int TYPE_NVI = 1008;
 int TYPE_PACKET = 1009;
 int TYPE_WEARHELP = 1010;
 int TYPE_EVENT = 1011;
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

    NSData *data1=[NSJSONSerialization dataWithJSONObject:@{@"url":model.msg,@"duration":@((int)(model.duration*1000)),@"width":@((int)(model.imageW)),@"height":@((int)(model.imageH))}
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
    
       
    //文本
    [msgDic setObject:@(model.msgType) forKey:@"type"];
        
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
    
    NSString *str;
    if (Rmodel.type==1) {
        NSNumber *typeValue=[[NSNumber alloc] init];
        typeValue=[NSNumber numberWithInt:16];
        
        [msgDic setObject:Rmodel.group.groupNum forKey:@"groupNum"];
        [msgDic setObject:Rmodel.group.groupPhoto forKey:@"goupPhoto"];
        [msgDic setObject:Rmodel.group.groupType forKey:@"groupType"];
        [msgDic setObject:Rmodel.group.groupName forKey:@"groupName"];
        
        NSData *msgData=[NSJSONSerialization dataWithJSONObject:msgDic
                                                      options:NSJSONWritingPrettyPrinted
                                                        error:nil];
        NSString *msgStr=[[[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSDictionary *dic=@{@"from":[KCUserDefaultManager getAccount],@"to":Rmodel.group.groupNum,@"type":typeValue,@"text":msgStr,@"deviceType":@"2",@"id":model.chatId};
        
        NSData *data=[NSJSONSerialization dataWithJSONObject:dic
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:nil];
        str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
       
    }else
    {
        NSNumber *typeValue=[[NSNumber alloc] init];
        typeValue=[NSNumber numberWithInt:17];
        
        NSData *msgData=[NSJSONSerialization dataWithJSONObject:msgDic
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
        NSString *msgStr=[[[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSDictionary *dic=@{@"from":[KCUserDefaultManager getAccount],@"to":Rmodel.contact.account,@"type":typeValue,@"text":msgStr,@"deviceType":@"2",@"id":model.chatId};
        
        
        NSData *data=[NSJSONSerialization dataWithJSONObject:dic
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:nil];
        str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
  
    
    BOOL isTim=[KCUserDefaultManager getIsTimServer];
    if (isTim) {
        if (Rmodel.type==0) {
            TIMConversation *converSation=[[TIMManager sharedInstance] getConversation:TIM_C2C receiver:Rmodel.contact.account];
            
            TIMTextElem *elem=[[TIMTextElem alloc] init];
            elem.text=str;
            TIMMessage *message=[[TIMMessage alloc] init];
            [message addElem:elem];
           // addElem:(TIMElem*)elem
            [converSation sendMessage:message succ:^{
                XLLog(@"tim send success %@",message);
               // [MBProgressHUD showMessage:[NSString stringWithFormat:@"tim send success %@",message]];
            } fail:^(int code, NSString *msg) {
                XLLog(@"tim send fail code=%d,msg=%@,message=%@",code,msg,message);
            }];
        }else
        {
            TIMConversation *converSation=[[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:Rmodel.group.groupNum];
            TIMTextElem *elem=[[TIMTextElem alloc] init];
            elem.text=str;
            TIMMessage *message=[[TIMMessage alloc] init];
            [message addElem:elem];
            [converSation sendMessage:message succ:^{
                XLLog(@"tim send success %@",message);
            } fail:^(int code, NSString *msg) {
                XLLog(@"tim send fail code=%d,msg=%@,message=%@",code,msg,message);
            }];
        }
    }else
    {
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
