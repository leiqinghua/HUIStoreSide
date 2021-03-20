//
//  HLDisplayTitleView.h
//  HuiLife
//
//  Created by 雷清华 on 2019/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLDisplayTitleView;
@protocol HLDisplayTitleViewDelegate <NSObject>

- (void)displayView:(HLDisplayTitleView *)displayView selectAtIndex:(NSInteger)index;

@end


@interface HLDisplayTitleView : UIView

@property(nonatomic, strong) NSArray *titles;

@property(nonatomic, weak)id<HLDisplayTitleViewDelegate>delegate;

- (void)clickWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
