//
//  SSChatDatas.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//


#import "SSChatDatas.h"
#import "KCTSendDataManager.h"
#import "KCTReceiveDataManager.h"
#import "KCTModelManager.h"
#define headerImg1  @"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg"
#define headerImg2  @"http://www.qqzhi.com/uploadpic/2014-09-14/004638238.jpg"
#define headerImg3  @"http://e.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d3b104443639f33a87e950b1b0.jpg"

//    SSChatMessageTypeText =1,
//    SSChatMessageTypeImage,
//    SSChatMessageTypeVoice,
//    SSChatMessageTypeMap,
//    SSChatMessageTypeVideo,
//    SSChatMessageTypeRedEnvelope,
//
//    SSChatMessageTypeUndo,
//    SSChatMessageTypeDelete,

@implementation SSChatDatas

//获取单聊的初始会话 数据均该由服务器处理生成 这里demo写死
+(NSMutableArray *)LoadingMessagesStartWithChat:(NSString *)sessionId{
    
    RLMResults *rs=[MessageRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo contains '%@'",sessionId]];
    rs=[rs sortedResultsUsingKeyPath:@"timeStamp" ascending:YES];
    return [SSChatDatas receiveMessages:(NSArray *)rs];
}



//获取群聊的初始会话
+(NSMutableArray *)LoadingMessagesStartWithGroupChat:(NSString *)sessionId{
    
    return nil;
}


//处理接收的消息数组
+(NSMutableArray *)receiveMessages:(NSArray *)messages{
    
    NSMutableArray *array = [NSMutableArray new];
    for(MessageRLMModel *model in messages){
        SSChatMessagelLayout *layout = [SSChatDatas getMessageWithDic:model];
        [array addObject:layout];
    }
    return array;
}

//接受一条消息
+(SSChatMessagelLayout *)receiveMessage:(MessageRLMModel *)model{
    return [SSChatDatas getMessageWithDic:model];
}

//消息内容生成消息模型
+(SSChatMessagelLayout *)getMessageWithDic:(MessageRLMModel *)model{

    
    SSChatMessage *message = [SSChatMessage new];
    
    SSChatMessageType messageType = (SSChatMessageType)model.msgType;
    message.sessionId    = model.roomNo;
    message.sendError    = NO;
    message.headerImgurl = model.contact.portraitUri;
    message.messageId    = model.chatId;
    message.textColor    = SSChatTextColor;
    message.messageType  = messageType;
    
    SSChatMessageFrom messageFrom = [model.contact.account isEqualToString:[KCUserDefaultManager getAccount]]?SSChatMessageFromMe:SSChatMessageFromOther;
    if(messageFrom == SSChatMessageFromMe){
        message.messageFrom = SSChatMessageFromMe;
        message.backImgString = @"icon_qipao1";
        message.headerImgurl=[KCUserDefaultManager getHeaderIconStr];
    }else{
        message.messageFrom = SSChatMessageFromOther;
        message.backImgString = @"icon_qipao2";
    }
    
    //判断时间是否展示
    message.messageTime =[NSString stringWithFormat:@"%ld",model.timeStamp]; //[NSTimer getChatTimeStr2:[NSTimer getStampWithTime:dic[@"date"]]]
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if(([user valueForKey:message.sessionId]==nil)||([[user valueForKey:message.sessionId] integerValue]==0)){
        [user setValue:@(model.timeStamp) forKey:message.sessionId];
        message.showTime = YES;
    }else{
        [message showTimeWithLastShowTime:[[user valueForKey:message.sessionId] longValue] currentTime:model.timeStamp];
        if(message.showTime){
         [user setValue:@(model.timeStamp) forKey:message.sessionId];
        }
    }

    //判断消息类型
    if(message.messageType == SSChatMessageTypeText){
        
        message.cellString   = SSChatTextCellId;
        message.textString = model.msg;
    }else if (message.messageType == SSChatMessageTypeImage){
        message.cellString   = SSChatImageCellId;
        message.textString  = model.msg;
        message.imageW=model.imageW;
        message.imageH=model.imageH;
    }else if (message.messageType == SSChatMessageTypeVoice){
        
        message.cellString   = SSChatVoiceCellId;
        message.voiceRemotePath = model.msg;
        message.voiceDuration = model.duration;
        message.textString=model.msg;
        message.voiceImg = [UIImage imageNamed:@"chat_animation_white3"];
        message.voiceImgs =
        @[[UIImage imageNamed:@"chat_animation_white1"],
          [UIImage imageNamed:@"chat_animation_white2"],
          [UIImage imageNamed:@"chat_animation_white3"]];
        
        if(messageFrom == SSChatMessageFromOther){

            message.voiceImg = [UIImage imageNamed:@"chat_animation3"];
            message.voiceImgs =
            @[[UIImage imageNamed:@"chat_animation1"],
              [UIImage imageNamed:@"chat_animation2"],
              [UIImage imageNamed:@"chat_animation3"]];
        }
        
    }else if (message.messageType == SSChatMessageTypeMap){
        message.cellString = SSChatMapCellId;
//        message.latitude = [dic[@"lat"] doubleValue];
//        message.longitude = [dic[@"lon"] doubleValue];
//        message.addressString = dic[@"address"];
        
    }else if (message.messageType == SSChatMessageTypeVideo){
        message.cellString = SSChatVideoCellId;
        message.textString = model.msg;
        NSString *path=[[KCFileManager getUserChatVideoDirectory] stringByAppendingPathComponent:model.msg];
        NSFileManager *filemanager= [NSFileManager defaultManager];
        if (![filemanager fileExistsAtPath:path]) {
            path=[KNSPHOTOURL(path.lastPathComponent) absoluteString];
        }
        message.videoImage = [UIImage getImage:path];
        message.imageW=model.imageW;
        message.imageH=model.imageH;
        
    }
    
    SSChatMessagelLayout *layout = [[SSChatMessagelLayout alloc]initWithMessage:message];
    return layout;
    
}




//发送一条消息
+(void)sendMessage:(NSDictionary *)dic roomModel:(RoomRLMModel *)RoomModel messageType:(SSChatMessageType)messageType messageBlock:(MessageBlock)messageBlock{
   
    SSChatMessage *message=[[SSChatMessage alloc] init];
    message.messageTime=[NSString stringWithFormat:@"%ld",[NSString getTimeStamp]];
    message.messageId = [NSString getMessageChatId];
    message.messageFrom = SSChatMessageFromMe;
    message.backImgString = @"icon_qipao1";
    message.sessionId    = RoomModel.roomNo;
    message.sendError    = NO;
    message.headerImgurl = [KCUserDefaultManager getHeaderIconStr];
    message.textColor    = SSChatTextColor;
    message.messageType  = messageType;
    
    long timeStamp=[NSString getTimeStamp];
    XLLog(@"%ld",timeStamp);
    //判断时间是否展示
    message.messageTime =[NSString stringWithFormat:@"%ld",timeStamp];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    id obj=[user valueForKey:message.sessionId];
    if(obj==nil){
        [user setValue:@(timeStamp) forKey:message.sessionId];
        message.showTime = YES;
    }else{
        [message showTimeWithLastShowTime:[obj longValue] currentTime:timeStamp];
        if(message.showTime){
            [user setValue:@(timeStamp) forKey:message.sessionId];
        }
    }
    
    switch (messageType) {
        case SSChatMessageTypeText:{
            message.cellString   = SSChatTextCellId;
            message.textString = dic[@"text"];
        }
            break;
        case SSChatMessageTypeImage:{
            message.cellString   = SSChatImageCellId;
            message.textString  = dic[@"text"];
            UIImage *image=[UIImage imageWithContentsOfFile:[[KCFileManager getUserChatIMGDirectory] stringByAppendingPathComponent:dic[@"text"]]];
            message.imageH=image.size.height;
            message.imageW=image.size.width;
        }
            break;
        case SSChatMessageTypeVoice:{
            message.cellString   = SSChatVoiceCellId;
            message.textString = dic[@"text"];
            message.voiceDuration=[dic[@"duration"] integerValue];
            message.voiceImg = [UIImage imageNamed:@"chat_animation_white3"];
            message.voiceImgs =
            @[[UIImage imageNamed:@"chat_animation_white1"],
              [UIImage imageNamed:@"chat_animation_white2"],
              [UIImage imageNamed:@"chat_animation_white3"]];
        }
            break;
        case SSChatMessageTypeMap:{
          
        }
            break;
        case SSChatMessageTypeVideo:{
            message.cellString = SSChatVideoCellId;
            message.textString = dic[@"text"];
            message.videoImage = [UIImage getImage:[[KCFileManager getUserChatVideoDirectory] stringByAppendingPathComponent:dic[@"text"]]];
            message.imageH=message.videoImage.size.height;
            message.imageW=message.videoImage.size.width;
        }
            break;
        case SSChatMessageTypePacket:{
            
        }
            break;
            
        default:
            break;
    }
    [KCTSendDataManager SendMessage:[KCTModelManager messageModelForModelSSChatModel:message andContact:[KCTRealmManager getSelfContact]] andRoom:RoomModel];
    SSChatMessagelLayout *layout = [[SSChatMessagelLayout alloc] initWithMessage:message];
    NSProgress *pre = [[NSProgress alloc]init];
    
    messageBlock(layout,nil,pre);
}


@end
