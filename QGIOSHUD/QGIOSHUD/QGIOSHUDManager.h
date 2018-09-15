//
//  QGIOSHUDManager.h
//  QGIOSHUDManager
//
//  Created by Li,Quangang on 2018/8/28.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef void(^Completionhandler)(void); //默认无参数无返回值处理block

@interface QGIOSHUDManager : NSObject

/**
 显示toast提示
 
 @param toastText 提示文案
 */
void showToast(NSString *toastText);

/**
 默认简单的alert方法
 
 @param title 标题
 @param message 中间的展示描述
 @param firstButtonTitle 第一个按钮的文案
 @param secondButtonTitle 第二个按钮的文案
 @param completionHandler1 第一个按钮的回调
 @param completionHandler2 第二个按钮的回调
 */
void showAlert(NSString *title, NSString *message, NSString *firstButtonTitle, NSString *secondButtonTitle, Completionhandler completionHandler1, Completionhandler completionHandler2);

/**
 默认简单的ActionSheet方法
 
 @param title 标题
 @param message 中间的展示描述
 @param firstButtonTitle 第一个按钮的文案
 @param secondButtonTitle 第二个按钮的文案
 @param completionHandler1 第一个按钮的回调
 @param completionHandler2 第二个按钮的回调
 */
void showActionSheet(NSString *title, NSString *message, NSString *firstButtonTitle, NSString *secondButtonTitle, Completionhandler completionHandler1, Completionhandler completionHandler2);

/**
 显示菊花
 
 @param superView 显示的view（默认放在alertWindow上）
 @param text 显示文案
 @param afterDelaySeconds 消失时间（默认15s）
 */
void showHUD(UIView *superView, NSString *text, CGFloat afterDelaySeconds);

/**
 隐藏菊花
 */
void hiddenHUD(void);

@end
