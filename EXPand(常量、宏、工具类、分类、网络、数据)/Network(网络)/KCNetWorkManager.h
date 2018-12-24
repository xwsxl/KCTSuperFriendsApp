//
//  KCNetWorkManager.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/25.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class QNResponseInfo;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessBlock)(NSDictionary *response);
typedef void(^FaildBlock)(NSError *error);
typedef void(^completeBlock)(QNResponseInfo *info, NSString *key, NSDictionary *resp);

typedef void(^NetManagerCallback)(BOOL success, id obj);

@interface KCNetWorkManager : NSObject
/**
 封装了POST请求
 
 @param urlString 接口地址 
 @param params 参数
 @param success 成功回调
 @param faild 失败的回调
 */
+(void)POST:(NSString *)urlString WithParams:(id)params ForSuccess:(SuccessBlock)success AndFaild:(FaildBlock)faild;

/**
 封装数据流请求
 
 @param urlString 接口地址
 @param params 参数
 @param view 加载视图
 @param block 数据流
 @param success 成功回调
 @param faild 失败回调
 */
+(void)POSTFile:(NSString *)urlString WithParams:(id)params AndView:(UIView *)view constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block ForSuccess:(SuccessBlock)success AndFaild:(FaildBlock)faild;
/**
 封装了POST请求
 
 @param urlString 接口地址
 @param params 参数
 @param success 成功回调
 @param faild 失败的回调
 */
+(void)Get:(NSString *)urlString WithParams:(id)params ForSuccess:(SuccessBlock)success AndFaild:(FaildBlock)faild;

/**
 下载文件

 @param requestUrl <#requestUrl description#>
 @param saveInDir <#saveInDir description#>
 @param saveFileName <#saveFileName description#>
 @param complete <#complete description#>
 @param progress <#progress description#>
 */
+ (void)downLoadWithRequestUrl:(NSString *)requestUrl saveInDir:(NSString *)saveInDir saveFileName:(NSString *)saveFileName complete:(NetManagerCallback)complete progress:(void(^)(NSProgress *downloadProgress))progress;
/**
 上传数据到七nl牛云

 @param filePath <#image description#>
 @param complete <#complete description#>
 */
+(void)QNUploadFile:(NSString *)filePath Withkey:(NSString *)key ForSuccess:(completeBlock)complete AndFaild:(FaildBlock)faild;
/**
 封装了BD语音识别POST请求
 
 @param urlString 接口地址
 @param params 参数
 @param success 成功回调
 @param faild 失败的回调
 */
+(void)POSTBDVoice:(NSString *)urlString WithParams:(id)params voiceData:(NSData *)data ForSuccess:(SuccessBlock)success AndFaild:(FaildBlock)faild;

@end

NS_ASSUME_NONNULL_END
