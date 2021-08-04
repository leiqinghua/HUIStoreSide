//
//  HLSendOrderMoneyInputInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import <Foundation/Foundation.h>
#import "HLRightInputViewCell.h"

@class HLSendOrderMoneyInputInfo;

NS_ASSUME_NONNULL_BEGIN
@interface HLSendOrderMoneyInfo : NSObject

@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, assign) NSInteger startSendMoney;
@property (nonatomic, assign) NSInteger freeMoney;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sendId; // 配送费id
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, copy) NSArray <HLSendOrderMoneyInputInfo *>*list;

/// 获取的section0Arr
@property (nonatomic, copy) NSArray <HLRightInputTypeInfo *>*section0Arr;
/// 获取的section1Arr
@property (nonatomic, strong) NSMutableArray <HLSendOrderMoneyInputInfo *>*section1Arr;

@end

@interface HLSendOrderMoneyInputInfo : NSObject

/// 单位都是分
@property (nonatomic, assign) NSInteger startMoney;
@property (nonatomic, assign) NSInteger endMoney;
@property (nonatomic, assign) NSInteger sendMony;

///// 输入的值
@property (nonatomic, copy) NSString *startMoneyText;
@property (nonatomic, copy) NSString *endMoneyText;
@property (nonatomic, copy) NSString *sendMoneyText;

@end

NS_ASSUME_NONNULL_END
