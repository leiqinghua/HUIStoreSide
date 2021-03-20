//
//  HLScanCardMainInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/8/31.
//

#import <Foundation/Foundation.h>

@class HLScanCardGoodInfo;
NS_ASSUME_NONNULL_BEGIN
@interface HLScanCardMainInfo : NSObject
@property(nonatomic, copy) NSString *cardEnd;//开卡结束时间
@property(nonatomic, copy) NSString *cardIcon;//联名卡图标
@property(nonatomic, copy) NSString *cardId;//卡索引
@property(nonatomic, copy) NSString *cardName;//联名卡标题
@property(nonatomic, copy) NSString *cardStart;//开卡时间
@property(nonatomic, copy) NSString *flag;
@property(nonatomic, copy) NSString *phone;//手机号
@property(nonatomic, copy) NSString *tip;//提示内容
@property(nonatomic, copy) NSString *verify;//核销次数
@property(nonatomic, strong) NSString *orderNo;//订单号
@property(nonatomic, strong) NSArray<HLScanCardGoodInfo *> *gains;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface HLScanCardGoodInfo : NSObject
@property(nonatomic, assign) NSInteger cost;//本次核销次数
@property(nonatomic, assign) NSInteger gainNum;//权益数量
@property(nonatomic, assign) NSInteger gainState;//核销状态（0：待核销；1：以核销
@property(nonatomic, assign) NSInteger gainType;//0:卡片样式、1:实物样式、2:代金券样式
@property(nonatomic, assign) NSInteger gainUse;//已使用数量
@property(nonatomic, assign) NSInteger userGainId;//权益索引
@property(nonatomic, copy) NSString *gainDesc;//权益描述
@property(nonatomic, copy) NSString *gainEndTime;//权益结束时间
@property(nonatomic, copy) NSString *gainFlag;
@property(nonatomic, copy) NSString *gainIcon;
@property(nonatomic, copy) NSString *gainLable;
@property(nonatomic, copy) NSString *gainName;//权益名称
@property(nonatomic, copy) NSString * gainPrice;
@property(nonatomic, copy) NSString *gainStartTime;//权益开始时间
@property(nonatomic, copy) NSString *gainTypeDesc;
@end
NS_ASSUME_NONNULL_END
