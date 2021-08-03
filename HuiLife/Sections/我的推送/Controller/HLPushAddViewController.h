//
//  HLPushAddViewController.h
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 编辑时获取的信息
@interface HLPushEditDataModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *push_desc;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, assign) NSInteger total;

@end


@interface HLPushAddViewController : HLBaseViewController

/// 添加或者编辑完成之后的回调
@property (nonatomic, copy) void(^addBlock)(void);

/// 审核失败，编辑时
@property (nonatomic, copy) NSString *pushId;

@end




NS_ASSUME_NONNULL_END
