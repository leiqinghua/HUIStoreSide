//
//  HLStoreBuyPayTypeCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import <UIKit/UIKit.h>
#import "HLStoreBuyMainInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLStoreBuyPayTypeCell : UITableViewCell

@property (nonatomic, strong) HLStoreBuyTypeInfo *info;

@property (nonatomic, assign) BOOL hideBottomLine;

@end

NS_ASSUME_NONNULL_END
