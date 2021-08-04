//
//  HLTextField.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/16.
//

#import <UIKit/UIKit.h>

@interface HLTextField : UIView

@property(assign,nonatomic)BOOL isPassword;

@property(strong,nonatomic)UITextField * textField;

@property(assign,nonatomic)UIKeyboardType keyboardType;

-(instancetype)initWithImage:(NSString *)imgName placeHolder:(NSString *)place funImgNormal:(NSString *)funImage select:(NSString *)selectImage;

- (NSString *)configeText;
@end
