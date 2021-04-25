//
//  HLPlayManager.h
//  HuiLifeUserSide
//
//  Created by 王策 on 2019/7/26.
//  Copyright © 2019 wce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZFPlayer/ZFPlayer.h>
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLPlayManager : HLBaseViewController

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

- (instancetype)initWithVideoUrl:(NSString *)videoUrl preImgUrl:(NSString *)preImgUrl;

@end

NS_ASSUME_NONNULL_END
