//
//  HLGuideLayout.h
//  HuiLife
//
//  Created by 王策 on 2019/10/15.
//

#import <Foundation/Foundation.h>
#import "HLGuideMaskDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLGuideLayout : NSObject

@property (nonatomic, assign) HLGuideMaskType maskType;

@property (nonatomic, copy) NSString *textImage;
@property (nonatomic, assign) CGRect textImageFrame;

@property (nonatomic, copy) NSString *clickBtnImage;
@property (nonatomic, assign) CGRect clickBtnImageFrame;

@property (nonatomic, copy) NSString *hideBtnImage;
@property (nonatomic, assign) CGRect hideBtnImageFrame;

@property (nonatomic, assign) CGRect maskFrame;

@end

NS_ASSUME_NONNULL_END
