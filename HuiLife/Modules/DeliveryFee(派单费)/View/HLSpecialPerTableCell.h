//
//  HLSpecialPerTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/19.
//

#import <UIKit/UIKit.h>
#import "HLSpecialPeron.h"

NS_ASSUME_NONNULL_BEGIN
@class HLSpecialPerTableCell;
@protocol HLSpecialPerTableCellDelegate <NSObject>

- (void)perCell:(HLSpecialPerTableCell *)perCell add:(BOOL)add;
//验证手机号
- (void)perCell:(HLSpecialPerTableCell *)perCell phoneNum:(NSString *)phoneNum showNum:(NSString *)showNum;
@end

@interface HLSpecialPerTableCell : UITableViewCell

@property(nonatomic, weak) id<HLSpecialPerTableCellDelegate> delegate;

@property(nonatomic, strong) HLSpecialPeron *specialPer;

@end

NS_ASSUME_NONNULL_END
