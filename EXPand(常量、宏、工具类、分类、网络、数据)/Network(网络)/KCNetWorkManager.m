//
//  KCNetWorkManager.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/25.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCNetWorkManager.h"
#import "MJExtension.h"
#import <QiniuSDK.h>
#import "MBProgressHUD+XL.h"
@interface KCNetWorkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *MyManager;

@end


@implementation KCNetWorkManager

/**
 封装了POST请求
 
 @param urlString 接口地址
 @param params 参数
 @param success 成功回调
 @param faild 失败的回调
 */
+(void)POST:(NSString *)urlString WithParams:(id)params ForSuccess:(SuccessBlock)success AndFaild:(FaildBlock)faild
{

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"image/jpeg",@"text/html",@"image/png", nil];
    manager.requestSerializer.timeoutInterval=30;
    if ([KCUserDefaultManager getLoginStatus]) {
        NSString *value = [KCUserDefaultManager getSigen];
        [manager.requestSerializer setValue:value forHTTPHeaderField:@"authorization"];
    }
    MBProgressHUD *hud=[MBProgressHUD showActivityMessage:@""];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonString=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData= [[NSData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        XLLog(@"url=%@\nparams=%@\nresponseObject=%@",urlString,[params mj_JSONString],[result mj_JSONString]);
        if ([result isKindOfClass:NSClassFromString(@"__NSCFArray")]||[result isKindOfClass:NSClassFromString(@"__NSArrayM")]) {
            NSDictionary *response=[result lastObject];
            success(response);
        }else
        {
            success(result);
        }
        [hud hideAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XLLog(@"url=%@\nparams=%@\nerror=%@",urlString,[params mj_JSONString],error.localizedDescription);
        faild(error);
        [hud hideAnimated:YES];
    }];
}




/**
 封装数据流请求
 
 @param urlString 接口地址
 @param params 参数
 @param view 加载视图
 @param block 数据流
 @param success 成功回调
 @param faild 失败回调
 */
+(void)POSTFile:(NSString *)urlString WithParams:(id)params AndView:(UIView *)view constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block ForSuccess:(SuccessBlock)success AndFaild:(FaildBlock)faild
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"image/jpeg",@"text/html",@"image/png", nil];
    manager.requestSerializer.timeoutInterval=30;
    if ([KCUserDefaultManager getLoginStatus]) {
        NSString *value = [KCUserDefaultManager getSigen];
        [manager.requestSerializer setValue:value forHTTPHeaderField:@"authorization"];
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    [manager POST:urlString parameters:params constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        NSString *jsonString=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData= [[NSData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        XLLog(@"url=%@\nparams=%@\nresponseObject=%@",urlString,[params mj_JSONString],[result mj_JSONString]);
        if ([result isKindOfClass:NSClassFromString(@"__NSCFArray")]||[result isKindOfClass:NSClassFromString(@"__NSArrayM")]) {
            NSDictionary *response=[result lastObject];
            success(response);
        }else
        {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        XLLog(@"url=%@\nparams=%@\nerror=%@",urlString,[params mj_JSONString],error.localizedDescription);
        faild(error);
    }];
}

/**
 封装了POST请求
 
 @param urlString 接口地址
 @param params 参数
 @param success 成功回调
 @param faild 失败的回调
 */
+(void)Get:(NSString *)urlString WithParams:(id)params ForSuccess:(SuccessBlock)success AndFaild:(FaildBlock)faild
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"image/jpeg",@"text/html",@"image/png", nil];
    manager.requestSerializer.timeoutInterval=30;
    if ([KCUserDefaultManager getLoginStatus]) {
        NSString *value = [KCUserDefaultManager getSigen];
        [manager.requestSerializer setValue:value forHTTPHeaderField:@"authorization"];
    }
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        XLLog(@"url=%@\nparams=%@\nuploadProgress=%@",urlString,[params mj_JSONString],uploadProgress.localizedDescription);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonString=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData= [[NSData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        XLLog(@"url=%@\nparams=%@\nresponseObject=%@",urlString,[params mj_JSONString],[result mj_JSONString]);
        if ([result isKindOfClass:NSClassFromString(@"__NSCFArray")]||[result isKindOfClass:NSClassFromString(@"__NSArrayM")]) {
            NSDictionary *response=[result lastObject];
            success(response);
        }else
        {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XLLog(@"url=%@\nparams=%@\nerror=%@",urlString,[params mj_JSONString],error.localizedDescription);
        faild(error);
    }];
    
}


//下载请求
+ (void)downLoadWithRequestUrl:(NSString *)requestUrl saveInDir:(NSString *)saveInDir saveFileName:(NSString *)saveFileName complete:(NetManagerCallback)complete progress:(void(^)(NSProgress *downloadProgress))progress{
    
    
    //url
    NSURL *url  = [NSURL URLWithString:requestUrl];
    
    if (!saveInDir) {
        complete(NO,@"please choose dir to downLoad file");
        progress([NSProgress new]);
        return;
    }
    
    //判断是否有缓存
    NSString *fileName = [url lastPathComponent];
    if (saveFileName) {
        fileName = saveFileName;
    }
    
    NSString *cacheFilePath = [saveInDir stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:cacheFilePath]) {
        XLLog(@"打开缓存文件:\n%@",cacheFilePath);
        progress([NSProgress new]);
        complete(YES,cacheFilePath);
        return;
    }
    
    //没有缓存就下载
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
        
    }destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *fileDir      = [NSURL fileURLWithPath:saveInDir];
        NSString *aFileName = [response suggestedFilename];
        if (saveFileName) {
            aFileName = saveFileName;
        }
        NSURL *fileUrl = [fileDir URLByAppendingPathComponent:aFileName];
        return fileUrl;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSString *path = [filePath relativePath];
        XLLog(@"下载文件到:\n%@", path);
        if (error) {
            complete(NO,error);
        }else{
            
            NSDictionary *attributes = [fm attributesOfItemAtPath:path error:nil];
            NSNumber *theFileSize = [attributes objectForKey:NSFileSize];
            if ([theFileSize floatValue] == 0) {
                //移除容量大小为0的文件
                [fm removeItemAtPath:path error:nil];
                NSString *errMsg = @"下载文件大小为0,文件即将移除";
                XLLog(@"%@",errMsg);
                NSDictionary *dict = @{@"error":errMsg,
                                       @"code":@(-999)};
                complete(NO,dict);
            }else{
                complete(YES,[filePath relativePath]);
            }
            
        }
        
    }];
    [downloadTask resume];
    
    
}


+(void)QNUploadFile:(NSString *)filePath Withkey:(NSString *)key ForSuccess:(completeBlock)complete AndFaild:(FaildBlock)faild
{
    [KCNetWorkManager Get: KNSSTR(@"qiNiuController/uploadToken") WithParams:@{} ForSuccess:^(NSDictionary * _Nonnull response) {
        if (response[@"success"]) {
            QNUploadManager *upManager=[[QNUploadManager alloc] init];
            NSString *token = response[@"data"][@"uptoken"];
            [upManager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                XLLog(@"info=%@,key=%@,resp=%@",info,key,resp);
                complete(info,key,resp);
            } option:nil];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        faild(error);
    }];
    
}

/**
 封装了POST请求
 
 @param urlString 接口地址
 @param params 参数
 @param success 成功回调
 @param faild 失败的回调
 */
+(void)POSTBDVoice:(NSString *)urlString WithParams:(id)params voiceData:(NSData *)data ForSuccess:(SuccessBlock)success AndFaild:(FaildBlock)faild
{
    NSString *requestUrl =[NSString stringWithFormat:@"http://vop.baidu.com/server_api?cuid=%@&dev_pid=1537&token=%@",[params objectForKey:@"cuid"],[params objectForKey:@"token"]];
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
    if ([KCUserDefaultManager getLoginStatus]) {
        NSString *value = [KCUserDefaultManager getSigen];
        [manager.requestSerializer setValue:value forHTTPHeaderField:@"authorization"];
    }
    request.timeoutInterval= 15.0;
    [request setValue:@"audio/wav;rate=16000" forHTTPHeaderField:@"Content-Type"];
    
    // 设置body
    [request setHTTPBody:data];
    
    [MBProgressHUD showActivityMessage:@""];
    XLLog(@"params=%@,url=%@",params,request);
    [[manager.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *str2=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *data1 = [[NSData alloc] initWithData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
        id result = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        XLLog(@"request=%@\nparams=%@\nresponseObject=%@",requestUrl,[params mj_JSONString],[result mj_JSONString]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            NSMutableDictionary *Mdic=[NSMutableDictionary dictionary];
            if ([result isKindOfClass:NSClassFromString(@"__NSCFArray")]||[result isKindOfClass:NSClassFromString(@"__NSArrayM")]) {
                NSDictionary *response=[result lastObject];
                [Mdic setValuesForKeysWithDictionary:response];
                
            }else
            {
                [Mdic setValuesForKeysWithDictionary:result];
            }
            if ([Mdic[@"err_no"] integerValue]==0) {
                success(Mdic);
            }else
            {
                NSDictionary *msgDic=@{@"3300":@"输入参数不正确",@"3301":@"音频质量过差",@"3302":@"鉴权失败",@"3303":@"转pcm失败",@"3304":@"用户的请求QPS超限",@"3305":@"用户的日pv（日请求量）超限",@"3306":@"语音服务器后端识别出错问题",@"3307":@"语音服务器后端识别出错问题",@"3308":@"音频过长",@"3309":@"音频数据问题",@"3310":@"输入的音频文件过大",@"3311":@"采样率rate参数不在选项里",@"3312":@"音频格式format参数不在选项里"};
                NSString *msgNo=[NSString stringWithFormat:@"%@",Mdic[@"err_no"]];
                [MBProgressHUD showMessage:msgDic[msgNo]];
            }
        });
       
    }] resume];
    
}
@end
