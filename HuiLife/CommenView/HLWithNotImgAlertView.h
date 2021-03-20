//
//  HLWithNotImgAlertView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/27.
//

#import <UIKit/UIKit.h>

typedef void(^Option)(void);

typedef void(^OptionWithPargram)(NSString * text);
@interface HLWithNotImgAlertView : UIView

-(instancetype)initWithTitle:(NSString *)title hight:(CGFloat) hight concern:(Option)concern  cancel:(Option)cancel;


-(instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)place hight:(CGFloat) hight concern:(OptionWithPargram)concern cancel:(Option)cancel;


-(instancetype)initWithTitle:(NSString *)title text:(NSString *)text placeHolder:(NSString *)place hight:(CGFloat) hight concern:(OptionWithPargram)concern cancel:(Option)cancel;


-(instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle lastitle:(NSString *)lasttitle subColor:(UIColor *)color lastColor:(UIColor *)lastcolor hight:(CGFloat) hight concern:(Option)concern cancel:(Option)cancel;

//两个title
-(instancetype)initWithTitle:(NSString *)title subTitle:(NSString *) subTitle hight:(CGFloat) hight subColor:(UIColor *)color oncern:(Option)concern cancel:(Option)cancel;

-(void)setCancelTitle:(NSString *)title concern:(NSString *)concernTit;
@end
