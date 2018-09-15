//
//  LQGPlayerView.m
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/7/25.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "LQGPlayerView.h"

#pragma mark - system
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#pragma mark - view
#import "LQGPlayerControlView.h"

#define LQGWeakSelf __weak __typeof(self)weakSelf = self;
#define LQGStrongSelf __strong __typeof(weakSelf)strongSelf = weakSelf;

#define KeyWindow [UIApplication sharedApplication].keyWindow

//使用方法     ColorFromRGB(0xf54140, 1.0);（注意带0x）
#define UIColorFromRGBA(rgbValue, ALPHA) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:ALPHA]

//获取屏幕宽度
#define SCREEN_WIDTH \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

#define PlayerItemStatus @"status"  //预播放状态(AVPlayerItemStatus)，有三种情况AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay,AVPlayerItemStatusFailed
#define PlayerItemLoadedTimeRanges @"loadedTimeRanges" //缓冲进度
#define PlayerItemPlaybackBufferEmpty @"playbackBufferEmpty"    //seekToTime后，缓冲数据为空，而且有效时间内数据无法补充，播放失败（播放失败的回调）
#define PlayerItemPlaybackLikelyToKeepUp @"playbackLikelyToKeepUp"  //seekToTime后,可以正常播放，相当于readyToPlay，一般拖动滑竿菊花转，到了这个这个状态菊花隐藏（缓冲成功的回调）

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

@interface LQGPlayerView()

#pragma mark - player相关
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playItem;
@property (nonatomic, strong) id timeOgserver; ///< avplayer时间观察者

#pragma mark - view
@property (nonatomic, strong) LQGPlayerControlView *playerControllerView;

#pragma mark - flag & other
@property (nonatomic, assign) BOOL playStatus; ///< 播放状态
@property (nonatomic, assign) BOOL sliderLoadingStatus; ///< 是否是slider滑动后加载的状态
@property (nonatomic, assign) PanDirection panDirection;    ///< 滑动方向
@property (nonatomic, assign) BOOL isVolume;    ///< 是否在调节音量
@property (nonatomic, assign) CGFloat sumTime; ///< 快进总时长
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation; ///< 屏幕方向

@end

#warning 建议重新思考videoPalyer的架构

@implementation LQGPlayerView

@synthesize playItem = _playItem;

#pragma mark - init & life

- (void)dealloc{
    [self removeMonitor];   //移除所有监听
    NSLog(@"player dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetUI];
        [self defaultLayout];
    }
    return self;
}

#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:PlayerItemStatus]) {
        [self handlePlayItemStatus];    //监听播放状态
    } else if ([keyPath isEqualToString:PlayerItemLoadedTimeRanges]) {
        [self.playerControllerView.progressView setProgress:[self availableDuration] / CMTimeGetSeconds(self.playItem.duration) animated:YES];  //监听加载进度
    }else if ([keyPath isEqualToString:PlayerItemPlaybackBufferEmpty]){
    }else if ([keyPath isEqualToString:PlayerItemPlaybackLikelyToKeepUp]){
    }
    
}

#pragma mark - UI

/**
 设置默认UI
 */
- (void)defaultSetUI{
    self.backgroundColor = [UIColor blackColor];
    [self.layer addSublayer:self.playerLayer];
    [self addSubview:self.playerControllerView];
}

/**
 横屏设置UI
 */
- (void)horizontalSetUI{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

/**
 默认竖屏布局
 */
- (void)defaultLayout{
    self.playerLayer.frame = self.bounds;
    self.playerControllerView.frame = self.bounds;
}

/**
 横屏布局
 */
- (void)horizontalLayout{
    self.playerLayer.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.playerControllerView.controlSuperView.frame = CGRectMake([self iphoneSafeAreaInsets].top, 0, self.bounds.size.width - [self iphoneSafeAreaInsets].top - [self iphoneSafeAreaInsets].bottom, self.bounds.size.height);
    }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.playerControllerView.controlSuperView.frame = CGRectMake([self iphoneSafeAreaInsets].bottom, 0, self.bounds.size.width - [self iphoneSafeAreaInsets].top - [self iphoneSafeAreaInsets].bottom, self.bounds.size.height);
    }

}

/**
 获取appedges
 
 @return appedges
 */
- (UIEdgeInsets)iphoneSafeAreaInsets{
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)){
        return UIEdgeInsetsMake(44, 0, 34, 0);
    }
    return UIEdgeInsetsZero;
}

#pragma mark - publicMethod

/**
 *  播放
 */
- (void)play{
    qgPlayerHiddenHUD();
    [_player play];
    _playStatus = YES;
}

/**
 显示菊花
 
 @param superView 显示的view（默认放在alertWindow上）
 @param text 显示文案
 @param afterDelaySeconds 消失时间（默认15s）
 */
void qgPlayerShowHUD(UIView *superView, NSString *text, CGFloat afterDelaySeconds){
    UIActivityIndicatorView *hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    hud.center = superView.center;
    [superView addSubview:hud];
    [hud startAnimating];
}

/**
 隐藏菊花
 */
void qgPlayerHiddenHUD(){
    for (UIView *subView in KeyWindow.subviews) {
        if ([subView isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *hud = (UIActivityIndicatorView *)subView;
            [hud stopAnimating];
            [hud removeFromSuperview];
            hud = nil;
        }
    }
}

/**
 *  暂停
 */
- (void)pause{
    qgPlayerHiddenHUD();
    [_player pause];
    _playStatus = NO;
}

#pragma mark - notiAction

/**
 视频播放完成的通知
 
 @param noti 通知对象
 */
- (void)videoPlayDidEnd:(NSNotification *)noti{
    [self pause];
}

/**
 视频播放异常中断通知事件
 
 @param noti 通知对象
 */
- (void)videoPlayInterrupt:(NSNotification *)noti{
    qgPlayerShowToast(@"网络异常！");
}

/**
 显示toast提示
 
 @param toastText 提示文案
 */
void qgPlayerShowToast(NSString *toastText){
    
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
 进入后台通知事件
 
 @param noti 通知对象
 */
- (void)enterBcakground:(NSNotification *)noti{
    [self pause];
}

/**
 进入前台通知事件
 
 @param noti 通知对象
 */
- (void)enterPlayGround:(NSNotification *)noti{
    [self play];
}

/**
 耳机插入拔出事件

 @param noti 通知对象
 */
- (void)headPhoneUpdate:(NSNotification *)noti{
    switch ([[noti.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue]) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 拔掉耳机继续播放
            [self pause];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            [self pause];
            break;
    }
}

#pragma mark - 监听部分

/**
 增加item特殊属性的监听
 */
- (void)addMonitor{
    LQGWeakSelf
    
    if (_playItem) {
        //kvo
        [self.playItem addObserver:self forKeyPath:PlayerItemStatus options:NSKeyValueObservingOptionNew context:nil];
        [self.playItem addObserver:self forKeyPath:PlayerItemLoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
        [self.playItem addObserver:self forKeyPath:PlayerItemPlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
        [self.playItem addObserver:self forKeyPath:PlayerItemPlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
        
        //noti
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playItem];    //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoPlayInterrupt:)
                                                     name:AVPlayerItemPlaybackStalledNotification
                                                   object:self.playItem];    //添加视频异常中断通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterBcakground:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:self.playItem];   //进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterPlayGround:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:self.playItem];   // 返回前台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(headPhoneUpdate:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:nil];     // 监听耳机插入和拔掉通知
        
        //监听单位时间内的播放状态
        self.timeOgserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
            LQGStrongSelf
            CGFloat currentSecond = strongSelf.playItem.currentTime.value / strongSelf.playItem.currentTime.timescale;// 计算当前在第几秒
            CGFloat totalSecond = strongSelf.playItem.duration.value / strongSelf.playItem.duration.timescale;
            if (!strongSelf.sliderLoadingStatus){
                strongSelf.playerControllerView.progressControlSlider.value = currentSecond / totalSecond;
                strongSelf.playerControllerView.leftTimeLabel.text = [self convertTime:currentSecond];
            }
            strongSelf.playerControllerView.rightTimeLabel.text = [self convertTime:totalSecond];
        }];
    }

}

/**
 移除所有监听
 */
- (void)removeMonitor{
    if (_playItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_playItem removeObserver:self forKeyPath:PlayerItemStatus];
        [_playItem removeObserver:self forKeyPath:PlayerItemLoadedTimeRanges];
        [_playItem removeObserver:self forKeyPath:PlayerItemPlaybackBufferEmpty];
        [_playItem removeObserver:self forKeyPath:PlayerItemPlaybackLikelyToKeepUp];
        [_player removeTimeObserver:_timeOgserver];
    }
}

#pragma mark - 监听处理

/**
 处理playitem的播放状态
 */
- (void)handlePlayItemStatus{
    switch (self.playItem.status) {
        case AVPlayerItemStatusUnknown:
        {
            //未知状态处理
            [self pause];
            qgPlayerShowToast(@"未知情况");
        }
            break;
        case AVPlayerItemStatusReadyToPlay:
        {
            //准备播放状态处理
            [self play];
        }
            break;
        case AVPlayerItemStatusFailed:
        {
            //播放失败状态处理
            [self pause];
            qgPlayerShowToast(@"播放失败");
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Action

/**
 全屏button击事件
 */
- (void)fullScreenAction{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    [self horizontalSetUI];
    [self horizontalLayout];
}

/**
 滑杆滑动方法
 */
- (void)sliderChange{
    self.playerControllerView.leftTimeLabel.text = [self convertTime:self.playItem.duration.value / self.playItem.duration.timescale * self.playerControllerView.progressControlSlider.value];  //更新时间显示
}

/**
 滑杆拖动结束方法
 */
- (void)sliderValueEndChange{
    [self seekToTime:self.playerControllerView.progressControlSlider.value * (self.playItem.duration.value / self.playItem.duration.timescale)];
}

/**
 拖动事件处理方法

 @param pan 拖动对象
 */
- (void)panAction:(UIPanGestureRecognizer *)pan{
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                CMTime time       = self.player.currentTime;
                self.sumTime      = time.value/time.timescale;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self seekToTime:self.sumTime];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - privateMethod

/**
 获取时间间隔
 
 @return 时间间隔对象
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

/**
 拖动滑杆方法
 */
- (void)seekToTime:(NSInteger)changeValue{
    if (!self.playItem.duration.timescale) {
        return;
    }
    
    LQGWeakSelf
    qgPlayerShowHUD(self.playerControllerView.contentView, nil, 1000);
    self.sliderLoadingStatus = YES;
    [self.player seekToTime:CMTimeMake(changeValue, 1) completionHandler:^(BOOL finished) {
        LQGStrongSelf
        [strongSelf play];
        strongSelf.sliderLoadingStatus = NO;
    }];
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value {
    self.playerControllerView.contentView.hidden = NO;
    
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CMTime totalTime           = self.playItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    //显示拖动进度
    self.playerControllerView.progressControlSlider.value =  self.sumTime / (self.playItem.duration.value / self.playItem.duration.timescale);
    [self sliderChange];
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
    
    if (self.isVolume) {
        self.player.volume -= value / 10000;
    }else{
        [UIScreen mainScreen].brightness -= value / 10000;
    }
    
}

/**
 强制旋转屏幕

 @param orientation 旋转方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        self.interfaceOrientation = orientation;
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

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

#pragma mark - setter

- (void)setVideoURL:(NSURL *)videoURL{
    if (_videoURL == videoURL) return;
    
    _videoURL = videoURL;
    
    qgPlayerShowHUD(self, nil, 1000);
    [self removeMonitor];   //移除旧监听
    self.playItem = [AVPlayerItem playerItemWithURL:videoURL];
    [self addMonitor];  //增加新监听
    [self.player replaceCurrentItemWithPlayerItem:self.playItem];
}

#pragma mark - getter

- (AVPlayerItem *)playItem{
    if (!_playItem) {
        _playItem = [AVPlayerItem playerItemWithURL:self.videoURL];
    }
    return _playItem;
}

- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return _playerLayer;
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (LQGPlayerControlView *)playerControllerView{
    if (!_playerControllerView) {
        LQGWeakSelf
        LQGPlayerControlView *tempView = [[LQGPlayerControlView alloc] init];
        
        tempView.playButtonActionBlock = ^{
            LQGStrongSelf
            strongSelf.playerControllerView.playButton.selected ? [strongSelf play] : [strongSelf pause];
        };
        
        tempView.sliderActionBlock = ^{
            LQGStrongSelf
            [strongSelf sliderValueEndChange];
        };
        
        tempView.sliderValueChangeBlock = ^{
            LQGStrongSelf
            [strongSelf sliderChange];
        };
        
        tempView.panActionBlock = ^(UIPanGestureRecognizer *pan) {
            LQGStrongSelf
            [strongSelf panAction:pan];
        };
        
        tempView.fullButtonActionBlock = ^{
            LQGStrongSelf
            [strongSelf fullScreenAction];
        };
        
        _playerControllerView = tempView;
    }
    return _playerControllerView;
}

@end
