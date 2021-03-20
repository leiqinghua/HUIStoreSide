//
//  SettlementAlertView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/13.
//

#import <UIKit/UIKit.h>

//结算状态
typedef enum : NSUInteger {
    SettlementTypeDefault,
    SettlementTypeCheck,
    SettlementTypeSuccess,
    SettlementTypeFailed,
} SettlementType;

@interface SettlementAlertView : UIView

+(instancetype)share;

-(void)showWihtType:(SettlementType)type title:(NSString *)title subTitle:(NSString *)subTitle;
@end
