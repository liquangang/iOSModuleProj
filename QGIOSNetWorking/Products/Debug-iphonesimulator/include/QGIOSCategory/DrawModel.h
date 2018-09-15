//
//  DrawModel.h
//  QGIOSTools
//
//  Created by Li,Quangang on 2018/8/23.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawModel : NSObject

@property (nonatomic, assign) CGRect rect; ///< 元素的rect
@property (nonatomic, strong) id object; ///< 要绘制的元素对象

/**
 初始化方法

 @param rect rect
 @param object 绘制对象
 @return model
 */
- (instancetype)initWithRect:(CGRect)rect object:(id)object;

@end
