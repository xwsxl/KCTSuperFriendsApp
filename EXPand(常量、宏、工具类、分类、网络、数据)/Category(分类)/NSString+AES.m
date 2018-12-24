//
//  NSString+AES.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
static NSString *const PSW_AES_KEY = @"TESTPASSWORD";
static NSString *const AES_IV_PARAMETER = @"AES00IVPARAMETER";
@implementation NSString (AES)
- (NSString*)aci_encryptWithAES {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:[KCUserDefaultManager getSigen]
                                         iv:AES_IV_PARAMETER];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    XLLog(@"*****************\niOSCode:%@\n*****************", baseStr);
    return baseStr;
}

- (NSString*)aci_decryptWithAES {
    
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:[KCUserDefaultManager getSigen]
                                         iv:AES_IV_PARAMETER];
    
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
    XLLog(@"*****************\niOSCode:%@\n*****************", decStr);
    
    return decStr;
}
/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    
    char keyPtr[kCCKeySizeAES128 + 1];  //kCCKeySizeAES128是加密位数 可以替换成256位的
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // 设置加密参数
    //（根据需求选择什么加密位数128or256，PKCS7Padding补码方式之类的_(:з」∠)_，详细的看下面吧）
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        XLLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        XLLog(@"Error");
    }
    
    free(buffer);
    return nil;
}

@end
