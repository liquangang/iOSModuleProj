//
//  UIApplication+Category.m
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/10/26.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "UIApplication+Category.h"
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@implementation UIApplication (Category)

/**
 *  获取相册权限
 */
- (void)getPhotoAuthority:(void(^)(BOOL isCanUse))completed{
    
    void(^tempBlock)(PHAuthorizationStatus photoAuthorizationStatus) = ^(PHAuthorizationStatus photoAuthorizationStatus){
        if (completed) {
            if (photoAuthorizationStatus == PHAuthorizationStatusAuthorized) {
                completed(YES);
            }else{
                [self showAlert:@"无法访问相册，请在【设置】-【隐私】-【相册】中打开权限"];
                completed(NO);
            }
        }
    };
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        //用户未做过请求，主动请求一次
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            tempBlock(status);
        }];
    }else{
        tempBlock(authStatus);
    }
}

/**
 *  获取相机权限
 */
- (void)getCameraAuthority:(void(^)(BOOL isCanUse))completed{
    
    
    void(^tempBlock)(AVAuthorizationStatus authorizationStatus) = ^(AVAuthorizationStatus authorizationStatus){
        if (completed) {
            if (authorizationStatus == AVAuthorizationStatusAuthorized){
                completed(YES);
            }else{
                [self showAlert:@"无法访问相机，请在【设置】-【隐私】-【相机】中打开权限"];
                completed(NO);
            }
        }
    };
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusNotDetermined){
        
        //用户未做过请求，主动请求一次
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                tempBlock(AVAuthorizationStatusAuthorized);
            }else{
                tempBlock(AVAuthorizationStatusDenied);
            }
        }];
    }else{
        tempBlock(authorizationStatus);
    }
}

/**
 *  获取通讯录权限
 */
- (void)getAddressBookAuthority:(void(^)(BOOL isCanUse))completed{
    
    if (SystemVersion < 9.0) {
        void(^tempBlock)(ABAuthorizationStatus abAuthorizationStatus) = ^(ABAuthorizationStatus abAuthorizationStatus){
            if (completed) {
                if (abAuthorizationStatus == kABAuthorizationStatusAuthorized){
                    completed(YES);
                }else{
                    [self showAlert:@"无法访问通讯录，请在【设置】-【隐私】-【通讯录】中打开权限"];
                    completed(NO);
                }
            }
        };
        
        NSInteger addressBookAuthorizationStatus = ABAddressBookGetAuthorizationStatus();
        if (addressBookAuthorizationStatus == kABAuthorizationStatusNotDetermined){
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, NULL), ^(bool granted, CFErrorRef error) {
                if (error) {
                    tempBlock(kABAuthorizationStatusRestricted);
                    return;
                }
                if (granted) {
                    tempBlock(kABAuthorizationStatusAuthorized);
                }else{
                    tempBlock(kABAuthorizationStatusDenied);
                }
            });
        }else{
            tempBlock(addressBookAuthorizationStatus);
        }
        
    }else{
        
        void(^tempBlock)(CNAuthorizationStatus cnAuthorizationStatus) = ^(CNAuthorizationStatus cnAuthorizationStatus){
            if (completed) {
                if (cnAuthorizationStatus == CNAuthorizationStatusAuthorized){
                    completed(YES);
                }else{
                    [self showAlert:@"无法访问通讯录，请在【设置】-【隐私】-【通讯录】中打开权限"];
                    completed(NO);
                }
            }
        };
        
        NSInteger cnContactAuthorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (cnContactAuthorizationStatus == CNAuthorizationStatusNotDetermined) {
            [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    tempBlock(CNAuthorizationStatusRestricted);
                    return;
                }
                if (granted) {
                    tempBlock(CNAuthorizationStatusAuthorized);
                } else {
                    tempBlock(CNAuthorizationStatusDenied);
                }
            }];
        }else{
            tempBlock(cnContactAuthorizationStatus);
        }
        
    }
}

- (void)showAlert:(NSString *)alertStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:alertAction1];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
            
        }];
    });
}

@end
