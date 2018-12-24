//
//  KCFileManager.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/31.
//  Copyright © 2018年 Hawky. All rights reserved.
//
#import "KCFileManager.h"
@implementation KCFileManager

/* ****  获取用户文件路径  **** */
+(NSString *)getUserDirectory
{
    NSString *documentsDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[documentsDir stringByAppendingPathComponent:[KCUserDefaultManager getAccount]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return  path;
    
}
/* ****  获取用户聊天文件路径  **** */
+(NSString *)getUserChatDirectory
{
    NSString *path=[[self getUserDirectory] stringByAppendingPathComponent:@"Chat"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
/* ****  获取用户聊天音频路径  **** */
+(NSString *)getUserChatAudioDirectory
{
    NSString *path=[[self getUserChatDirectory] stringByAppendingPathComponent:@"Audio"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
/* ****  获取用户聊天视频路径  **** */
+(NSString *)getUserChatVideoDirectory
{
    NSString *path=[[self getUserChatDirectory] stringByAppendingPathComponent:@"Video"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
/* ****  获取用户聊天GIf图片路径  **** */
+(NSString *)getUserChatGifDirectory
{
    NSString *path=[[self getUserChatDirectory] stringByAppendingPathComponent:@"Gif"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/* ****  获取用户聊天图片路径  **** */
+(NSString *)getUserChatIMGDirectory
{
    NSString *path=[[self getUserChatDirectory] stringByAppendingPathComponent:@"Img"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


+(NSString*)saveImageAndVido:(NSData*)data{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * imgptch = [[self getUserChatIMGDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.jpeg",[NSString getTimeStamp]]];
    BOOL rs=[fileManager createFileAtPath:imgptch contents:data attributes:nil];
    while (!rs) {
       rs=[fileManager createFileAtPath:imgptch contents:data attributes:nil];
    }
    return imgptch;
}


+(void)removeFileFromPath:(NSString *)path
{
    NSFileManager *filemanager=[NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:path]) {
        [filemanager removeItemAtPath:path error:nil];
    }
}

+ (NSString *) getAndCreatePlayableFileFromPcmData:(NSString *)filePath
{
    NSString *wavFilePath = [filePath stringByReplacingOccurrencesOfString:@".lpcm" withString:@".wav"];  //wav文件的路径
    XLLog(@"PCM file path : %@",filePath); //pcm文件的路径
    FILE *fout;
    short NumChannels = 1;       //录音通道数
    short BitsPerSample = 16;    //线性采样位数
    int SamplingRate = 16000;     //录音采样率(Hz)
    int numOfSamples = (int)[[NSData dataWithContentsOfFile:filePath] length];
    int ByteRate = NumChannels*BitsPerSample*SamplingRate/8;
    short BlockAlign = NumChannels*BitsPerSample/8;
    int DataSize = NumChannels*numOfSamples*BitsPerSample/8;
    int chunkSize = 16;
    int totalSize = 46 + DataSize;
    short audioFormat = 1;
    if((fout = fopen([wavFilePath cStringUsingEncoding:1], "w")) == NULL)
    {
        printf("Error opening out file ");
    }
    fwrite("RIFF", sizeof(char), 4,fout);
    fwrite(&totalSize, sizeof(int), 1, fout);
    fwrite("WAVE", sizeof(char), 4, fout);
    fwrite("fmt ", sizeof(char), 4, fout);
    fwrite(&chunkSize, sizeof(int),1,fout);
    fwrite(&audioFormat, sizeof(short), 1, fout);
    fwrite(&NumChannels, sizeof(short),1,fout);
    fwrite(&SamplingRate, sizeof(int), 1, fout);
    fwrite(&ByteRate, sizeof(int), 1, fout);
    fwrite(&BlockAlign, sizeof(short), 1, fout);
    fwrite(&BitsPerSample, sizeof(short), 1, fout);
    fwrite("data", sizeof(char), 4, fout);
    fwrite(&DataSize, sizeof(int), 1, fout);
    fclose(fout);
    NSMutableData *pamdata = [NSMutableData dataWithContentsOfFile:filePath];
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForUpdatingAtPath:wavFilePath];
    [handle seekToEndOfFile];
    [handle writeData:pamdata];
    [handle closeFile];
    [KCFileManager removeFileFromPath:filePath];
    return wavFilePath;
}
/* ****  存储第一次的录音文件路径  **** */
+(NSString *)getVoicePasswordPath
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *path=[userDefaults stringForKey:@"path"];
    [userDefaults synchronize];
    return path;
}
+(void)saveVoicePasswordPath:(NSString *)path
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:path forKey:@"path"];
    [userDefaults synchronize];
}
@end
