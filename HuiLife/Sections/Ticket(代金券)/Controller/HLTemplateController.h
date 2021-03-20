//
//  HLTemplateController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLTemplateController : HLBaseViewController

//是否是代金券模板
@property(nonatomic,assign)BOOL isTicket;

@property(nonatomic,strong)NSMutableDictionary * pargram;

@end

NS_ASSUME_NONNULL_END
