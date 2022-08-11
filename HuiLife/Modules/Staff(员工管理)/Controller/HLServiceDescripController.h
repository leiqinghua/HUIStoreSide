//
//  HLServiceDescripController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import <UIKit/UIKit.h>
//#import "HLFrameModel.h"
#import "HLStoreDetailModel.h"

typedef void(^ServiceDesc)(NSString *totleText, NSString *showText);

typedef void(^RefuseSucess)(void);

@interface HLServiceDescripController : HLBaseViewController
//是服务说明或者拒绝原因
@property(assign,nonatomic)BOOL isService;

@property(copy,nonatomic)ServiceDesc descBlock;
//传过来的服务说明
//@property(copy,nonatomic)NSString * defaultService;

@property (strong,nonatomic)HLStoreDetailModel * model;

//@property(strong,nonatomic)HLFrameModel * frameModel;

@property(copy,nonatomic)RefuseSucess success;
@end
