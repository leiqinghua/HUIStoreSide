//
//  HLRightInputViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import <UIKit/UIKit.h>
#import "HLBaseInputViewCell.h"

@interface HLRightInputTypeInfo : HLBaseTypeInfo

/// 是否可以输入
@property (nonatomic, assign) BOOL canInput;

/// 是否展示右边箭头 或者其它图片
@property (nonatomic, assign) BOOL showRightArrow;

/// 右边显示的文字，可能为单位, 这个有值的时候，那么 showRightArrow 无效
@property (nonatomic, copy) NSString *rightText;

/// 键盘类型
@property (nonatomic, assign) UIKeyboardType keyBoardType;

/// 默认输入文字
@property (nonatomic, copy) NSString *placeHoder;

/// 是否可以输入0，针对于 decimal 键盘输入金额时的判断
@property (nonatomic, assign) BOOL canInputZero;

/// 右边的图片，如果不赋值，默认为箭头
@property (nonatomic, strong) UIImage *rightImage;

@property (nonatomic, assign) BOOL rightClick;

@end


NS_ASSUME_NONNULL_BEGIN

@class HLRightInputViewCell;

@protocol HLRightInputViewCellDelegate <NSObject>

@optional
/// 输入框值改变
- (void)inputViewCell:(HLRightInputViewCell *)cell textChanged:(HLRightInputTypeInfo *)inputInfo;

//点击右边按钮
- (void)inputViewCell:(HLRightInputViewCell *)cell rightImgClick:(HLRightInputTypeInfo *)inputInfo;

@end

@interface HLRightInputViewCell : HLBaseInputViewCell

@property (nonatomic, weak) id <HLRightInputViewCellDelegate> delegate;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIImageView *arrowImgV;

@end

NS_ASSUME_NONNULL_END
