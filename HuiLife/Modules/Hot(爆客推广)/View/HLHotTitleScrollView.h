//
//  HLHotTitleScrollView.h
//  HuiLife
//
//  Created by 雷清华 on 2020/2/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLHotTitleScrollView;
@protocol HLHotTitleScrollViewDelegate <NSObject>

- (void)hl_hotTitleView:(HLHotTitleScrollView *)titleView selectAtIndex:(NSInteger)index;

@end

@interface HLHotTitleScrollView : UIView

@property(nonatomic, strong) NSArray *titles;

@property(nonatomic, weak) id<HLHotTitleScrollViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
