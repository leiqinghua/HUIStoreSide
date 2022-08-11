//
//  HLMineFooterView.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/11.
//

#import <UIKit/UIKit.h>



@protocol HLMineFooterViewDelegate <NSObject>

-(void)exitLoginWithButtonClick:(UIButton *)sender;

@end

@interface HLMineFooterView : UIView

@property(nonatomic,weak)id<HLMineFooterViewDelegate>delegate;

@end

