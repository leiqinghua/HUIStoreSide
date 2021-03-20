//
//  HLSotreBuyCodeInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSotreBuyCodeInfo : NSObject

/// 输入的值
@property (nonatomic, copy) NSString *password;

/// 是否通过
@property (nonatomic, copy) NSString *isRight;

@end

NS_ASSUME_NONNULL_END
