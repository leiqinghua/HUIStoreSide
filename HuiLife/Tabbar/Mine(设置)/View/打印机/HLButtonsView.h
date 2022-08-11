//
//  HLButtonsView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/26.
//

#import <UIKit/UIKit.h>

@class HLButtonsView;

@protocol HLButtonsViewDelegate <NSObject>

-(void)buttonsView:(HLButtonsView *)view selectArray:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLButtonsView : UIView

@property (weak,nonatomic)id<HLButtonsViewDelegate>delegate;

-(instancetype)initWithTitles:(NSArray *)titles;

-(void)setSelectWithArray:(NSArray *)selectArr;

@end

NS_ASSUME_NONNULL_END
