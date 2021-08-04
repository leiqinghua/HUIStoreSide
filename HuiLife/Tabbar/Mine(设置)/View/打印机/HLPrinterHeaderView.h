//
//  HLPrinterHeaderView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//

#import <UIKit/UIKit.h>

@class HLPrinterHeaderView;

@protocol HLPrinterHeaderViewDelegate <NSObject>

-(void)headerView:(HLPrinterHeaderView *)header didSelectType:(NSString *)type button:(UIButton *)sender;

@end

@interface HLPrinterHeaderView : UIView

@property (weak,nonatomic)id<HLPrinterHeaderViewDelegate>delegate;

//1.自动打印 2.手动 3.都选 4.都不选
@property (copy,nonatomic)NSString *selectType;

- (void)setBtnSelected:(BOOL)selected button:(UIButton *)sender;

@end

