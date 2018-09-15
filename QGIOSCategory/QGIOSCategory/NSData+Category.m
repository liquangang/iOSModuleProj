//
//  NSData+Category.m
//  IOSProgrammingFramework
//
//  Created by Li,Quangang on 2018/6/28.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import "NSData+Category.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (Category)

#pragma mark - md5加密

/**
 对data进行MD5加密

 @return 加密后的字符串
 */
- (NSString *)md5{
    //1: 创建一个MD5对象
    CC_MD5_CTX md5;
    //2: 初始化MD5
    CC_MD5_Init(&md5);
    //3: 准备MD5加密
    CC_MD5_Update(&md5, self.bytes, (CC_LONG)self.length);
    //4: 准备一个字符串数组, 存储MD5加密之后的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //5: 结束MD5加密
    CC_MD5_Final(result, &md5);
    NSMutableString *resultString = [NSMutableString string];
    //6:从result数组中获取最终结果
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X", result[i]];
    }
    return resultString;
}

@end
