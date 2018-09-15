//
//  QGIOSThreadManager.m
//  QGIOSThreadManager
//
//  Created by Li,Quangang on 2018/8/24.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import "QGIOSThreadManager.h"

@implementation QGIOSThreadManager

#pragma mark - c方式GCD封装

/**
 主线程执行代码
 
 @param completionhandler 主线程block
 */
void asyncRunOnMainQueue(Completionhandler completionhandler){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completionhandler ? completionhandler() : nil;
    });
}

/**
 后台线程执行事件
 
 @param completionhandler 事件block
 */
void asyncRunOnBackgroundQueue(Completionhandler completionhandler){
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        completionhandler ? completionhandler() : nil;
    });
    
}

/**
 主线程延时执行事件
 
 @param seconds 延时时长
 @param completionhandler 事件block
 */
void asyncRunOnMainQueueAfterDelay(CGFloat seconds, Completionhandler completionhandler){
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completionhandler ? completionhandler() : nil;
    });
    
}

/**
 后台线程线程延时执行事件
 
 @param seconds 延时时长
 @param completionhandler 事件block
 */
void asyncRunOnBackgroundQueueAfterDelay(CGFloat seconds, Completionhandler completionhandler){
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        completionhandler ? completionhandler() : nil;
    });
    
}

@end
