//
//  HLMineHeaderView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/21.
//

#import <UIKit/UIKit.h>

@class HLMineHeaderView;

@protocol HLMineHeaderViewDelegate <NSObject>

@end


@interface HLMineHeaderView : UIView

@property (weak,nonatomic)id<HLMineHeaderViewDelegate>delegate;

/// 配置用户有效期提示
- (void)configUserTimeTipString:(NSString *)timeTipString;

-(void)updateData;

@end

