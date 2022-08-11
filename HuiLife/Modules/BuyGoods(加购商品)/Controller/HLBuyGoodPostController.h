//
//  HLBuyGoodPostController.h
//  HuiLife
//
//  Created by 王策 on 2019/8/26.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLBuyGoodPostController : HLBaseViewController

/// 存储的信息
@property (nonatomic, copy) NSArray *dataSource;

/// 需要提交的参数
@property (nonatomic, copy) NSDictionary *mParams;

/// 选择的图片
@property (nonatomic, strong) UIImage *selectImage;

@end

NS_ASSUME_NONNULL_END
