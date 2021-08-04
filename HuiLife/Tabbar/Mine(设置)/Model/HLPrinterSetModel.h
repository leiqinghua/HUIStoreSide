//
//  HLPrinterSetModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//打印机设置页面model

#import <Foundation/Foundation.h>

@interface HLPrinterSetModel : NSObject

@property (copy,nonatomic)NSString * leftPic;

@property (copy,nonatomic)NSString * rightPic;

@property (copy,nonatomic)NSString * title;

@property (copy,nonatomic)NSString * subTitle;

//添加打印机中用到
@property (copy,nonatomic)NSString * placeholder;

//输入的最大字符数(0不限)
@property (assign,nonatomic)NSInteger max_inputNum;

//是否是开关类型
@property (assign,nonatomic)BOOL isSwitch;
//swith 的状态
@property (assign,nonatomic)BOOL isON;
//是否在连接
@property (assign,nonatomic)BOOL isLoading;

//蓝牙打印机的uuid(唯一标识)
@property (copy,nonatomic)NSString * uuid;

@end

