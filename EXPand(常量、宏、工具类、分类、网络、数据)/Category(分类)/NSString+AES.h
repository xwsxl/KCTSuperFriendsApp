//
//  NSString+AES.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AES)
/**< 加密方法 */
- (NSString*)aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)aci_decryptWithAES;

@end

NS_ASSUME_NONNULL_END
