//
//  QGIOSHeader.h
//  QGIOSHeader
//
//  Created by Li,Quangang on 2018/8/22.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 定义的经常使用的值

//判断字符串是否为空
#define StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//判断数组是否为空
#define ArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//判断字典是否为空
#define DictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//判断是否是空对象
#define ObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//获取屏幕宽度
#define SCREEN_WIDTH \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

//获取屏幕高度
#define SCREEN_HEIGHT \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

//获取屏幕size
#define ScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)

//获取状态栏size
#define StatusBarSize [[UIApplication sharedApplication] statusBarFrame].size


#define SIMILAR5S 320.0f                //跟iphone5s屏幕宽度相同的屏幕的宽度
#define SIMILAR6  375.0f                //跟iphone6屏幕宽度相同的屏幕的宽度
#define SIMILAR6p 414.0f                //跟iphone6p屏幕宽度相同的屏幕的宽度

/**
 *  根据比例获取pt长度（使用该宏来获取pt会使不同屏幕上的view显示的效果相同，观感相同，会与屏幕有同样的比例）
 *  standardLength是iphone6上的px值，一般按照ui标注值开发时，是不需要除2的
 *  例： SCALE_LENGTH(100)   （此时在iphone6上会显示50pt，其余机型会按照屏幕宽度比例来放大或者缩小）
 *  此时依然需要结合masonry来使用
 *
 */
#define SCALE_LENGTH(standardLength) ((((CGFloat)((standardLength) / 2.0f)) / SIMILAR6) * SCREEN_WIDTH)    //传入具体的值，然后根据这个宏来判断具体frame

/**
 *  在不同屏幕上显示相同数量的字（一行，同样可以使不同屏幕上显示相同的效果，不会出现有的显示的字多，有的显示的字少）
 *  该宏只返回字号，不返回UIFont对象，返回的是CGFloat
 */
#define SCALE_FONTSIZE(standardFontNum) [UIFont getScaleFontSize:(standardFontNum)]

#pragma mark - 颜色

//使用方法     UIColorFromRGB(0xf54140);（注意带0x）
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//使用方法     ColorFromRGB(0xf54140, 1.0);（注意带0x）
#define UIColorFromRGBA(rgbValue, ALPHA) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:ALPHA]

/**  测试使用 随机色 */
#define RandomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0) green:(arc4random() % 255 / 255.0) blue:(arc4random() % 255 / 255.0) alpha:1.0]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#pragma mark - 打印

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

//常用的几个对象的缩写
#define Application        [UIApplication sharedApplication]
#define KeyWindow          [UIApplication sharedApplication].keyWindow
#define APPDELEGATE        (AppDelegate *)[UIApplication sharedApplication].delegate
#define UserDefaults       [NSUserDefaults standardUserDefaults]
#define NotificationCenter [NSNotificationCenter defaultCenter]

//获取app的版本号
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//系统版本号
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//获得当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否是iPhone
#define ISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否是iPad
#define ISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//获取沙盒路径
#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获得沙盒temp路径
#define kTempPath NSTemporaryDirectory()

//获得沙盒cache路径
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//真机
#endif
#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif

//global queue
#define GlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//group
#define Group dispatch_group_create()

//main Queue
#define MainQueue dispatch_get_main_queue()

//创建单例
#define CREATESINGLETON(singletonClassName) \
static singletonClassName *instance;\
+ (instancetype)shareInstance{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [[singletonClassName alloc] init] ;\
}) ;\
return instance;\
}\
+ (id)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [super allocWithZone:zone] ;\
}) ;\
return instance;\
}\
- (id)copyWithZone:(NSZone *)zone{\
return instance;\
}

//.h里面的单例声明
#define ShareInstance(singletonClassName) + (instancetype)shareInstance;

//获得当前类的类名
#define CLASSNAME NSStringFromClass([self class])

#pragma mark - weak

#define LQGWeakSelf __weak __typeof(self)weakSelf = self;
#define LQGStrongSelf __strong __typeof(weakSelf)strongSelf = weakSelf;

#pragma mark - block


#pragma mark - 测试资源

static NSString *const testVideoURLString = @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4";          //测试视频链接
#define TESTLOCALVIDEOURLSTRING [[NSBundle mainBundle] pathForResource:@"海贼王精彩剪辑" ofType:@"mp4"]

#pragma mark - block

typedef void(^CompletionHandlerWithHandleString)(NSString *string);
typedef void(^CompletionHandler)(void);

@interface QGIOSHeader : NSObject

int Random(int start, int end);

@end
