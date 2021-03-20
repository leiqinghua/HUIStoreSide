//
//  HLImageSmallControlView.h
//  HuiLife
//
//  Created by 王策 on 2019/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLImageSmallControlView;
@protocol HLImageSmallControlViewDelegate <NSObject>

- (void)controlView:(HLImageSmallControlView *)controlView selectIndex:(NSInteger)index;

@end

@interface HLImageSmallControlView : UIView

@property (nonatomic, weak) id <HLImageSmallControlViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame assets:(NSArray *)assets;

- (void)configSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
