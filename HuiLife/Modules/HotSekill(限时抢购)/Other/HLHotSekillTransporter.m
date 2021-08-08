//
//  HLHotSekillTransporter.m
//  HuiLife
//
//  Created by 王策 on 2021/8/8.
//

#import "HLHotSekillTransporter.h"

static HLHotSekillTransporter *_transporter = nil;

@implementation HLHotSekillTransporter

+ (instancetype)sharedTransporter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _transporter = [[self alloc] init];
        [_transporter resetAllParams];
    });
    return _transporter;
}

/// 拼接参数
- (void)appendParams:(NSDictionary *)params{
    [self.uploadParams addEntriesFromDictionary:params];
    NSLog(@"%@",self.uploadParams);
}

/// 释放所有数据
- (void)resetAllParams{
    self.uploadParams = [NSMutableDictionary dictionary];
    self.isEdit = NO;
    self.editModelData = nil;
}

@end
