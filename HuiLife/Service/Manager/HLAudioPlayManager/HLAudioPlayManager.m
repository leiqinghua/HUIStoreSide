//
//  HLAudioPlayManager.m
//  xunfei
//
//  Created by 闻喜惠生活 on 2018/9/13.
//  Copyright © 2018年 闻喜惠生活. All rights reserved.
//

#import "HLAudioPlayManager.h"
#import <MediaPlayer/MediaPlayer.h>

typedef void(^FinishedBlock)(void);

@interface HLAudioPlayManager(){
    UISlider *_volumeViewSlider;
    
    float _curVolume;
    
    FinishedBlock _finished ;
}

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end

@implementation HLAudioPlayManager

static HLAudioPlayManager * player;
+(instancetype)share{
    if (!player) {
        player = [[HLAudioPlayManager alloc]init];
        
        [player registerID];
        
        [player setDefaultInfo];
       
    }
    return player;
}
//注册appid
-(void)registerID{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5b9a38bf"];
    [IFlySpeechUtility createUtility:initString];
}

-(void)setDefaultInfo{
    player.iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    
    [player.iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                        forKey:[IFlySpeechConstant ENGINE_TYPE]];
    player.iFlySpeechSynthesizer.delegate = player;
    //设置语速
    [player.iFlySpeechSynthesizer setParameter:@"20"
                                        forKey:[IFlySpeechConstant SPEED]];
    //设置音量，取值范围 0~100
    [player.iFlySpeechSynthesizer setParameter:@"100"
                                        forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [player.iFlySpeechSynthesizer setParameter:@"vixyin "
                                        forKey: [IFlySpeechConstant VOICE_NAME]];
    //音频采样率,目前支持的采样率有 16000 和 8000
    [player.iFlySpeechSynthesizer setParameter:@"8000"
                                        forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [player.iFlySpeechSynthesizer setParameter:nil
                                        forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
}

-(void)startSpeak:(NSString *)speak{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider *volumeViewSlider= nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    float systemVolume = volumeViewSlider.value;
    _volumeViewSlider = volumeViewSlider;
    _curVolume = systemVolume;
    if (systemVolume <= 0.5) {
        [volumeViewSlider setValue:1.0 animated:NO];
    }
    [_iFlySpeechSynthesizer startSpeaking:speak];
}

- (void)startSpeak:(NSString *)speak finished:(void(^)(void))finished{
    _finished = finished;
    [self startSpeak:speak];
}

//合成结束
- (void) onCompleted:(IFlySpeechError *) error {
//    [_volumeViewSlider setValue:_curVolume animated:NO];
    if (_finished) {
        _finished();
    }
}

//合成开始
- (void) onSpeakBegin {
    
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {
    
}
//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    
}
@end
