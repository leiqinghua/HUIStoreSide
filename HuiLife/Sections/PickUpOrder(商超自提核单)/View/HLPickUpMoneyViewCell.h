//
//  HLPickUpMoneyViewCell.h
//  HuiLife
//
//  Created by 王策 on 2020/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLPickUpMoneyViewCell : UITableViewCell


/// 配置数据
/// @param tip 左边的提示信息
/// @param moneyAttr 右边的钱的富文本
- (void)configTip:(NSString *)tip moneyAttr:(NSAttributedString *)moneyAttr showCorner:(BOOL)showCorner;

@end

NS_ASSUME_NONNULL_END
