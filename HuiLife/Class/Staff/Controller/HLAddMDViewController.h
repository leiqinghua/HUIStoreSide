//
//  HLAddMDViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import <UIKit/UIKit.h>
#import "HLStoreModel.h"

@interface HLAddMDViewController : HLBaseViewController
//进入门店详情
@property(strong,nonatomic)NSDictionary * storeInfo;

@property(strong,nonatomic)HLStoreModel * storeModel;
@end
