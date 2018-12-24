//
//  KCTReceiveDataManager.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTReceiveDataManager.h"
#import "KCTSendDataManager.h"
#import "KCWebSocketManager.h"
@implementation KCTReceiveDataManager

+(KCTReceiveDataManager *)instance{
    static KCTReceiveDataManager *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[KCTReceiveDataManager alloc] init];
    });
    return Instance;
}

-(void)dealWithMessage:(id)message
{
        NSData *data1 = [[NSData alloc] initWithData:[message dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    
        XLLog(@"解析后的数据:%@",dic);
        if ([dic[@"type"] integerValue]!=20) {
            [KCTSendDataManager sendReceiptWithChatID:dic[@"id"] to:dic[@"from"]];
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
         19    未读消息的数量
         */
        /* ****  type=21 断开连接  **** */
        if ([dic[@"type"] integerValue]==21) {
            XLLog(@"************************** socket连接断开************************** ");
            [[KCWebSocketManager instance] SRWebSocketClose];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidCloseNote object:nil];
        }else if([dic[@"type"] integerValue]==17)
        {
            [self dealWithSingleMessage:dic];
        }else if ([dic[@"type"] integerValue]==16)
        {
            [self dealWithSingleMessage:dic];
        }
}
/* ****  处理聊天消息  **** */
-(void)dealWithSingleMessage:(NSDictionary *)dic
{
    NSInteger count=[[UIApplication sharedApplication] applicationIconBadgeNumber];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count+1];
    MessageRLMModel *model=[[MessageRLMModel alloc] init];
    //{"from":"502140675","text":"{\"chatId\":\"\",\"from_account\":\"502140675\",\"id\":\"07a0e08db2b4cc07ddba883230e8caed\",\"group_owner\":\"\",\"time\":1543236120049,\"type\":1008,\"from_avatar\":\"dmetdcd0fvqtthnjpwu1154mah85qqu64hd7q85qhjc4y3b3gg\",\"from_name\":\"火丶\",\"url\":\"{\\\"url\\\":\\\"土豆\\\"}\"}","to":"072505735","type":17}
    NSString *datastring=dic[@"text"];
    NSData *data2 = [[NSData alloc] initWithData:[datastring dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *data=[NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
    
    /* ****  判断收到过消息就不再处理这条消息 直接返回  **** */
    RLMResults *rsM=[MessageRLMModel objectsWhere:[NSString stringWithFormat:@"chatId contains '%@'",data[@"id"]]];
    if (rsM.count>0) {
        return;
    }
    
    model.chatId=data[@"id"];
    model.timeStamp=[data[@"time"] longValue];
    if ([data[@"type"] integerValue]==1008) {
        model.msgType=0;
    }else if ([data[@"type"] integerValue]==1001)
    {
        model.msgType=2;
    }else if ([data[@"type"] integerValue]==1004)
    {
        model.msgType=1;
    }else if ([data[@"type"] integerValue]==1002)
    {
        model.msgType=4;
    }
    
    
    NSString *datastring3=data[@"url"];
    NSData *data3 = [[NSData alloc] initWithData:[datastring3 dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *d=[NSJSONSerialization JSONObjectWithData:data3 options:NSJSONReadingMutableContainers error:nil];
    model.msg=d[@"url"];
    
    model.duration=d[@"duration"]?[d[@"duration"] floatValue]:0;
    model.imageW=d[@"width"]?[d[@"width"] floatValue]:0;
    model.imageH=d[@"height"]?[d[@"height"] floatValue]:0;
    
    model.roomNo=[[NSString stringWithFormat:@"%@_%@",[KCUserDefaultManager getAccount],data[@"from_account"]] md5];
    
    
    RLMResults *rs=[ContactRLMModel objectsWhere:[NSString stringWithFormat:@"account contains '%@'",data[@"from_account"]]];
    ContactRLMModel *Cmodel;
    if (rs.count>0) {
        Cmodel=rs.lastObject;
        model.contact=Cmodel;
    }else
    {
        Cmodel=[[ContactRLMModel alloc] init];
        Cmodel.account=data[@"from_account"];
        Cmodel.portraitUri=data[@"from_avatar"];
        Cmodel.nickName=data[@"from_name"];
        model.contact=Cmodel;
    }
    /* ****  获取本地是否有房间号、没有则创建房间  **** */
    RLMResults *rs2=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo contains '%@'",model.roomNo]];
    RoomRLMModel *rModel;
    if (rs2.count==0) {
        rModel=[[RoomRLMModel alloc] init];
        rModel.roomNo=model.roomNo;
        rModel.timestamp=model.timeStamp;
        rModel.type=0;
        rModel.contact=Cmodel;
        rModel.unreadNum=1;
        rModel.chat=model;
        [KCTRealmManager addOrUpdateObject:rModel];
    }else
    {
        rModel=rs2.lastObject;
        
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            rModel.timestamp=model.timeStamp;
            rModel.unreadNum=rModel.unreadNum+1;
            rModel.chat=model;
        }];
    }
   
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessageNote object:nil];
    
}

@end
