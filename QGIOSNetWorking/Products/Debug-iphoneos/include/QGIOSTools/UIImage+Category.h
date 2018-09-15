//
//  UIImage+Category.h
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/7/27.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawModel.h"


@interface UIImage (Category)

/**
 *  获取图片文件类型
 */
- (NSString *)imageFileType;

/**
 *  根据颜色和大小生成一张纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;

/**
 根据view的内容绘制图片
 
 @param view view对象
 @return 绘制出来的图片
 */
+ (UIImage *)drawImageWithView:(UIView *)view;

/**
 根据model绘制内容

 @param drawModels 所有需要绘制的model
 @param backgroundSize 背景size
 @param backgroundColor 背景颜色
 @return 绘制后的图片
 */
+ (UIImage *)drawImageWithDrawModels:(NSArray<DrawModel *> *)drawModels backgroundSize:(CGSize)backgroundSize backgroundColor:(UIColor *)backgroundColor;

/**
 获取圆形图片
 
 @param originalImage 原图
 @param contentMode 填充方式
 @param rect rect
 @return 处理后的图片
 */
+ (UIImage *)RoundImageWithOriginalImage:(UIImage *)originalImage contentMode:(UIViewContentMode)contentMode rect:(CGRect)rect;

@end
