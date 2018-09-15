//
//  NSString+Category.m
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/11/3.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Category.h"

@implementation NSString (Category)

/**
 格式化时间
 
 @param second 秒数
 @return 格式化字符串
 */
+ (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

//获取当地时间 格式：YYYY-MM-dd HH:mm:ss
+ (NSString *)getCurrentTime:(NSString *)timeFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:timeFormat];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

/**
 获取时间间隔天数
 
 @param timeStr 初始时间字符串
 @return 间隔天数
 */
+ (NSInteger)getTimeIntervalDayNum:(NSString *)timeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:timeStr];
    //八小时时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:timeDate];
    NSDate *mydate = [timeDate dateByAddingTimeInterval:interval];
    NSDate *nowDate = [[NSDate date]dateByAddingTimeInterval:interval];
    //两个时间间隔
    NSTimeInterval timeInterval = [mydate timeIntervalSinceDate:nowDate];
    timeInterval = -timeInterval;
    return (NSInteger)timeInterval/(24*60*60);
}

/**
 获取网络时间
 */
+ (void)getInternetDate:(CompletionHandlerWithHandleString)completionHandler
{
    void(^HandleBlock)(NSURLResponse *response) = ^(NSURLResponse *response){
        NSString *date = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Date"];
        date = [date substringFromIndex:5];
        date = [date substringToIndex:[date length]-4];
        NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
        dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
        NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
        NSDate *localeDate = [netDate  dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:netDate]];
        dMatter.dateFormat = @"YYYY-MM-dd";
        NSString *netTimeStr = [dMatter stringFromDate:localeDate];
        completionHandler ? completionHandler(netTimeStr) : nil;
    };
    
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://m.baidu.com"]
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             HandleBlock(response);
                                                         }];
    
    // 启动任务
    [task resume];
}

#pragma mark - MD5

/**
 对字符串进行md5加密

 @return 加密后的字符串
 */
- (NSString *)md5 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data md5];
}

@end
