//
//  HLRulesDescController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLBaseViewController.h"


typedef void(^HLRuleDescSelectBlock)(NSArray*texts,NSString * addTexts,NSString * ids,NSArray * rules);

@interface HLRulesDescController : HLBaseViewController

@property(nonatomic,copy)HLRuleDescSelectBlock selectBlock;

@property(nonatomic,strong)NSArray * lastRules;

@end

