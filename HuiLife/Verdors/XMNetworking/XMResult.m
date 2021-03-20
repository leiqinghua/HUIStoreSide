//
//  XMResult.m
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/9/21.
//  Copyright © 2018年 wce. All rights reserved.
//

#import "XMResult.h"

@implementation XMResult

-(NSString *)error{
    if (_msg && ![_msg isEqualToString:@""]) {
        return _msg;
    }
    return _error;
}

-(NSString *)msg{
    if (_error && ![_error isEqualToString:@""]) {
        return _error;
    }
    return _msg;
}

/// 验证是否成功 status == 200
+ (BOOL)isSuccess:(id)response{
    if ([(XMResult *)response code] == 200) {
        return YES;
    }
    return NO;
}

/// 获取到字典
+ (id)dataDict:(id)response{
    return [(XMResult *)response data];
}

- (BOOL)checkIsTokenExpire{
    return self.code == 201404 || self.code == 404;
}

@end
