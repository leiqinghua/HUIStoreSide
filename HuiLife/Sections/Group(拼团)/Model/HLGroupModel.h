//
//  HLGroupModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/14.
//

#import <Foundation/Foundation.h>


@interface HLGroupModel : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *proId;

@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double orgPrice;
@property (nonatomic, assign) double groupPrice;

@property (nonatomic, copy) NSString * groupPeoNum;

@property (nonatomic, copy) NSString * buyCnt;

@property (nonatomic, copy) NSString *popularColor;

// 上架的状态具体分为这四种（1未开售 2已过期 3已售完 4销售中） 5已下架
@property (nonatomic, copy) NSString *state;

@property (nonatomic, assign) NSInteger stateCode;

// 0 下架  1 上架
@property (nonatomic, assign) NSInteger upState;

@property (nonatomic, copy) NSString *goodFriend;//好友

@property (nonatomic, copy) NSString *wechatMoments;//朋友圈

@property (nonatomic, copy) NSString *qrCode;
///
@property (nonatomic, strong) NSAttributedString *priceAttr;


@end


@interface HLGroupSelectModel : HLGroupModel

//是否是已经选择的
@property (nonatomic, assign) BOOL isSelected;

//是否点击了
@property (nonatomic, assign) BOOL clicked;

@property (nonatomic, assign) NSInteger orderCnt;

@property (nonatomic, assign) NSInteger usedCnt;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, assign) double price;

@property (nonatomic, copy) NSString * orderNumText;

@property (nonatomic, copy) NSString * useNumText;

@end
