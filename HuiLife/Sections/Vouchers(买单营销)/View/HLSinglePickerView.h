//
//  HLSinglePickerView.h
//  HuiLife
//
//  Created by 王策 on 2019/9/2.
//

#import <UIKit/UIKit.h>

typedef void (^HLSinglePickerBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface HLSinglePickerView : UIView

+ (void)showCurrentTitle:(NSString *)currentTitle titles:(NSArray *)titles pickerBlock:(HLSinglePickerBlock)pickerBlock;

@end

NS_ASSUME_NONNULL_END
