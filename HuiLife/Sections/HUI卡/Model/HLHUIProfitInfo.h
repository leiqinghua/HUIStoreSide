//
//  HLHUIProfitInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/25.
//

#import <Foundation/Foundation.h>
#import "HLRightInputViewCell.h"
#import "HLInputDateViewCell.h"
#import "HLInputUseDescViewCell.h"
#import "HLRightEditNumViewCell.h"
#import "HLInputImagesViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class HLProfitGoodInfo;
@interface HLHUIProfitInfo : NSObject
//选择的类型
/**
 1 首单折扣，3日常折扣,2 外卖折扣，
 43 服务卡，42代金券，41 打折券， 21赠品
 
 */
@property(nonatomic, assign) NSInteger type;
//数据源
@property(nonatomic, strong) NSMutableArray *datasource;
//服务卡
@property(nonatomic, strong) NSMutableArray *serviceSource;
//代金券
@property(nonatomic, strong) NSMutableArray *voucherSource;
//打折券
@property(nonatomic, strong) NSMutableArray *discountSource;
//赠品
@property(nonatomic, strong) NSMutableArray *giftSource;
//用于编辑的 卡 权益
@property(nonatomic, strong) HLProfitGoodInfo *editProfitInfo;

//是否开启月月赠送
- (void)monthGiftOpen:(BOOL)open ;
//创建要添加的模型
- (HLProfitGoodInfo *)createProfitGoodInfo;
//获取编辑后的 模型
- (void)configEditProfitGoodInfo;

@end





NS_ASSUME_NONNULL_END
