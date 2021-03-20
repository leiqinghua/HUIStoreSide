//
//  HLRuleDescViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLRightInputViewCell.h"


@interface HLRuleDescTypeInfo : HLBaseTypeInfo
//规则
@property(nonatomic,strong)NSArray * rules;

@property(nonatomic,copy)NSString * placeHolder;

@end


@interface HLRuleDescViewCell : HLBaseInputViewCell


@end

