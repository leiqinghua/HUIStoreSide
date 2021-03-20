//
//  HLSelectMDViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/24.
//

#import <UIKit/UIKit.h>
#import "HLStaffDetailModel.h"
#import "HLStoreModel.h"

typedef void(^SelectMD)(HLStoreModel * storeModel);

@interface HLSelectMDViewController : HLBaseViewController

@property(copy,nonatomic)SelectMD selectMD;

//@property(strong,nonatomic)NSDictionary * defaultInfo;

//@property (strong,nonatomic)HLStaffDetailModel * detailModel;

@property (copy,nonatomic)NSString * storeId;
@end
