//
//  UIImage+Category.m
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/7/27.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "UIImage+Category.h"
#import <objc/message.h>

@implementation UIImage (Category)

/**
 *  获取图片文件类型(根据图片是否能转成data判断)
 */
- (NSString *)imageFileType{
    
    if (UIImagePNGRepresentation(self) != nil) {
        return @"png";
    } else if(UIImageJPEGRepresentation(self, 1.0f) != nil){
        return @"jpg";
    }else{
        return @"png";
    }
}

/**
 *  根据颜色和大小生成一张纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 根据view的内容绘制图片
 
 @param view view对象
 @return 绘制出来的图片
 */
+ (UIImage *)drawImageWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 根据model绘制内容
 
 @param drawModels 所有需要绘制的model
 @param backgroundSize 背景size
 @param backgroundColor 背景颜色
 @return 绘制后的图片
 */
+ (UIImage *)drawImageWithDrawModels:(NSArray<DrawModel *> *)drawModels backgroundSize:(CGSize)backgroundSize backgroundColor:(UIColor *)backgroundColor{
    
    NSMutableArray *tempMuArray = [[NSMutableArray alloc] initWithArray:drawModels];    //创建可变数组，用来进行编辑
    CGRect backRect = CGRectMake(0, 0, backgroundSize.width, backgroundSize.height);
    DrawModel *tempDrawModel = [[DrawModel alloc] initWithRect:backRect object:[UIImage imageWithColor:backgroundColor rect:backRect]];
    tempDrawModel ? [tempMuArray insertObject:tempDrawModel atIndex:0] : nil;
    
    for (DrawModel *model in tempMuArray) {
        if ([model.object isKindOfClass:[UIView class]]) {
            model.object = [UIImage drawImageWithView:model.object];
        }
    }
 
    UIGraphicsBeginImageContext(backgroundSize);        //开启绘制上下文
    
    //绘制所有元素
    for (DrawModel *model in tempMuArray) {
        if (model.object && [model.object respondsToSelector:@selector(drawInRect:)]) {
            objc_msgSend(model.object, @selector(drawInRect:), model.rect);
        }else{
            NSLog(@"can not draw this element");
        }
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();                 //生成最终合成图
    UIGraphicsEndImageContext();                                                         //结束绘制，关闭上下文
    return resultingImage;
}


/**
 获取圆形图片

 @param originalImage 原图
 @param contentMode 填充方式
 @param rect rect
 @return 处理后的图片
 */
+ (UIImage *)RoundImageWithOriginalImage:(UIImage *)originalImage contentMode:(UIViewContentMode)contentMode rect:(CGRect)rect{
    
    //先切成正方形的图
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:originalImage];
    tempImageView.contentMode = contentMode;
    tempImageView.frame = rect;
    tempImageView.backgroundColor = [UIColor whiteColor];
    
    //切取imageview上的图
    UIGraphicsBeginImageContextWithOptions(tempImageView.bounds.size, NO, 0);
    [tempImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(tempImage.size, NO, 0);
    
    //裁切范围
    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height)];
    [path addClip];
    
    //绘制图片
    [tempImage drawAtPoint:CGPointZero];
    
    //从上下文中获得裁切好的图片
    UIImage *tempImage1 = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片上下文
    UIGraphicsEndImageContext();
    return tempImage1;
}

@end

