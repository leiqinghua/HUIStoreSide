//
//  HLBaseTableViewCell.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/16.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLBaseTableViewCell : UITableViewCell

@property(nonatomic, strong) UIView *bagView;

@property(nonatomic, assign) BOOL showLine;

@property(nonatomic, strong) UIView *line;

- (void)initSubView ;

- (void)showArrow:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
