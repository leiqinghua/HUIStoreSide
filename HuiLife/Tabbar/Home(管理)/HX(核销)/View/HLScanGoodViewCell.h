//
//  HLScanGoodViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2019/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLScanGoodModel;
@interface HLScanGoodViewCell : UITableViewCell

@property(nonatomic, strong) HLScanGoodModel *goodModel;

@end


@interface HLScanGoodModel : NSObject

@property(nonatomic, copy) NSString *order_id;

@property(nonatomic, copy) NSString *pro_name;

@property(nonatomic, copy) NSString *pro_pic;
//原价
@property(nonatomic, copy) NSString *price_y;

/// 销售价
@property(nonatomic, copy) NSString *price;

/// 商品数量
@property(nonatomic, assign) NSInteger num;

/// 截止日期
@property(nonatomic, copy) NSString *closing_date;

/// 核销状态 0未核销 1已核销
@property(nonatomic, assign) NSInteger is_hx;

- (NSAttributedString *)priceAttr;

@end

NS_ASSUME_NONNULL_END
