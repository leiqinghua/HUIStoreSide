//
//  HLProfitGoodTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/24.
//

#import <UIKit/UIKit.h>
#import "HLProfitGoodInfo.h"
NS_ASSUME_NONNULL_BEGIN
@class HLProfitGoodTableCell;
@protocol HLProfitGoodCellDelegate <NSObject>
//删除
- (void)giftCell:(HLProfitGoodTableCell *)cell deleteInfo:(HLProfitGoodInfo *)info;
//编辑
- (void)giftCell:(HLProfitGoodTableCell *)cell editInfo:(HLProfitGoodInfo *)info;

@end

//父类
@interface HLProfitGoodTableCell : UITableViewCell

@property(nonatomic, weak) id<HLProfitGoodCellDelegate>delegate;

@property(nonatomic, strong) HLProfitGoodInfo *goodInfo;

- (void)initSubView ;

@end

//折扣
@interface HLProfitDefaultTableCell : HLProfitGoodTableCell

@end

//外卖折扣
@interface HLProfitYMTableCell : HLProfitDefaultTableCell

@end

//商品
@interface HLProfitGiftTableCell : HLProfitGoodTableCell

@end

//外卖红包
@interface HLProfitRedPacketTableCell : HLProfitGoodTableCell

@end

@interface HLProfitPhoneFeeCell : UITableViewCell

@property(nonatomic, strong) HLPhoneFeeInfo *goodInfo;

@end

NS_ASSUME_NONNULL_END
