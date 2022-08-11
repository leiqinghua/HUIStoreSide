//
//  HLVoucherMarketInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLVoucherMarketStateInfo;
@class HLVoucherMarketActivityInfo;

@interface HLVoucherMarketInfo : NSObject

@property (nonatomic, copy) NSString *accountSt; // // -1 不存在 0 初始状态 1 审核中 2 审核失败 3 审核成功

/// 开启买单活动
@property (nonatomic, copy) NSString *oneTitle;

/// 开启买单活动
@property (nonatomic, copy) NSString *twoTitle;

/// 活动
@property (nonatomic, copy) NSArray <HLVoucherMarketActivityInfo *>*downInfo;

@end


@interface HLVoucherMarketActivityInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *clickTitle;
@property (nonatomic, copy) NSString *iosAddress;
@property (nonatomic, copy) NSDictionary *iosParam;

@end

NS_ASSUME_NONNULL_END
