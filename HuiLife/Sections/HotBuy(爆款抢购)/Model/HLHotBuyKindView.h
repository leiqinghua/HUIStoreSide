//
//  HLHotBuyKindView.h
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import <UIKit/UIKit.h>
#import "HLHotBuyKindModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLHotBuyKindCallBack)(NSString *selectName, NSInteger firstId, NSInteger secondId, NSInteger thirdId);

@interface HLHotBuyKindView : UIView

+ (void)showHotBuyKindView:(NSArray *)kinds allDatas:(NSArray *)allDatas callBack:(HLHotBuyKindCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
