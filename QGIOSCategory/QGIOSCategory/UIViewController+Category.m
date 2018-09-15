//
//  UIViewController+Category.m
//  IOSProgrammingFramework
//
//  Created by liquangang on 2017/3/14.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "UIViewController+Category.h"
#import <objc/runtime.h>
#import "NSObject+Category.h"
#import "QGIOSCategoryHeader.h"

@implementation UIViewController (Category)

+ (void)load{
        /**
         *  交换方法的IMP指针只需要执行一次，为了避免load的多次调用
         */
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class selfClass = [self class];
            
            {
                SEL oriSEL = @selector(viewWillAppear:);
                Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
                SEL newSEl = @selector(QGViewWillAppear:);
                Method newMethod = class_getInstanceMethod(self, newSEl);
                
                [self swizzleMethods:selfClass originalSEL:oriSEL originalMethod:oriMethod newSEL:newSEl newMethod:newMethod];
            }
            
            {
                SEL oriSEL = NSSelectorFromString(@"dealloc");
                Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
                SEL newSEL = @selector(QGDealloc);
                Method newMethod = class_getInstanceMethod(selfClass, newSEL);
                [self swizzleMethods:selfClass originalSEL:oriSEL originalMethod:oriMethod newSEL:newSEL newMethod:newMethod];
            }
            
        });
}

- (void)QGDealloc{
    NSLog(@"%@ dealloc", [self class]);
}

- (void)QGViewWillAppear:(BOOL)animated{
    [self QGViewWillAppear:animated];
    NSLog(@"%@ viewWillAppear", [self class]);
}

- (UINavigationController *)currentNavController{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        return (UINavigationController *)window.rootViewController;
        
    } else if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *selectVc = [((UITabBarController *)window.rootViewController)selectedViewController];
        
        if ([selectVc isKindOfClass:[UINavigationController class]]) {
            
            return (UINavigationController *)selectVc;
            
        }
    }
    return nil;
}


@end
