//
//  UITableView+Extension.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Extension)

- (void)headerWithRefreshingBlock:(void(^)(void))block;

- (void)footerWithRefreshingBlock:(void(^)(void))block;

- (void)headerNormalRefreshingBlock:(void(^)(void))block;

- (void)footerWithEndText:(NSString *)text refreshingBlock:(void(^)(void))block;

- (void)endRefresh;

- (void)endNomorData;

- (void)hideFooter:(BOOL)hide;

- (void)resetFooter ;
@end

NS_ASSUME_NONNULL_END
