//
//  QGIOSThreadManager.h
//  QGIOSThreadManager
//
//  Created by Li,Quangang on 2018/8/24.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^Completionhandler)(void); //默认无参数无返回值处理block

@interface QGIOSThreadManager : NSObject

/**
 主线程执行代码
 
 @param completionhandler 主线程block
 */
void asyncRunOnMainQueue(Completionhandler completionhandler);

/**
 后台线程执行事件
 
 @param completionhandler 事件block
 */
void asyncRunOnBackgroundQueue(Completionhandler completionhandler);

/**
 主线程延时执行事件
 
 @param seconds 延时时长
 @param completionhandler 事件block
 */
void asyncRunOnMainQueueAfterDelay(CGFloat seconds, Completionhandler completionhandler);

/**
 后台线程线程延时执行事件
 
 @param seconds 延时时长
 @param completionhandler 事件block
 */
void asyncRunOnBackgroundQueueAfterDelay(CGFloat seconds, Completionhandler completionhandler);

@end
