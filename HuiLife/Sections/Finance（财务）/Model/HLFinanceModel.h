//
//  HLFinanceModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import <Foundation/Foundation.h>

@interface HLFinanceModel : NSObject
//显示的钱
@property(copy,nonatomic)NSString *keti;
//时间
@property(copy,nonatomic)NSString *month;
//待入账，已结算
@property(copy,nonatomic)NSString *name;
//支出
@property(copy,nonatomic)NSString *zhichu;
//收入
@property(copy,nonatomic)NSString *shouru;

//收入支出的文本
@property(copy,nonatomic)NSString *compomentStr;
//是否是已结算
@property(assign,nonatomic)BOOL isEntried;
//可提的钱的文本显示
@property(copy,nonatomic)NSString * money;

@end

//已结算
@interface HLEntriedModel : NSObject

@property(copy,nonatomic)NSString* Id;

@property(copy,nonatomic)NSString* input_time;

@property(assign,nonatomic)NSInteger is_success;

@property(copy,nonatomic)NSString* money;

@property(copy,nonatomic)NSString* status;

@property(copy,nonatomic)NSString* moneyText;

@property(assign,nonatomic)BOOL isSuccess;

@end
