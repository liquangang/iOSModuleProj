//
//  UIFont+Category.h
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/9/18.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Category)

/**
 *  根据不同屏幕返回不同字体
 */
+ (CGFloat)getScaleFontSize:(CGFloat)standardFont;

@end
