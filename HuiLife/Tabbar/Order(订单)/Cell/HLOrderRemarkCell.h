//
//  HLOrderRemarkCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/30.
//

#import "HLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLOrderRemarkCell : HLBaseTableViewCell
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSAttributedString *contentAttr;
@end

NS_ASSUME_NONNULL_END
