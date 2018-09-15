//
//  QGIOSNetWork.h
//  QGIOSNetWork
//
//  Created by Li,Quangang on 2018/8/28.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface QGIOSNetWork : AFHTTPSessionManager

+ (instancetype)shareInstance;

@end
