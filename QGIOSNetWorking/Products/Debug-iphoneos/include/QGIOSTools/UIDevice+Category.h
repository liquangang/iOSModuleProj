//
//  UIDevice+Category.h
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/9/18.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface UIDevice (Category)

/**
 获取手机类型
 
 @return 手机类型字符串
 */
- (NSString *)iphoneType;

/**
 获取appedges
 
 @return appedges
 */
- (UIEdgeInsets)iphoneSafeAreaInsets;

@end
