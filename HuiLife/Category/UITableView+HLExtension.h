//
//  UITableView+HLExtension.h
//  HuiLife
//
//  Created by 雷清华 on 2019/12/13.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (HLExtension)

/// 获取cell
/// @param identifier 必须以cell的类名称作为字符串传入
- (UITableViewCell *)hl_dequeueReusableCellWithIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
