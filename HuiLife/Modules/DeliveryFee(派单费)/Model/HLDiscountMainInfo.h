//
//  HLDiscountMainInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLDiscountInfo;

@interface HLDiscountMainInfo : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *open_title;
@property(nonatomic, copy) NSString *open_label;
@property(nonatomic, assign) BOOL is_open;
@property(nonatomic, assign) NSInteger limit_num;
@property(nonatomic, strong) NSArray<HLDiscountInfo *> *discount_set;
@end


@interface HLDiscountInfo : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *interval;
@property(nonatomic, copy) NSString *label;
@property(nonatomic, copy) NSString *unit;
@property(nonatomic, copy) NSString *start_price;
@property(nonatomic, copy) NSString *end_price;
@property(nonatomic, copy) NSString *discount;
@property(nonatomic, assign) BOOL add;

@property(nonatomic, strong) NSMutableDictionary *pargrams;
@property(nonatomic, copy) NSString *start_key;
@property(nonatomic, copy) NSString *end_key;
@property(nonatomic, copy) NSString *discount_key;
@property(nonatomic, copy) NSString *toasStr;
@property(nonatomic, assign) BOOL canSave;


- (BOOL)check;
@end

NS_ASSUME_NONNULL_END
