//
//  HLHotSubClassView.h
//  HuiLife
//
//  Created by 雷清华 on 2020/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLHotSubClassView;
@protocol HLHotSubClassViewDelegate <NSObject>

- (void)hl_hotSubView:(HLHotSubClassView *)hotSubView selectAtIndex:(NSInteger)index;

@end

@interface HLHotSubClassView : UIView

@property(nonatomic, strong) NSArray *titles;

@property(nonatomic, weak) id<HLHotSubClassViewDelegate> delegate;

- (void)hotSubClassViewClickAtIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END
