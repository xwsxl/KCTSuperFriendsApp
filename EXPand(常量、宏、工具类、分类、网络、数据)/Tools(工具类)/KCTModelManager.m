//
//  KCTModelManager.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/26.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTModelManager.h"
#import "YYKit.h"
@implementation KCTModelManager


+(MessageRLMModel *)messageModelForModelSSChatModel:(SSChatMessage *)model andContact:(ContactRLMModel *)Cmodel;
{
    MessageRLMModel *Mmodel=[[MessageRLMModel alloc] init];
    Mmodel.roomNo=model.sessionId;
    Mmodel.contact=Cmodel;
    Mmodel.chatId=model.messageId;
    Mmodel.msgType=model.messageType;
    Mmodel.msg=model.textString;
    Mmodel.duration=model.voiceDuration;
    Mmodel.timeStamp=[model.messageTime longValue];
    Mmodel.imageW=model.imageW;
    Mmodel.imageH=model.imageH;
    return Mmodel;
}
@end
