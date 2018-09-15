//
//  LQGPlayerView.h
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/7/25.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQGPlayerView : UIView

@property (nonatomic, assign, readonly) BOOL playStatus; ///< 播放状态
@property (nonatomic, strong) NSURL *videoURL;  //视频URL 

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

@end
