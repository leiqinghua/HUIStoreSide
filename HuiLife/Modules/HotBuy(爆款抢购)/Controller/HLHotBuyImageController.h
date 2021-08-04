//
//  HLHotBuyImageController.h
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HLHotBuyImageCallBack)(NSString *pic, NSString *detail_pic, UIImage *firstImage, NSInteger count);

@interface HLHotBuyImageController : HLBaseViewController

@property (nonatomic, copy) HLHotBuyImageCallBack callBack;

@end

NS_ASSUME_NONNULL_END

