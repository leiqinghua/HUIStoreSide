//
//  HLBaseDateModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/26.
//

#import "HLBaseDateModel.h"

@implementation HLBaseDateModel

static HLBaseDateModel * instance;
+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HLBaseDateModel alloc]init];
    });
    return instance;
}


-(void)setStartModel:(HLDayModel *)startModel{
    if (!startModel) {
        _startModel.isStart = NO;
        _startModel.isEnd = NO;
        _startModel = nil;
        return;
    }
    _startModel = startModel;
    _startModel.isStart = YES;
    _startModel.isEnd = NO;
}

-(void)setEndModel:(HLDayModel *)endModel{
    if (!endModel) {
        _endModel.isStart = NO;
        _endModel.isEnd = NO;
        _endModel = nil;
        return;
    }
    _endModel = endModel;
    _endModel.isStart = NO;
    _endModel.isEnd = YES;
}

@end
