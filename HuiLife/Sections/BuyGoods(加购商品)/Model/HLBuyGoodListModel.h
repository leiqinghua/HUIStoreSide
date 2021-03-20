//
//  HLBuyGoodListModel.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLBuyGoodListModel : NSObject

//1销售中 2已售完 3未开售 4已过期 5已下架
@property (nonatomic, assign) NSInteger status;
//0下架 1上架
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *stateTitle;

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsPic;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *validDate;
@property (nonatomic, copy) NSString *addSum;
@property (nonatomic, copy) NSString *priceTitle;

///
@property (nonatomic, strong) NSAttributedString *priceAttr;

@end

NS_ASSUME_NONNULL_END
