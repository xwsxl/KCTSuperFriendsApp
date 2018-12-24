//
//  KCTDownLoadManager.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/21.
//  Copyright © 2018年 Hawky. All rights reserved.
//

@interface KCTDownLoadModel : NSObject

@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,copy) void (^complete)(BOOL success,id obj);
@property (nonatomic,copy) void (^progress)(int64_t bytesWritten, int64_t totalBytesWritten);
@property (nonatomic,assign) BOOL isDownLoading;

@end
@implementation KCTDownLoadModel

@end
#import "KCTDownLoadManager.h"
@interface KCTDownLoadManager()

@property (nonatomic,strong)NSMutableArray *downLoadAudioQueue;

@end
@implementation KCTDownLoadManager

#pragma mark - Public
+ (KCTDownLoadManager *)sharedInstance {
    static KCTDownLoadManager  *g_sharedInstance = nil;
    static dispatch_once_t pre = 0;
    dispatch_once(&pre, ^{
        g_sharedInstance = [[KCTDownLoadManager alloc] init];
    });
    
    return g_sharedInstance;
}
//下载聊天语音
- (void)downLoadAudioWithRequestUrl:(NSString *)requestUrl complete:(void (^)(BOOL success,id obj))complete progress:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten))progress{
    
   [self _downLoadFileWithRequestUrl:requestUrl downLoadQueue:self.downLoadAudioQueue saveInDir:[KCFileManager getUserChatAudioDirectory] saveFileName:nil maxConcurrentCount:3 complete:complete progress:progress];
}
//下载聊天视频
- (void)downLoadVideoWithRequestUrl:(NSString *)requestUrl complete:(void (^)(BOOL success,id obj))complete progress:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten))progress{
    
    [self _downLoadFileWithRequestUrl:requestUrl downLoadQueue:self.downLoadAudioQueue saveInDir:[KCFileManager getUserChatVideoDirectory] saveFileName:nil maxConcurrentCount:3 complete:complete progress:progress];
}
#pragma mark - Private

- (void)_downLoadFileWithRequestUrl:(NSString *)requestUrl downLoadQueue:(NSMutableArray *)downLoadQueue saveInDir:(NSString *)saveInDir saveFileName:(NSString *)saveFileName maxConcurrentCount:(int)maxConcurrentCount complete:(void (^)(BOOL success,id obj))complete progress:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten))progress{
    
    
    if (!saveInDir) {
        progress(0,0);
        complete(NO,@"please choose dir to downLoad file");
        return;
    }
    
    NSString *fileName = [requestUrl lastPathComponent];
    if (saveFileName) {
        fileName = saveFileName;
    }
    
    NSString *saveFilePath = [saveInDir stringByAppendingPathComponent:fileName];
    
    //任务已经存在下载队列中
    BOOL taskInDownLoadQueue = NO;
    for (KCTDownLoadModel *model in downLoadQueue) {
        if ([model.filePath isEqualToString:saveFilePath]) {
            taskInDownLoadQueue = YES;
            break;
        }
    }
    
    //任务不在下载队列中
    if(!taskInDownLoadQueue){
        KCTDownLoadModel *model = [KCTDownLoadModel new];
        model.filePath = saveFilePath;
        model.complete = complete;
        model.progress = progress;
        [downLoadQueue addObject:model];
        
        if (downLoadQueue.count <= maxConcurrentCount) {
            model.isDownLoading = YES;
            
            [self _doDownLoadWithRequestUrl:requestUrl model:model maxConcurrentCount:maxConcurrentCount downloadQueue:downLoadQueue saveInDir:saveInDir saveFileName:saveFileName complete:complete progress:progress];
            
        }
        
        
    }
    
}


- (void)_doDownLoadWithRequestUrl:(NSString *)requestUrl model:(KCTDownLoadModel *)model maxConcurrentCount:(int)maxConcurrentCount downloadQueue:( NSMutableArray *)downloadQueue saveInDir:(NSString *)saveInDir saveFileName:(NSString *)saveFileName complete:(void (^)(BOOL success,id obj))complete progress:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten))progress{
    
    WeakSelf
   // [KCNetWorkManager ];
    [KCNetWorkManager downLoadWithRequestUrl:requestUrl saveInDir:saveInDir saveFileName:saveFileName complete:^(BOOL success, id obj) {
        complete(success,obj);

        model.isDownLoading = NO;
        [downloadQueue removeObject:model];

        KCTDownLoadModel *lastModel = downloadQueue.lastObject;
        if (lastModel) {
            if (!lastModel.isDownLoading) {

                [weakSelf _downLoadFileWithRequestUrl:requestUrl downLoadQueue:downloadQueue saveInDir:saveInDir saveFileName:saveFileName maxConcurrentCount:maxConcurrentCount complete:lastModel.complete progress:lastModel.progress];
            }
        }

    } progress:^(NSProgress *downloadProgress) {
        if (model.progress) {
            XLLog(@"任务：%@,进度：%lld--%lld",[model.filePath lastPathComponent],downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            model.progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }

    }];
}
#pragma mark - Lazy Load

- (NSMutableArray *)downLoadAudioQueue{
    if (!_downLoadAudioQueue) {
        _downLoadAudioQueue = [NSMutableArray new];
    }
    return _downLoadAudioQueue;
}
@end
