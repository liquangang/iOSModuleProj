//
//  LQGPlayerControllerView.h
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/9/7.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQGPlayerControlView : UIView

#pragma mark - view
@property (nonatomic, strong) UIView *contentView; ///< 放所有view的view
@property (nonatomic, strong) UIView *controlSuperView; ///< 控制view的superview
@property (nonatomic, strong) UIProgressView *progressView;     ///< 缓冲进度条
@property (nonatomic, strong) UIButton *playButton;             ///< 左下角播放按钮
@property (nonatomic, strong) UIButton *fullScreenButton;       ///< 全屏按钮
@property (nonatomic, strong) UISlider *progressControlSlider;  ///< 视频播放进度控制
@property (nonatomic, strong) UILabel *leftTimeLabel; ///< 左侧时间label
@property (nonatomic, strong) UILabel *rightTimeLabel; ///< 右侧时间label

#pragma mark - block
@property (nonatomic, copy) void(^playButtonActionBlock)(void); ///< 播放按钮点击block
@property (nonatomic, copy) void(^sliderActionBlock)(void); ///< 进度控制block
@property (nonatomic, copy) void(^sliderValueChangeBlock)(void); ///< 进度变化block
@property (nonatomic, copy) void(^panActionBlock)(UIPanGestureRecognizer *pan); ///< 拖动手势
@property (nonatomic, copy) void(^fullButtonActionBlock)(void); ///< 全屏buttonblock

@end
