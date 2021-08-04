//
//  HLOrderPriceDescView.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLOrderOpetionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    
    HLOrderPriceDescUserType,//用户收到退款金额
    
    HLOrderPriceDescStoreType,//商家承担退款金额
    
    HLOrderPriceDescSettleType,//结算金额
    
} HLOrderPriceDescType;

@interface HLOrderPriceDescView : UITableViewHeaderFooterView

@property(nonatomic, assign) BOOL open;

@property(nonatomic, copy) NSString *money;

@property(nonatomic, assign) HLOrderPriceDescType type;

@property(nonatomic, weak) id<HLOrderOpetionDelegate> delegate;

- (instancetype)initWithType:(HLOrderPriceDescType)type;

@end

NS_ASSUME_NONNULL_END
