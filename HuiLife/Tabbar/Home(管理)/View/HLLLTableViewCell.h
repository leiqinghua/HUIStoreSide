//
//  HLLLTableViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLLLTableViewCell : UITableViewCell

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;

- (void)titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont;
- (void)conColor:(UIColor *)conColor conFont:(UIFont *)coneFont;

@end

NS_ASSUME_NONNULL_END
