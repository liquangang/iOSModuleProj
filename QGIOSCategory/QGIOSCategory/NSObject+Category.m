//
//  NSObject+Category.m
//  IOSProgrammingFramework
//
//  Created by liquangang on 2017/3/14.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "NSObject+Category.h"

static const char *testPropertyKey = "testPropertyKey";

@implementation NSObject (Category)

#pragma mark - 分类添加属性示例

- (NSString *)testProperty{
    return objc_getAssociatedObject(self, testPropertyKey);
}

- (void)setTestProperty:(NSString *)testProperty{
    objc_setAssociatedObject(self, (__bridge const void *)(testProperty), testProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - runtime

/* 获取对象的所有属性 */
- (NSArray *)getAllProperties
{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}

/* 获取对象的所有方法 */
- (NSArray *)getAllMethods
{
    NSMutableArray *tempMuArr = [[NSMutableArray alloc] init];
    unsigned int methCount = 0;
    Method *meths = class_copyMethodList([self class], &methCount);
    
    for(int i = 0; i < methCount; i++) {
        
        Method meth = meths[i];
        
        SEL sel = method_getName(meth);
        
        const char *name = sel_getName(sel);
        
        NSLog(@"%s", name);
        [tempMuArr addObject:[NSString stringWithFormat:@"%s", name]];
    }
    
    free(meths);
    
    return [tempMuArr copy];
}

- (void)swizzleMethods:(Class)class originalSEL:(SEL)oriSEL originalMethod:(Method)oriMethod newSEL:(SEL)newSEL newMethod:(Method)newMethod {
    if (class_addMethod(class, oriSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, newSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

@end
