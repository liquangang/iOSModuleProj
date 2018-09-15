//
//  DrawModel.m
//  QGIOSTools
//
//  Created by Li,Quangang on 2018/8/23.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import "DrawModel.h"

@implementation DrawModel : NSObject

- (instancetype)initWithRect:(CGRect)rect object:(id)object
{
    self = [super init];
    if (self) {
        self.rect = rect;
        self.object = object;
    }
    return self;
}

@end
