//
//  AudioView.h
//  IOSProgrammingFramework
//
//  Created by Li,Quangang on 2018/5/17.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AudioViewButtonAction)(void);

@interface AudioView : UIView

@property (nonatomic, strong) UIButton *collectControlButton;   ///采集控制button

@property (nonatomic, copy) AudioViewButtonAction collectControlButtonAction;
@property (nonatomic, copy) AudioViewButtonAction playButtonAction;

@end
