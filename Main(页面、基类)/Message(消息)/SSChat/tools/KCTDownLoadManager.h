//
//  KCTDownLoadManager.h
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/21.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCTDownLoadManager : NSObject

+ (KCTDownLoadManager *)sharedInstance;
/*
 *  下载聊天语音 (文件方式保存)  若下载过,会从加载缓存
 *  @param requestUrl       后台返回的Url
 *  @param progress         下载进度
 *  @param complete         成功失败回调
 */
- (void)downLoadAudioWithRequestUrl:(NSString *)requestUrl complete:(void (^)(BOOL success,id obj))complete progress:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten))progress;

/*
 *  下载聊天视频 (文件方式保存)  若下载过,会从加载缓存
 *  @param requestUrl       后台返回的Url
 *  @param progress         下载进度
 *  @param complete         成功失败回调
 */
- (void)downLoadVideoWithRequestUrl:(NSString *)requestUrl complete:(void (^)(BOOL success,id obj))complete progress:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten))progress;

@end
