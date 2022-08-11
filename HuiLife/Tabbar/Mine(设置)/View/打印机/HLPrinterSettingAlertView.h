//
//  HLPrinterSettingAlertView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    HLPrinterViewStyleDefault,//列表试的
    HLPrinterViewStyleScroll,//滚动式的
} HLPrinterViewStyle;

NS_ASSUME_NONNULL_BEGIN

typedef void(^CallBackBlock)(NSInteger clickIndex,NSInteger selectIndex);

//blueTooth 主要针对打印列表
typedef void(^MutableSelectBlock)(BOOL blueTooth,NSArray * selects);

@interface HLPrinterSettingAlertView : UIView

//单选
+ (void)showWithTitle:(NSString *)title type:(HLPrinterViewStyle)style dataSource:(NSArray *)dataSource defaultIndex:(NSInteger)index callBack:(CallBackBlock)callBack;

//多选
+ (void)showWithTitle:(NSString *)title type:(HLPrinterViewStyle)style dataSource:(NSArray *)dataSource  selects:(MutableSelectBlock)callBack;


@end



@class HLPrinterItemModel;

typedef void(^ClickButton)(void);

@interface HLPrinterSettingAlertViewCell : UITableViewCell

@property (assign,nonatomic)BOOL isSelect;

@property (copy,nonatomic)ClickButton click;

@property (strong,nonatomic)HLPrinterItemModel * model;

@end



@interface HLPrinterItemModel : NSObject

@property (copy,nonatomic)NSString * leftPic;

@property (copy,nonatomic)NSString * title;

@property(copy,nonatomic)NSString *Id;
//是不是蓝牙
@property(assign,nonatomic) BOOL isBluetooth;

@property(assign,nonatomic) BOOL selected;

@end

NS_ASSUME_NONNULL_END
