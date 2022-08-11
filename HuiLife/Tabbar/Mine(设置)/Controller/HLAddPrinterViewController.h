//
//  HLAddPrinterViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/23.
//添加打印机

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveSuccess)(NSString *printerName);

@interface HLAddPrinterViewController : HLBaseViewController
//是否是添加打印机页面
@property (assign,nonatomic)BOOL isAdd;

@property(strong,nonatomic)NSDictionary * printerInfo;

@property (copy,nonatomic)NSString * storeID;

@property (copy,nonatomic)SaveSuccess save;

@end

NS_ASSUME_NONNULL_END
