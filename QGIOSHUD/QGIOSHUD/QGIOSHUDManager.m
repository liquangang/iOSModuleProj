//
//  QGIOSHUDManager.m
//  QGIOSHUDManager
//
//  Created by Li,Quangang on 2018/8/28.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import "QGIOSHUDManager.h"

//使用方法     ColorFromRGB(0xf54140, 1.0);（注意带0x）
#define UIColorFromRGBA(rgbValue, ALPHA) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:ALPHA]

#define KeyWindow [UIApplication sharedApplication].keyWindow

//获取屏幕宽度
#define SCREEN_WIDTH \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

//获取屏幕高度
#define SCREEN_HEIGHT \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

@implementation QGIOSHUDManager

#pragma mark - 提示相关

/**
 显示toast提示
 
 @param toastText 提示文案
 */
void showToast(NSString *toastText){
    
    //获取富文本
    NSDictionary *attriDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:toastText attributes:attriDic];
    
    //生成toastview
    UITextView *toasTextView = [[UITextView alloc] init];
    toasTextView.attributedText = attributedStr;
    toasTextView.backgroundColor = UIColorFromRGBA(0x000000, 0.6);
    toasTextView.layer.masksToBounds = YES;
    toasTextView.layer.cornerRadius = 6;
    toasTextView.editable = NO;
    toasTextView.scrollEnabled = NO;
    toasTextView.textContainerInset = UIEdgeInsetsZero;
    toasTextView.textContainer.lineFragmentPadding = 0;
    
    //实例化alertWindow
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:KeyWindow.bounds];
    alertWindow.windowLevel = UIWindowLevelAlert;
    
    //添加toastview
    [alertWindow addSubview:toasTextView];
    toasTextView.frame = [attributedStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 66, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    [alertWindow makeKeyAndVisible];   //显示提示toast
    
    //1.5秒后隐藏toast    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        alertWindow.hidden = YES;
        [toasTextView removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        [alertWindow removeFromSuperview];
    });
}

/**
 默认简单的alert方法
 
 @param title 标题
 @param message 中间的展示描述
 @param firstButtonTitle 第一个按钮的文案
 @param secondButtonTitle 第二个按钮的文案
 @param completionHandler1 第一个按钮的回调
 @param completionHandler2 第二个按钮的回调
 */
void showAlert(NSString *title, NSString *message, NSString *firstButtonTitle, NSString *secondButtonTitle, Completionhandler completionHandler1, Completionhandler completionHandler2){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (firstButtonTitle.length > 0) {
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:firstButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler1 ? completionHandler1() : nil;
        }];
        [alertController addAction:alertAction1];
    }
    
    if (secondButtonTitle.length > 0) {
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:secondButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler2 ? completionHandler2() : nil;
        }];
        [alertController addAction:alertAction2];
    }
    
    [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
}

/**
 默认简单的ActionSheet方法
 
 @param title 标题
 @param message 中间的展示描述
 @param firstButtonTitle 第一个按钮的文案
 @param secondButtonTitle 第二个按钮的文案
 @param completionHandler1 第一个按钮的回调
 @param completionHandler2 第二个按钮的回调
 */
void showActionSheet(NSString *title, NSString *message, NSString *firstButtonTitle, NSString *secondButtonTitle, Completionhandler completionHandler1, Completionhandler completionHandler2){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (firstButtonTitle.length > 0) {
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:firstButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler1 ? completionHandler1() : nil;
        }];
        [alertController addAction:alertAction1];
    }
    
    if (secondButtonTitle.length > 0) {
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:secondButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler2 ? completionHandler2() : nil;
        }];
        [alertController addAction:alertAction2];
    }
    
    UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:alertAction3];
    
    [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

static UIView *hudSuperView;
/**
 显示菊花
 
 @param superView 显示的view（默认放在alertWindow上）
 @param text 显示文案
 @param afterDelaySeconds 消失时间（默认15s）
 */
void showHUD(UIView *superView, NSString *text, CGFloat afterDelaySeconds){
    hudSuperView = superView ? superView : KeyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:hudSuperView];
    [hudSuperView insertSubview:hud atIndex:10000];
    hud.minShowTime = 0.2;
    hud.label.text = text;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:afterDelaySeconds > 0 ? afterDelaySeconds : 15.f];
}

/**
 隐藏菊花
 */
void hiddenHUD(){
    for (UIView *subView in hudSuperView.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *tempHUD = (MBProgressHUD *)subView;
            [tempHUD hideAnimated:YES];
            [tempHUD removeFromSuperview];
            tempHUD = nil;
        }
    }
}

@end
