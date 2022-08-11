//
//  HLLBManagerController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import <UIKit/UIKit.h>

typedef void(^selectItem)(NSDictionary *bigClass,NSDictionary*samallClass);

@interface HLLBManagerController : HLBaseViewController
//是否是选择门店
@property(assign,nonatomic)BOOL isSelect;

@property(copy,nonatomic)selectItem selectBlock;

@property(copy,nonatomic)NSString * class_id;

@end
