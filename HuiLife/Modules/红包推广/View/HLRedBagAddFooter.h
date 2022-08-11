//
//  HLRedBagAddFooter.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/16.
//

#import <UIKit/UIKit.h>
#import "HLRedBagSetView.h"
NS_ASSUME_NONNULL_BEGIN
@class HLRedBagInfo;
@interface HLRedBagAddFooter : UIView
@property(nonatomic, strong) HLRedBagInfo *redBagInfo;
@property(nonatomic, weak) id<HLRedBagSetViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
