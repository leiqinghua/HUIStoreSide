//
//  LZCustomLimitDatePicker.h
//  smart_small
//
//  Created by LZ on 2017/7/7.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZPickViewDefine.h"
#import "LZPickTopView.h"


typedef enum : NSUInteger {
    
    LZCustomLimitDateDefault, //年，月，日全显示
    LZCustomLimitDateYear, //只显示年
    LZCustomLimitDateYAM, //显示年，月
    
} LZCustomLimitDatePickerType;

@protocol LZCustomLimitDatePickerDelegate <NSObject>
@optional
//选中日期
-(void)didSelectedDateString:(NSString *)dateString;
//取消日期
-(void)cancelDatePicker;

@end

@interface LZCustomLimitDatePicker : UIView
//代理
@property (nonatomic ,weak)id<LZCustomLimitDatePickerDelegate>delegate;

@property(nonatomic,strong)LZPickTopView * topView;
//显示类型，默认 LZCustomLimitDateDefault
@property(nonatomic, assign) LZCustomLimitDatePickerType pickerType;
//block回掉
@property(nonatomic,copy)void (^LimitDatePickerDidSelectedDateString)(NSString *dateString);

//+ (instancetype)initCustomLimitDatePicker;
//设置类型
- (instancetype)initWithPickerType:(LZCustomLimitDatePickerType)pickerType ;
/*  设置Picker显示 最小-最大范围  默认范围为:1991-01-01 2300:12:31
 *  maxString 最大时间
 *  minString 最小时间
 *  dateStringBlock 选择日期回调
 */
- (void)showWithMaxDateString:(NSString *)maxString withMinDateString:(NSString *)minString didSeletedDateStringBlock:(void (^)(NSString *dateString))dateStringBlock;


@end
