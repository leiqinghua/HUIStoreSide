//
//  HLMatterHeadView.h
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLMatterHeadView : UIView


/**
 填充数据

 @param title 左边标题
 @param desc 灰色描述
 @param codeUrl 二维码图片
 */
- (void)configTitle:(NSString *)title desc:(NSString *)desc codeUrl:(NSString *)codeUrl;

@end

NS_ASSUME_NONNULL_END
