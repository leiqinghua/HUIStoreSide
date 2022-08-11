//
//  HLFinanceHeaderView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import <UIKit/UIKit.h>
#import "HLFinanceButton.h"

@protocol HLFinanceHeaderViewDelegate <NSObject>

-(void)clickFinanceButton:(HLFinanceButton *)sender;

-(void)selectDateWithDate:(NSString *)date;

//立即提现
-(void)hlFinanceWithMoney:(NSString *)money;
@end

@interface HLFinanceHeaderView : UIView

@property(weak,nonatomic)id<HLFinanceHeaderViewDelegate>delegate;

@property(strong,nonatomic)NSDictionary * info;

@property(assign,nonatomic)BOOL isUp;

-(void)changeFrameWithUp:(BOOL)up superView:(UIView*)view;

@end

