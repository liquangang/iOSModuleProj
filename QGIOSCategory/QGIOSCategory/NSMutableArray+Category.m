//
//  NSMutableArray+Category.m
//  IOSProgrammingFramework
//
//  Created by liquangang on 2017/3/14.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "NSMutableArray+Category.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Category)

+ (void)load{
    /**
     *  交换方法的IMP指针只需要执行一次，为了避免load的多次调用
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         *  步骤如下:
         */
        // 0.获取本类的类对象
        Class cls = NSClassFromString(@"__NSArrayM");
        // 1.获取交换方法的SEL
        SEL originalSelector = @selector(addObject:);
        SEL swizzledSelector = @selector(myAddObject:);
        
        // 2.获取交换方法
        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        // 3.如果需要被交换的方法不存在，那么我们需要手动添加一个方法
        // 把originalSelector指向swizzledMethod的IMP
        // 如果方法存在，那么添加方法会失败
        BOOL success = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            // 证明添加成功，方法不存在
            // 把swizzledSelector指向originalMethod的IMP
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            // 方法不存在, 直接交换方法的
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)myAddObject:(id)anObject{
    if (anObject == nil) {
        NSLog(@"对象不能为空");
    }else{
        [self myAddObject:anObject];
    }
}

@end
