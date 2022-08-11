//
//  HLSubOrderLayout.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/23.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseOrderLayout.h"

NS_ASSUME_NONNULL_BEGIN


@interface HLScanOrderLayout : HLBaseOrderLayout

/// 部分退款是否展开
@property(nonatomic, assign) BOOL partOpen;

@property(nonatomic, assign) NSInteger partSection;

@property(nonatomic, assign) NSInteger partRows;
//地址高度
@property(nonatomic, assign) CGFloat addressHight;
//店内点餐（和地址 只能存在一个）
@property(nonatomic, assign) CGFloat deskHight;
//联系人高度
@property(nonatomic, assign) CGFloat contactHight;
//固定高度
@property(nonatomic, assign) CGFloat fixedHight;
//备注高度
@property(nonatomic, assign) CGFloat remarkHeight;

@end

/// 商超
@interface HLConShopLayout : HLScanOrderLayout

@end

///  秒杀团购(1,16)
@interface HLSpikeBuyLayout : HLBaseOrderLayout



@end

///  优惠买单（4）
@interface HLPreferentialLayout : HLBaseOrderLayout



@end

/// HUI卡（5）
@interface HLHUICardLayout : HLBaseOrderLayout



@end

/// 汽车服务(13)
@interface HLCarServiceLayout : HLBaseOrderLayout


@end

/// 快捷买单(30)
@interface HLFastBuyLayout : HLBaseOrderLayout



@end

/// 折扣买单(39)
@interface HLDiscountBuyLayout : HLBaseOrderLayout

@end

/// 代金券(38)
@interface HLVoucherBuyLayout : HLBaseOrderLayout

@end

/// 计次卡(37)
@interface HLNumberCardLayout : HLBaseOrderLayout

@end

//爆款（44）
@interface HLHotShopLayout : HLScanOrderLayout

@end

//秒杀拼团 43
@interface HLSpikeGroupLayout : HLScanOrderLayout

@end
NS_ASSUME_NONNULL_END
