//
//  HLCalculateDiscountView.h
//  HuiLife
//
//  Created by 雷清华 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLCalculateDiscountView : UIView

//设置两个值
- (void)setValueWithInt:(NSInteger)intValue dotValue:(NSInteger)dotValue;

//获取两个值
- (NSArray *)getDiscountValues ;

@property(nonatomic, copy) NSString *maxValue;

@property(nonatomic, copy) NSString *minValue;

@property(nonatomic, copy) NSString *maxValueText;

@property(nonatomic, copy) NSString *minValueText;

@end

NS_ASSUME_NONNULL_END
