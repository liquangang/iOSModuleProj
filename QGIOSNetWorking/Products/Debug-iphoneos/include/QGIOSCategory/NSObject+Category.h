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
- (NSArray *)getAllMethods;

/**
 方法交换
 实现过程参考：
 + (void)load {
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 
 //获取class
 Class selfClass = [self class]; //替换对象方法是执行这一句获取对象的类
 //        Class selfClass = object_getClass([self class]);  //替换类方法时执行这一句获取类的元类
 
 //获取原始Method （先获取sel）
 SEL oriSEL = @selector(viewWillAppear:);
 Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
 //        Method oriMethod = class_getClassMethod(selfClass, oriSEL); //如果替换的方法是类方法时使用这个方法
 
 //获取替换的method
 SEL newSEl = @selector(QGViewWillAppear:);
 Method newMethod = class_getInstanceMethod(selfClass, newSEl);
 
 //判断是添加实现还是替换方法
 BOOL isAdd = class_addMethod(selfClass, oriSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
 if (isAdd) {
 class_replaceMethod(selfClass, newSEl, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
 } else {
 method_exchangeImplementations(oriMethod, newMethod);
 }
 });
 }

 @param class 要交换的方法的类（注意根据对象方法和类方法区别类和元类）
 @param oriSEL 原来的方法指针
 @param oriMethod 原来的方法实现
 @param newSEL 新的方法指针
 @param newMethod 新的方法实现
 */
- (void)swizzleMethods:(Class)class originalSEL:(SEL)oriSEL originalMethod:(Method)oriMethod newSEL:(SEL)newSEL newMethod:(Method)newMethod;

@end
