//
//  HLPayManage.m
//  HLPayManage_Example
//
//  Created by 王策 on 2019/9/2.
//  Copyright © 2019 王策. All rights reserved.
//

#import "HLPayManage.h"

static HLPayManage *manage = nil;

@interface HLPayManage ()

@property (nonatomic, copy) NSString *aliFromScheme;

@end

@implementation HLPayManage

+ (instancetype)shareManage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[HLPayManage alloc] init];
    });
    return manage;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.wxManage  = [[HLWXManage alloc] init];
    }
    return self;
}

#pragma mark - Public Method

/// 注册key
+ (void)configWXAppKey:(NSString *)wxappKey urlLinks:(NSString *)urlLinks aliFromScheme:(NSString *)aliFromScheme {
    HLPayManage *manage = [HLPayManage shareManage];
    [HLWXManage registWxAppKey:wxappKey urlLinks:urlLinks];
}

/// AppDelegate处理url
- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    // 处理支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        return YES;
    }
    return [self.wxManage handleOpenURL:url];
}

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity {
    return [self.wxManage handleOpenUniversalLink:userActivity];
}

/// 准备支付
- (void)preparePayWithParams:(NSDictionary *)params finishBlock:(HLPayFinishBlock)finishBlock {
    
    NSString *aliparam = params[@"aliparam"];
    
    // 支付宝支付
    if (aliparam.length > 0) {
        return;
    }
    
    // 微信支付
    NSString *partnerid = params[@"partnerid"];
    if (partnerid) {
        // 检查微信是否安装
        if (![self.wxManage wxAppIsInstalled]) {
            if (finishBlock) { finishBlock(NO, @"请安装微信客户端"); };
            return;
        }
        [_wxManage prepareWXPayWithPayParams:params finishBlock:finishBlock];
        return;
    }
    
    // 支付参数有误
    if (finishBlock) { finishBlock(NO, @"支付参数有误"); };
}

@end
