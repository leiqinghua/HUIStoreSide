//
//  HLOrderOpetionHelper.h
//  HuiLife
//
//  Created by 雷清华 on 2019/12/15.
//

#import <Foundation/Foundation.h>
#import "HLPrinterSettingAlertView.h"
#import "HLBLEManager.h"

NS_ASSUME_NONNULL_BEGIN
@class HLBaseOrderModel;
@interface HLOrderOpetionHelper : NSObject
//配送
+ (void)hl_deliverdWithModel:(HLBaseOrderModel *)orderModel completion:(void(^)(void))completion;

//送达
+ (void)hl_arrivedWithModel:(HLBaseOrderModel *)orderModel completion:(void(^)(void))completion;

//自提
+ (void)hl_MentionWithModel:(HLBaseOrderModel *)orderModel completion:(void(^)(void))completion;

//打印
+ (void)hl_wifiListWithModel:(HLBaseOrderModel *)orderModel completion:(void(^)(NSArray *))completion;

//接单处理，立即接单
+ (void)hl_acceptOrderWithModel:(HLBaseOrderModel *)orderModel completion:(void(^)(void ))completion;

//接单处理，拒绝接单
+ (void)hl_refuseOrderWithModel:(HLBaseOrderModel *)orderModel completion:(void(^)(void ))completion;

@end

NS_ASSUME_NONNULL_END
