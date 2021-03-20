//
//  HLSendOrderRangeInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLSendOrderRangeSuggestionInfo;
@interface HLSendOrderRangeInfo : NSObject

@property (nonatomic, assign) NSInteger isCustom;
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *sendId;
@property (nonatomic, assign) NSInteger custom; // 0是未设置自定义范围 >0是设置了自定义范围

@property (nonatomic, copy) NSArray <HLSendOrderRangeSuggestionInfo *>*items;

/// 判断是不是选择的自定义
- (BOOL)isCustumRange;

/// 当前选择的推荐范围
- (HLSendOrderRangeSuggestionInfo *)selectRangeSuggestionInfo;

@end

@interface HLSendOrderRangeSuggestionInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, copy) NSString *itemId;

@end

NS_ASSUME_NONNULL_END
