//
//  HLHotToast.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLHotToastModel;
@interface HLHotToast : UIView

@property(nonatomic, strong) HLHotToastModel *model;

@end


@interface HLHotToastModel : NSObject

@property(nonatomic, copy) NSString *pic;

@property(nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
