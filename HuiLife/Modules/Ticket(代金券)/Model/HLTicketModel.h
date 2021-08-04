//
//  HLTicketModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/5.
//

#import <Foundation/Foundation.h>


@interface HLTicketModel : NSObject


@property(nonatomic,assign)CGFloat cellHight;

//---------
@property(nonatomic,copy)NSString* couponPrice;
//￥
@property(nonatomic,copy)NSString* couponIdent;
//售价的价格
@property(nonatomic,copy)NSString* price;

//    使用满减描述
@property(nonatomic,copy)NSString* couponDesc;

//售价
@property(nonatomic,copy)NSString* salePrice;
//消费满送
@property(nonatomic,copy)NSString* giftDesc;
//    使用多少次
@property(nonatomic,copy)NSString* useDesc;
//领取多少次
@property(nonatomic,copy)NSString* receiveDesc;
//浏览多少次
@property(nonatomic,copy)NSString* browseDesc;
//优惠券id
@property(nonatomic,copy)NSString* couponId;
//推广效果
@property(nonatomic,copy)NSString* marketEffect;
//推广状态 0,1,2 0一般 1较好 2 极好
@property(nonatomic,assign)NSInteger marketType;
//优惠券状态0,销售中 1 已过期 2 已下架 3 已售完 4未开售
@property(nonatomic,assign)NSInteger couponStatus;
//销售状态
@property(nonatomic,copy)NSString* statusDesc;

//0下架 1上架
@property(nonatomic,assign)NSInteger state;

//    分享说明
@property(nonatomic,strong)NSDictionary* shareData;

@property(nonatomic,strong)NSAttributedString * priceAttr;

@property(nonatomic,strong)UIColor * tgColor;
//展架提示
@property(nonatomic,copy)NSString * displayRack;

@property(nonatomic,copy)NSString * qrCode;

@property(nonatomic,copy)NSString * wechatMoments;

@property(nonatomic,copy)NSString * friendCircle;
/**
 shareData": {
 "title": "一个让您省钱赚钱的生活APP!",
 "content": "大牌抢购、优惠买单省不停，消费返现、天天签到、好友分销赚不停！",
 "icon": "https:\/\/aimg8.oss-cn-shanghai.aliyuncs.com\/HuiLife\/iconv\/huilife.png",
 "link": "https:\/\/huiabc.cn?t=3&c=1"
 }
 */
@end


//用于推广model
@interface HLTicketPromote : HLTicketModel

// 推广id
@property(nonatomic,copy)NSString* extenId;

//优惠券id
@property(nonatomic,copy)NSString* objId;
//是否推广
@property(nonatomic,assign)BOOL isExten;

@end

//可推广的
@interface HLTicketPromoteAble : HLTicketModel

//是否已选择
@property(nonatomic,assign)BOOL isExtConupon;

//点击了这个model
@property(nonatomic,assign)BOOL select;

@property(nonatomic,copy)NSString * echoDisplay;

@end
