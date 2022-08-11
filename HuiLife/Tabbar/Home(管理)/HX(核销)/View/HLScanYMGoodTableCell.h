//
//  HLScanYMGoodTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLScanYMGoodInfo;
@class HLScanYMGoodView;

@interface HLScanYMGoodTableCell : UITableViewCell

@property(nonatomic, strong) NSArray<HLScanYMGoodInfo *> * goods;

@end

@interface HLScanYMGoodView : UIView

@property(nonatomic, strong) HLScanYMGoodInfo *good;

@end

NS_ASSUME_NONNULL_END
