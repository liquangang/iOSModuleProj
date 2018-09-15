//
//  NSString+Category.h
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/11/3.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionHandlerWithHandleString)(NSString *string);

@interface NSString (Category)

/**
 格式化时间
 
 @param second 秒数
 @return 格式化字符串
 */
+ (NSString *)convertTime:(CGFloat)second;

/**
 获取当前时间

 @param timeFormat 时间格式字符串 例子：YYYY-MM-dd HH:mm:ss
 @return 当前时间字符串
 */
+ (NSString *)getCurrentTime:(NSString *)timeFormat;

/**
 获取时间间隔天数
 
 @param timeStr 初始时间字符串
 @return 间隔天数
 */
+ (NSInteger)getTimeIntervalDayNum:(NSString *)timeStr;

/**
 获取网络时间

 @param completionHandler 回调block
 */
+ (void)getInternetDate:(CompletionHandlerWithHandleString)completionHandler;

#pragma mark - MD5

/**
 对字符串进行md5加密
 
 @return 加密后的字符串
 */
- (NSString *)md5;

@end
