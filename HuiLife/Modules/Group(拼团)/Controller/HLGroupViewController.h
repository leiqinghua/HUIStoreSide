//
//  HLGroupViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/14.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^HLGroupSelectBlock)(NSString * name,NSString * Id,double price);

@interface HLGroupViewController : HLBaseViewController

@property(nonatomic,copy)HLGroupSelectBlock selectBlock;

@property(nonatomic,assign)BOOL select;

@end

NS_ASSUME_NONNULL_END
