//
//  HLFinanceButton.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    HLFinanceButtonFirstType,
    HLFinanceButtonNormalType,
} HLFinanceButtonType;

@class HLFinanceButton;

@protocol HLFinanceButtonDelegate <NSObject>

-(void)clickFinanceButton:(HLFinanceButton *)sender;

@end
@interface HLFinanceButton : UIView

@property(weak,nonatomic)id<HLFinanceButtonDelegate>delegate;

@property(strong,nonatomic)UILabel * value;

-(instancetype)initWithTitle:(NSString *)title type:(HLFinanceButtonType)type;

@end

