//
//  HLAlertView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HLAlertViewDefaultType,
} HLAlertViewButtonType;

typedef void(^HLAlertCallBack)(NSInteger index);

@interface HLAlertView : UIView

+ (void)alertWithTitle:(NSString *)title subTitltle:(NSString *)sub type:(HLAlertViewButtonType)type;

+(void)showAlertViewTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonColors:(NSArray *)colors callBack:(HLAlertCallBack)callBack;

//默认颜色
+(void)showAuthAlertViewTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles callBack:(HLAlertCallBack)callBack;

@end

