//
//  HLNextAddPrinterController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/23.
//

#import <UIKit/UIKit.h>

//打印机内容设置，带回是否开启
typedef void(^PrinterContentCallBack)(BOOL isOpen);

NS_ASSUME_NONNULL_BEGIN

@interface HLNextAddPrinterController : HLBaseViewController

@property (assign,nonatomic)BOOL isAdd;

@property (strong,nonatomic)NSMutableDictionary * pargram;

@property (strong,nonatomic)NSDictionary *printerInfo;

@property (copy,nonatomic)NSString * storeID;

@property (copy,nonatomic)PrinterContentCallBack callBack;

@end

NS_ASSUME_NONNULL_END
