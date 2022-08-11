//
//  HLFeeInputView.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLFeeInputView;
@protocol HLFeeInputViewDelegate <NSObject>

- (void)inputView:(HLFeeInputView *)inputView editText:(NSString *)text;

@optional

- (void)inputView:(HLFeeInputView *)inputView didEndText:(UITextField *)textField;

- (BOOL)inputView:(HLFeeInputView *)inputView textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end

@interface HLFeeInputView : UIView

@property(nonatomic, weak) id<HLFeeInputViewDelegate> delegate;

@property(nonatomic, assign) BOOL enableEdit;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, assign) CGFloat inputWidth;

@property(nonatomic, assign) CGFloat inputHight;

@property(nonatomic, copy) NSString *text;

@property(nonatomic, copy) NSString *tip;

@property(nonatomic, copy) NSString* placeHolder;

@property(nonatomic, strong) NSAttributedString *titleAttr;

@property(nonatomic, assign) UIKeyboardType keyBoardType;

@end


NS_ASSUME_NONNULL_END
