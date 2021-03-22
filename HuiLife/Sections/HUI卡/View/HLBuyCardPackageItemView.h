//
//  HLBuyCardPackageItemView.h
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLBuyCardPackageViewItem : NSObject

@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *gife;
@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) BOOL isCustom; // 是否是自定义
@property (nonatomic, assign) BOOL select;

@end

@interface HLBuyCardPackageItemView : UIView

@property (nonatomic, strong) HLBuyCardPackageViewItem *item;

- (void)resetViewsState;

@end

NS_ASSUME_NONNULL_END
