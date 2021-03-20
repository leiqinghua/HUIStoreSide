//
//  HLAudioPlayManager.h
//  xunfei
//
//  Created by 闻喜惠生活 on 2018/9/13.
//  Copyright © 2018年 闻喜惠生活. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iflyMSC/IFlyMSC.h"
#import <AVFoundation/AVFoundation.h>

@interface HLAudioPlayManager : NSObject<IFlySpeechSynthesizerDelegate>

-(void)startSpeak:(NSString *)speak;

- (void)startSpeak:(NSString *)speak finished:(void(^)(void))finished;

+(instancetype)share;

@end
