//
//  NSData+Category.h
//  IOSProgrammingFramework
//
//  Created by Li,Quangang on 2018/6/28.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Category)

#pragma mark - md5

/**
 对data进行MD5加密
 
 @return 加密后的字符串
 */
- (NSString *)md5;

@end
