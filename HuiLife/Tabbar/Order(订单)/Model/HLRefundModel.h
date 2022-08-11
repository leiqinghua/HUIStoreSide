//
//  HLRefundModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/24.
//

#import "HLRefundGoodModel.h"
#import <Foundation/Foundation.h>

@interface HLRefundModel : NSObject

@property (copy, nonatomic) NSString *buy_store_id;

@property (copy, nonatomic) NSString *extension_advertiser_id;

@property (copy, nonatomic) NSString *Id;

@property (copy, nonatomic) NSString *prople_num;

@property (copy, nonatomic) NSString *serial_number;

@property (copy, nonatomic) NSString *source;

@property (copy, nonatomic) NSString *store_name;

@property (copy, nonatomic) NSString *user_id;

@property (copy, nonatomic) NSString *zf_status;

@property (copy, nonatomic) NSString *zhuohao;

@property (strong, nonatomic) NSArray *pro_info;

@property (copy, nonatomic) NSString *deskNumText;

@property (assign, nonatomic) BOOL is_zd; //是否是整单退款

@property (assign, nonatomic) NSInteger totleCount;

@property (strong, nonatomic) NSAttributedString *idAttr;

@property (strong, nonatomic) NSAttributedString *tipAttr;

@end
