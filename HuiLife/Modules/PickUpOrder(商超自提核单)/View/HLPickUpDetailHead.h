//
//  HLPickUpDetailHead.h
//  HuiLife
//
//  Created by 王策 on 2020/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLPickUpDetailHead;
@protocol HLPickUpDetailHeadDelegate <NSObject>

// 点击展开收起按钮
- (void)detailHead:(HLPickUpDetailHead *)head expand:(BOOL)expand;

@end

@interface HLPickUpDetailHead : UIView

@property (nonatomic, weak) id <HLPickUpDetailHeadDelegate> delegate;

// 配置默认情况下展开闭合按钮的选中，选中则展开，不选中则收起
- (void)configDefaultSelect:(BOOL)select orderNum:(NSString *)orderNum goodNum:(NSString *)goodNum state:(NSString *)state;

@end

NS_ASSUME_NONNULL_END
