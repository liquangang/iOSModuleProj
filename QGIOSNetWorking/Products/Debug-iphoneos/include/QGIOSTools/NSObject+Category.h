//
//  NSObject+Category.h
//  IOSProgrammingFramework
//
//  Created by liquangang on 2017/3/14.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

//typedef void(^Completionhandler)(); //默认无参数无返回值处理block

@interface NSObject (Category)

#pragma mark - 分类添加属性示例

@property (nonatomic, copy) NSString *testProperty;

#pragma mark - runtime

/* 获取对象的所有属性 */
- (NSArray *)getAllProperties;

/* 获取对象的所有方法 */
-(NSArray *)getAllMethods;

@end
