//
//  LQGPlayerControllerView.m
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/9/7.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "LQGPlayerControlView.h"

//使用方法     ColorFromRGB(0xf54140, 1.0);（注意带0x）
#define UIColorFromRGBA(rgbValue, ALPHA) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:ALPHA]

@interface LQGPlayerControlView()

@end

@implementation LQGPlayerControlView
#pragma mark - init & life

- (void)dealloc{
    NSLog(@"PlayerControlView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetUI];
        [self defaultLayout];
        [self addTap];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    [self hiddenContentViewAfterThirdSeconds];
    return [super hitTest:point withEvent:event];
}

#pragma mark - addTap

- (void)addTap{
    
    //单击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    
    //双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGesture];
    
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];  //只有双击失效时，才会相应单击手势
    
    //滑动手势（这里使用拖拽手势来实现）
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDirection:)];
    [self addGestureRecognizer:panRecognizer];

}

#pragma mark - tapAction

/**
 单击手势方法

 @param tap 手势对象
 */
- (void)tapAction:(UITapGestureRecognizer *)tap{
    self.contentView.hidden = !self.contentView.hidden;
}

/**
 双击手势方法

 @param tap 双击手势
 */
- (void)doubleTapAction:(UITapGestureRecognizer *)tap{
    [self playButtonAction:self.playButton];
}

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    self.panActionBlock ? self.panActionBlock(pan) : nil;
}

#pragma mark - UI

/**
 默认设置UI
 */
- (void)defaultSetUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.controlSuperView];
    [self.controlSuperView addSubview:self.progressView];
    [self.controlSuperView addSubview:self.playButton];
    [self.controlSuperView addSubview:self.leftTimeLabel];
    [self.controlSuperView addSubview:self.rightTimeLabel];
    [self.controlSuperView addSubview:self.progressControlSlider];
    [self.controlSuperView addSubview:self.fullScreenButton];
}

/**
 默认布局
 */
- (void)defaultLayout{
    self.contentView.frame = self.bounds;
    self.controlSuperView.frame = self.bounds;
    self.progressView.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    self.progressControlSlider.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    self.playButton.frame = CGRectMake(self.bounds.size.width/2 - 22, self.bounds.size.height/2 - 22, 44, 44);
    self.leftTimeLabel.frame = CGRectMake(0, self.bounds.size.height - 16, self.bounds.size.width/2, 14);
    self.rightTimeLabel.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height - 16, self.bounds.size.width/2, 14);
    self.fullScreenButton.frame = CGRectMake(self.bounds.size.width - 44, self.bounds.size.height - 16 - 44, 44, 44);
}

#pragma mark - privateMethod

/**
 三秒隐藏contentview
 */
- (void)hiddenContentViewAfterThirdSeconds{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.contentView.hidden = YES;
    });
}

#pragma mark - buttonAction

- (void)playButtonAction:(UIButton *)button{
    self.playButton.selected = !self.playButton.selected;
    self.playButtonActionBlock ? self.playButtonActionBlock() : nil;
}

- (void)sliderValueChanged:(UISlider *)slider{
    self.sliderValueChangeBlock ? self.sliderValueChangeBlock() : nil;
}

- (void)sliderValueEndChanged:(UISlider *)slider{
    self.sliderActionBlock ? self.sliderActionBlock() : nil;
}

- (void)fullScreenButtonAction:(UIButton *)button{
    self.fullScreenButton.selected = !self.fullScreenButton.selected;
    self.fullButtonActionBlock ? self.fullButtonActionBlock() : nil;
}

#pragma mark - otherMethod

/**
 格式化时间
 
 @param second 秒数
 @return 格式化字符串
 */
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

#pragma mark - gette & setter

- (UIProgressView *)progressView{
    
    if (!_progressView) {
        UIProgressView *tempProgressView = [[UIProgressView alloc] init];
        tempProgressView.trackTintColor= [UIColor clearColor];
        tempProgressView.progressTintColor= [UIColor grayColor];
        _progressView = tempProgressView;
    }
    
    return _progressView;
}

- (UIView *)contentView{
    if (!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        _contentView.hidden = YES;
    }
    return _contentView;
}

- (UIButton *)playButton{
    if (!_playButton){
        _playButton = [[UIButton alloc] init];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton setTitle:@"暂停" forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.selected = YES;
        _playButton.layer.masksToBounds = YES;
        _playButton.layer.cornerRadius = 22;
    }
    return _playButton;
}

- (UILabel *)leftTimeLabel{
    if (!_leftTimeLabel){
        _leftTimeLabel = [[UILabel alloc] init];
        _leftTimeLabel.text = [self convertTime:0];
        _leftTimeLabel.textColor = [UIColor whiteColor];
        _leftTimeLabel.font = [UIFont systemFontOfSize:12];
        _leftTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftTimeLabel;
}

- (UILabel *)rightTimeLabel{
    if (!_rightTimeLabel){
        _rightTimeLabel = [[UILabel alloc] init];
        _rightTimeLabel.text = [self convertTime:0];
        _rightTimeLabel.textColor = [UIColor whiteColor];
        _rightTimeLabel.font = [UIFont systemFontOfSize:12];
        _rightTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightTimeLabel;
}

- (UISlider *)progressControlSlider{
    if (!_progressControlSlider){
        _progressControlSlider = [[UISlider alloc] init];
        [_progressControlSlider addTarget:self action:@selector(sliderValueEndChanged:) forControlEvents:UIControlEventTouchUpInside]; //针对值变化添加响应方法
        [_progressControlSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _progressControlSlider.maximumTrackTintColor = UIColorFromRGBA(0xd3d7d4, 0.3);
        _progressControlSlider.minimumTrackTintColor = [UIColor groupTableViewBackgroundColor];
//        [_progressControlSlider setThumbImage:[UIImage RoundImageWithOriginalImage:[UIImage imageWithColor:[UIColor whiteColor] rect:CGRectMake(0, 0, 12, 12)] contentMode:UIViewContentModeCenter rect:CGRectMake(0, 0, 12, 12)] forState:UIControlStateNormal];
    }
    return _progressControlSlider;
}

- (UIButton *)fullScreenButton{
    if (!_fullScreenButton){
        _fullScreenButton = [[UIButton alloc] init];
        [_fullScreenButton setTitle:@"全屏" forState:UIControlStateNormal];
        [_fullScreenButton setTitle:@"小屏" forState:UIControlStateSelected];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenButton.selected = YES;
        _fullScreenButton.layer.masksToBounds = YES;
        _fullScreenButton.layer.cornerRadius = 22;
    }
    return _fullScreenButton;
}

- (UIView *)controlSuperView{
    if (!_controlSuperView){
        _controlSuperView = [[UIView alloc] init];
    }
    return _controlSuperView;
}

@end
