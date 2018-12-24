//
//  KCFileManager.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/31.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCFileManager : NSObject
/* ****  获取用户文件路径  **** */
+(NSString *)getUserDirectory;
/* ****  获取用户聊天文件路径  **** */
+(NSString *)getUserChatDirectory;
/* ****  获取用户聊天音频路径  **** */
+(NSString *)getUserChatAudioDirectory;
/* ****  获取用户聊天视频路径  **** */
+(NSString *)getUserChatVideoDirectory;
/* ****  获取用户聊天GIf图片路径  **** */
+(NSString *)getUserChatGifDirectory;
/* ****  获取用户聊天图片路径  **** */
+(NSString *)getUserChatIMGDirectory;




+(NSString*)saveImageAndVido:(NSData*)data;

+(void)removeFileFromPath:(NSString *)path;

/* ****  存储第一次的录音文件路径  **** */
+(NSString *)getVoicePasswordPath;
+(void)saveVoicePasswordPath:(NSString *)path;

/* ****  pcm文件转换为wav文件  **** */
+(NSString *) getAndCreatePlayableFileFromPcmData:(NSString *)filePath;



@end

NS_ASSUME_NONNULL_END
