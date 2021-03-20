//
//  HLUploadProgress.h
//  HuiLife
//
//  Created by 王策 on 2019/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLUploadProgress : UIView

@property(nonatomic, strong)UILabel *presentlab;
@property (nonatomic, assign) CGFloat maxValue;

-(void)setPresent:(CGFloat)present;
- (void)configProgressBgColor:(UIColor *)bgColor progressColor:(UIColor *)progressColor;

@end

NS_ASSUME_NONNULL_END
