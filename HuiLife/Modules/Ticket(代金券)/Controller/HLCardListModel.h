//
//  HLCardListModel.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLCardListModel : NSObject

//    售价描述
@property(nonatomic,copy)NSString *  salePrice;

@property(nonatomic,copy)NSString *  price;

//原价
@property(nonatomic,copy)NSString *  originaPrice;
//    卡次数
@property(nonatomic,assign)NSInteger cardTimes;
//    ‘次’
@property(nonatomic,copy)NSString *  timesDesc;
//    卡名称
@property(nonatomic,copy)NSString *  cardName;
//    卡id
@property(nonatomic,copy)NSString *  cardId;
//    上下架状态 0下架 1 上架
@property(nonatomic,assign)NSInteger state;
//    vip返回
@property(nonatomic,copy)NSString *  cardVip;
//    已售多少
@property(nonatomic,copy)NSString *  saleDesc;
//    推广效果
@property(nonatomic,copy)NSString *  marketEffect;
//推广效果说明 0,1,2 0一般 1较好 2 极好
@property(nonatomic,assign)NSInteger marketType;
//销售状态
@property(nonatomic,copy)NSString *  statusDesc;
//销售状态说明 0,销售中 1 已过期 2 已下架 3 已售完 4 未开售
@property(nonatomic,assign)NSInteger couponStatus;
//分享说明
@property(nonatomic,strong)NSDictionary *  shareData;
//推广文字颜色
@property(nonatomic,strong)UIColor * promoteColor;

@property(nonatomic,strong)NSAttributedString* numAttr;

//展架提示
@property(nonatomic,copy)NSString * displayRack;

@property(nonatomic,copy)NSString * qrCode;

@property(nonatomic,copy)NSString * wechatMoments;

@property(nonatomic,copy)NSString * friendCircle;

@end

//卡推广
@interface HLCardPromote : HLCardListModel
//    对象id
@property(nonatomic,copy)NSString *  objId;
//    是否推广中 0 微推广 1 推广中
@property(nonatomic,assign)BOOL isExten;

@property(nonatomic,copy)NSString * extenId;
@end

@interface  HLCardSelectModel:HLCardListModel

@property(nonatomic,assign)BOOL select;
//是否已选择
@property(nonatomic,assign)BOOL isExtConupon;

@end


NS_ASSUME_NONNULL_END
