//
//  UIApplication+Category.h
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/10/26.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Category)

/**
 *  获取相册权限
 */
- (void)getPhotoAuthority:(void(^)(BOOL isCanUse))completed;

/**
 *  获取相机权限
 */
- (void)getCameraAuthority:(void(^)(BOOL isCanUse))completed;

/**
 *  获取通讯录权限
 */
- (void)getAddressBookAuthority:(void(^)(BOOL isCanUse))completed;

@end
