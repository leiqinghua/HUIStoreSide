//
//  HLPlayManager.m
//  HuiLifeUserSide
//
//  Created by 王策 on 2019/7/26.
//  Copyright © 2019 wce. All rights reserved.
//

#import "HLPlayManager.h"

#import <ZFPlayer/ZFPlayer.h>
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"

@interface HLPlayManager ()

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *preImgUrl;

@property (nonatomic, assign) BOOL canUse4G;
@property (nonatomic, strong) UIView *netWorkTipView;

@end

@implementation HLPlayManager

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
    
    [self hl_setBackgroundColor:UIColor.blackColor];
    [self hl_setBackImage:@"back_circle_grey"];
    [self hl_setTransparentNavtion];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
    
}

- (instancetype)initWithVideoUrl:(NSString *)videoUrl preImgUrl:(NSString *)preImgUrl
{
    self = [super init];
    if (self) {
        _videoUrl = videoUrl;
        _preImgUrl = preImgUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    [self hl_resetStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.containerView.frame = self.view.frame;
    [self.view addSubview:self.containerView];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = YES;
    self.player.allowOrentitaionRotation = NO;
    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskPortrait;
    
    weakify(self)
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self);
        [self.player.currentPlayerManager replay];
    };
    
    self.player.assetURL = [NSURL URLWithString:self.videoUrl];
    [self.player playTheIndex:0];
}


- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.seekToPlay = NO;
        _controlView.prepareShowControlView = YES;
        weakify(self);
        _controlView.cancelPlayBlock = ^{
            [weak_self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        [_containerView setImageWithURLString:_preImgUrl placeholder:[ZFUtilities imageWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)]];
    }
    return _containerView;
}


@end
