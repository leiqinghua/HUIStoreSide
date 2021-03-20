//
//  HLGuideMask.h
//  HuiLife
//
//  Created by 王策 on 2019/10/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HLGuideMaskDefine.h"
#import "HLGuideMaskView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLGuideMask : NSObject

- (void)showMaskWithType:(HLGuideMaskType)maskType maskFrame:(CGRect)maskFrame clickBlock:(HLGuideMaskClickBlock)clickBlock;

- (void)showMaskWithTypes:(NSArray *)types maskFrames:(NSArray *)maskFrames clickBlock:(HLGuideMaskClickBlock)clickBlock;

- (void)hideGuideView;

// 是否展示过吧编号 1- 5引导图
+ (BOOL)alreadyShowGuide;
// 设置展示过引导图
+ (void)configShowGuide;

// 本地判断是否要展示step1
+ (BOOL)needShowStep1;
// 清除本地是否展示step1的标志
+ (void)cleanStep1ShowFlag;
// 配置step1展示的标志
+ (void)configStep1ShowFlag;

// 本地判断是否要展示step2
+ (BOOL)needShowStep2;
// 清除本地是否展示step2的标志
+ (void)cleanStep2ShowFlag;
// 配置step2展示的标志
+ (void)configStep2ShowFlag;

@end

NS_ASSUME_NONNULL_END
