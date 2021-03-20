//
//  HLHomeGuideInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLHomeGuideInfo : NSObject

@property (nonatomic, assign) BOOL one;
@property (nonatomic, assign) BOOL two;
@property (nonatomic, assign) BOOL three;

- (BOOL)needShowStepGuide;

- (BOOL)needShowStep1;

- (BOOL)needShowStep2;

- (BOOL)needShowStep3;

@end

NS_ASSUME_NONNULL_END
