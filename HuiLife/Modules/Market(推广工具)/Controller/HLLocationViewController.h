//
//  HLLocationViewController.h
//  HuiLife
//
//  Created by 王策 on 2019/9/29.
//

#import "HLBaseViewController.h"

typedef void(^HLLocationBlock)(double lat,double lon, NSString *province, NSString *city, NSString *area, NSString *address);

NS_ASSUME_NONNULL_BEGIN

@interface HLLocationViewController : HLBaseViewController

@property (nonatomic, copy) HLLocationBlock locationBlock;

@end

NS_ASSUME_NONNULL_END
