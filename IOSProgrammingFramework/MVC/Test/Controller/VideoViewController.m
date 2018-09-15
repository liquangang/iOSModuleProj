//
//  VideoViewController.m
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/7/25.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@property (nonatomic, strong) LQGPlayerView *playView;

@end

@implementation VideoViewController

- (void)dealloc{
    NSLog(@"fasdfasdf");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.playView];
    
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / 16 * 9));
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.centerX.equalTo(self.view);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter & setter

- (LQGPlayerView *)playView{
    if (!_playView) {
        
        //第二种使用frame初始化的方式
        _playView = [[LQGPlayerView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH / 16 * 9)];
        _playView.videoURL = [NSURL URLWithString:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
    }
    return _playView;
}

@end
