//
//  HLOrderTitleView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/3.
//

#import <UIKit/UIKit.h>

@class HLOrderTitleView;

@protocol  HLOrderTitleViewDelegate <NSObject>

- (void)headView:(HLOrderTitleView *)headView selectItem:(UIButton *)selectBtn;

@end

@interface HLOrderTitleView : UIView

@property (weak,nonatomic)id<HLOrderTitleViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)setSelectIndex:(NSInteger)index;

-(void)configerNumbers:(NSArray *)numbers;

@end

