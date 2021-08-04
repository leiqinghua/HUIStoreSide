//
//  HLHotSekillGoodModel.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillGoodModel : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *priceTitle;
@property (nonatomic, assign) double orgPrice;
@property (nonatomic, assign) double price;

@property (nonatomic, copy) NSString *popularize; // 一般
@property (nonatomic, copy) NSString *popularColor;

@property (nonatomic, assign) NSInteger orderCnt;
@property (nonatomic, assign) NSInteger usedCnt;
@property (nonatomic, assign) NSInteger hitsCnt;

// 上架的状态具体分为这四种（1未开售 2已过期 3已售完 4销售中） 5已下架
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) NSInteger stateCode;

// 1 上架  2 下架
@property (nonatomic, assign) NSInteger upOrDown;

// 是否已经开始推广了
@property (nonatomic, assign) BOOL isSelected;

///
@property (nonatomic, strong) NSAttributedString *priceAttr;

/// 自己加的，标明是否选中
@property (nonatomic, assign) BOOL userSelect;

//展架提示
@property(nonatomic,copy)NSString * displayRack;

@property(nonatomic,copy)NSString * qrCode;

@property(nonatomic,copy)NSString * wechatMoments;

@property(nonatomic,copy)NSString * friendCircle;
@end

NS_ASSUME_NONNULL_END
