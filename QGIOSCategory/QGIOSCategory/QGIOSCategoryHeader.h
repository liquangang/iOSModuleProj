//
//  QGIOSCategoryHeader.h
//  QGIOSCategory
//
//  Created by Li,Quangang on 2018/8/28.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>

//nslog
#if DEBUG
#define NSLog(format, ...) do {                                                                 \
fprintf(stderr, "\n------------------------------------------------\n");                      \
fprintf(stderr, "< className: %s >\n< lineNum: %d >\n< functionName: %s >\n",      \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],                      \
__LINE__, __func__);                                                                            \
(NSLog)((format), ##__VA_ARGS__);                                                               \
fprintf(stderr, "------------------------------------------------\n");                    \
} while (0)
#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, width:%.4f, height:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s width:%.4f, height:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)
#define NSLogInsets(insets) NSLog(@"%s top:%.4f, left:%.4f, bottom:%.4f, right:%.4f", #insets, insets.top, insets.left, insets.bottom, insets.right)
#else
#define NSLog(FORMAT, ...) nil
#define NSLogRect(rect) nil
#define NSLogSize(size) nil
#define NSLogPoint(point) nil
#define NSLogInsets(insets) nil
#endif

@interface QGIOSCategoryHeader : NSObject

@end
