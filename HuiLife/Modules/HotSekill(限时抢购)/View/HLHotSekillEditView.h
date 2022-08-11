//
//  HLHotSekillEditView.h
//  HuiLife
//
//  Created by 王策 on 2021/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillEditView : UIView

+ (void)showEditViewWithData:(NSDictionary *)orinalData superView:(UIView *)superView submitBlock:(void(^)(NSDictionary *dict, HLHotSekillEditView *editView))submitBlock;

- (void)hide;

@end

NS_ASSUME_NONNULL_END

//https://sapi.51huilife.cn/HuiLife_Api/MerchantSide/SeckillInsert.php?dev=1
//id    60528
//token    xm7Kd7f731rByBzB0tYs
//bid    44463
//invite_amount
//offerNum    100
//limitNum    30
//startTime    2021-07-29
//endTime    2022-02-28
//closingDate    2022-03-01 23:59:59
//pid    1346191
