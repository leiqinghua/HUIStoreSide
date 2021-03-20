//
//  HLImageSinglePickerController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLImageCallBack)(UIImage *image);

@interface HLImageSinglePickerController : HLBaseViewController

-(instancetype)initWithAllowsEditing:(BOOL)allowsEditing callBack:(HLImageCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
