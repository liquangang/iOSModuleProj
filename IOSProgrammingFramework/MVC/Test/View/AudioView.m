//
//  AudioView.m
//  IOSProgrammingFramework
//
//  Created by Li,Quangang on 2018/5/17.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import "AudioView.h"

@interface AudioView()

@property (nonatomic, strong) UIButton *playButton; ///播放button

@end

@implementation AudioView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.collectControlButton];
    [self addSubview:self.playButton];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - action

/**
 录制控制按钮方法

 @param button 录制控制按钮
 */
- (void)collectControlButtonAction:(UIButton *)button{
    
}

/**
 播放方法

 @param button 播放按钮
 */
- (void)playButtonAction:(UIButton *)button {
    
}

#pragma mark - setter & getter

- (UIButton *)collectControlButton {
    if (!_collectControlButton) {
        UIButton *tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 44)];
        [tmpButton addTarget:self action:@selector(collectControlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tmpButton setTitle:@"开始录制" forState:UIControlStateNormal];
        [tmpButton setTitle:@"停止录制" forState:UIControlStateSelected];
        _collectControlButton = tmpButton;
    }
    return _collectControlButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        UIButton *tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44)];
        [tmpButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tmpButton setTitle:@"播放" forState:UIControlStateNormal];
        _playButton = tmpButton;
    }
    return _playButton;
}

@end
