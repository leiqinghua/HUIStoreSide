//
//  HLVoucherMarketHead.h
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import <UIKit/UIKit.h>
#import "HLVoucherMarketInfo.h"

@class HLVoucherMarketHead;
@protocol HLVoucherMarketHeadDelegate <NSObject>

/// 点击创建按钮
- (void)marketHead:(HLVoucherMarketHead *)head addButtonClick:(UIButton *)addButton;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLVoucherMarketHead : UIView

@property (nonatomic, weak) id <HLVoucherMarketHeadDelegate> delegate;

/// 配置数据
- (void)configState:(NSInteger)state stateTitle:(NSString *)stateTitle;

@end

NS_ASSUME_NONNULL_END
