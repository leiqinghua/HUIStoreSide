//
//  XMResult.h
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/9/21.
//  Copyright © 2018年 wce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMResult : NSObject

@property (assign, nonatomic) NSInteger code;

@property (copy, nonatomic) NSString *msg;

@property (strong, nonatomic) id data; // 一般是字典，可能是数组

@property (copy, nonatomic) NSString *error; // 添加车牌号时有了
//不是所有接口都有，特殊接口添加
@property(nonatomic, strong) NSArray *profit;

/// 验证是否成功 status == 200
+ (BOOL)isSuccess:(id)response;

/// 获取到字典
+ (id)dataDict:(id)response;

- (BOOL)checkIsTokenExpire;

@end
