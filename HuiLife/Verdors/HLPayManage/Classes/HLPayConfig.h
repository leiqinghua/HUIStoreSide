//
//  HLPayConfig.h
//  HLPayManage_Example
//
//  Created by 王策 on 2019/9/2.
//  Copyright © 2019 王策. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    HLSceneSession  = 0, // 聊天页面
    HLSceneTimeline = 1  // 朋友圈
} HLSceneType;

/// 是否支付成功的回调
typedef void(^HLPayFinishBlock)(BOOL success, NSString * _Nonnull msg);

typedef void(^HLAuthFinishBlock)(NSString* code, NSString * _Nonnull msg,NSString * state);
