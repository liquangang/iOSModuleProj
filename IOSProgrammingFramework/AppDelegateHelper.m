//
//  AppDelegateHelper.m
//  IOSProgrammingFramework
//
//  Created by liquangang on 2017/7/20.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "AppDelegateHelper.h"

@implementation AppDelegateHelper

- (void)appSetUp{
    
    [self initUI];
    [self initPlaySetting];
    [self initFPSStatus];
}

/**
 初始化播放环境配置
 */
- (void)initPlaySetting {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

/**
 初始化帧率显示
 */
- (void)initFPSStatus {
    [[JPFPSStatus sharedInstance] open];
}

- (void)initAIFace {
    
}

/**
 ui初始化
 */
- (void)initUI {
    
}

@end
