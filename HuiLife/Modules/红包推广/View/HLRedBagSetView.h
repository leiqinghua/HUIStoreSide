//
//  HLRedBagSetView.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLRedBagInfo;
@protocol HLRedBagSetViewDelegate;

@interface HLRedBagSetView : UIView
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSString *timeTitle;
@property(nonatomic, strong) NSString *rangeTitle;
@property(nonatomic, copy) NSString *priceTitle;
@property(nonatomic, copy) NSString *numTitle;
@property(nonatomic, copy) NSString *pricePlace;
@property(nonatomic, copy) NSString *numPlace;
//三个
@property(nonatomic, strong) NSArray *times;
@property(nonatomic, strong) HLRedBagInfo *redBagInfo;
@property(nonatomic, weak) id<HLRedBagSetViewDelegate>delegate;

- (void)seletTimeAtIndex:(NSInteger)index;

- (void)selectRangeAtIndex:(NSInteger)index;

@end


@protocol HLRedBagSetViewDelegate <NSObject>

- (void)textFieldDidEdit:(UITextField *)textField price:(BOOL)price;

@end

NS_ASSUME_NONNULL_END
