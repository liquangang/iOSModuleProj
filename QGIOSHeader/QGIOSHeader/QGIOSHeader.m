//
//  QGIOSHeader.m
//  QGIOSHeader
//
//  Created by Li,Quangang on 2018/8/22.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import "QGIOSHeader.h"

@implementation QGIOSHeader

int Random(int start, int end){
    int dis = end - start;
    return rand() % dis + start;
}

@end
