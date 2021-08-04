//
//  HLTypeSelectView.h
//  HuiLife
//
//  Created by 王策 on 2021/7/25.
//

#import <UIKit/UIKit.h>
#import "HLTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLTypeSelectView : UIView

+ (void)showSelectViewWithArray:(NSArray <HLTypeModel *> *)array selectBlock:(void(^)(NSString *oneTitle, NSString *twoTitle, NSString *oneId, NSString * twoId))selectBlock;

@end

NS_ASSUME_NONNULL_END
