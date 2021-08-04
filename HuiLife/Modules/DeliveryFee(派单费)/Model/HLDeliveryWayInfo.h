//
//  HLDeliveryWayInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLDeliveryRule;
@interface HLDeliveryWayInfo : NSObject
@property(nonatomic, copy) NSString *pic;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *detail;
@property(nonatomic, copy) NSString *order;
@property(nonatomic, copy) NSString *rule;
@property(nonatomic, assign) BOOL on;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, strong) NSArray<NSArray<HLDeliveryRule *> *> *eleRoles;
@property(nonatomic, assign) CGFloat cellHight;
@property(nonatomic, copy) NSString *startPrice;
@property(nonatomic, assign) BOOL enable;//是否可用
@property(nonatomic, assign) BOOL config;//是否重组
@property(nonatomic, assign) NSInteger Id;
@end

@interface HLDeliveryRule : NSObject
@property(nonatomic, copy) NSString *col01;
@property(nonatomic, copy) NSString *col02;
@end

NS_ASSUME_NONNULL_END
