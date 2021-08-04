//
//  HLScanYMMainInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLScanYMGoodInfo;

@interface HLScanYMMainInfo : NSObject

@property(nonatomic, copy) NSString *order_id;
@property(nonatomic, copy) NSString *closing_date;
@property(nonatomic, assign) BOOL is_hx;
@property(nonatomic, copy) NSString *state_txt;
@property(nonatomic, copy) NSString *ziti_info;
@property(nonatomic, strong) NSArray<HLScanYMGoodInfo *> *pro_info;

@property(nonatomic, assign) CGFloat orderInfoHight;

@end

@interface HLScanYMGoodInfo : NSObject
@property(nonatomic, copy) NSString *pro_name;
@property(nonatomic, copy) NSString *pro_param;
@property(nonatomic, copy) NSString *pro_pic;
@property(nonatomic, copy) NSString *price_y;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *num;

@end

NS_ASSUME_NONNULL_END
