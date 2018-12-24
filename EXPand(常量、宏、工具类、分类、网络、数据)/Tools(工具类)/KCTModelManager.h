//
//  KCTModelManager.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/26.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageRLMModel.h"
#import "SSChatMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface KCTModelManager : NSObject


+(MessageRLMModel *)messageModelForModelSSChatModel:(SSChatMessage *)model andContact:(ContactRLMModel *)Cmodel;

@end

NS_ASSUME_NONNULL_END
