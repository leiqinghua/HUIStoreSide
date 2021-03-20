//
//  HLAreaSelectView.h
//  MingPian
//
//  Created by HuiLife on 2018/12/25.
//  Copyright © 2018 HuiLife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HLAreaBlock)(NSString *province,NSString *city,NSString *area,NSString *proId, NSString *cityId, NSString *areaId);

NS_ASSUME_NONNULL_BEGIN

@interface HLAreaSelectView : UIView

@property (copy, nonatomic) HLAreaBlock block;

+ (void)showCurrentSelectArea:(NSString *)selectArea areas:(NSArray *)areas callBack:(HLAreaBlock)callBack;

+ (void)showCurrentSelectArea:(NSString *)selectArea areas:(NSArray *)areas type:(NSInteger)type callBack:(HLAreaBlock)callBack;

@end

NS_ASSUME_NONNULL_END
