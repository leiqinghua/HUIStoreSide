//
//  HLRuleDescHeader.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import <UIKit/UIKit.h>

@class HLRuleModel;
@class HLRuleDescHeader;
@protocol HLRuleDescHeaderDelegate <NSObject>

-(void)ruleHeader:(HLRuleDescHeader *)header addRule:(HLRuleModel *)model;

@end

@interface HLRuleDescHeader : UIView

@property(nonatomic,weak)id<HLRuleDescHeaderDelegate>delegate;

@end

