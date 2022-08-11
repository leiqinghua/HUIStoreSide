//
//  HLRefundGoodModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/24.
//

#import <Foundation/Foundation.h>

@interface HLRefundGoodModel : NSObject

@property (copy, nonatomic) NSString *hongbao;

@property (copy, nonatomic) NSString *Id;

@property (copy, nonatomic) NSString *merchant_cash;

@property (copy, nonatomic) NSString *num;

@property (copy, nonatomic) NSString *param;

@property (copy, nonatomic) NSString *pic;

@property (copy, nonatomic) NSString *price;

@property (copy, nonatomic) NSString *pro_id;

@property (copy, nonatomic) NSString *pro_name;

@property (copy, nonatomic) NSString *pro_num;

@property (copy, nonatomic) NSString *rebate_type;

@property (copy, nonatomic) NSString *sd_price;

@property (copy, nonatomic) NSString *ss_price;

@property (copy, nonatomic) NSString *use_balance;

@property (copy, nonatomic) NSString *weixin_price2;

@property (copy, nonatomic) NSString *zhekou;

@property (copy, nonatomic) NSString *priceText;

@property (copy, nonatomic) NSString *numText;
//选择的数量
@property (assign, nonatomic) NSInteger selectNum;

@end
