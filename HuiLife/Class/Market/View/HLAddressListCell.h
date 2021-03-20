//
//  HLAddressListCell.h
//  HuiLife
//
//  Created by 王策 on 2019/9/29.
//

#import <UIKit/UIKit.h>
#import "HLAddressPOIInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLAddressListCell : UITableViewCell

@property (strong, nonatomic) HLAddressPOIInfo *poiInfo;

@property (nonatomic, copy) NSString *keyWord;

@end

NS_ASSUME_NONNULL_END
