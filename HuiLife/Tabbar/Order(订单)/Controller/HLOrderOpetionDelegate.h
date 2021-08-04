//
//  HLOrderOpetionDelegate.h
//  iOS13test
//
//  Created by 雷清华 on 2019/11/12.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLBaseOrderLayout;
@protocol HLOrderOpetionDelegate <NSObject>

@optional
//(结算金额，或全部退款) 是否展开
- (void)hl_footerViewWithOpenClick:(BOOL)open;
//部分退款
- (void)hl_headerViewWithOpenClick:(BOOL)open;

//导航
- (void)hl_goToNavigatePageWithLayout:(HLBaseOrderLayout *)layout;

//刷新cell的高度
- (void)hl_reloadOrderViewCellHightWithLayout:(HLBaseOrderLayout *)layout;

/// 点击底部按钮触发的方法
/// @param index 按钮类型 在封装的视图里可见
/// @param layout model
- (void)hl_functionWithTypeIndex:(NSInteger)index orderLayout:(HLBaseOrderLayout *)layout;

/// 点击底部按钮触发的方法
/// @param name 按钮名称 处理服务器返回按钮
/// @param layout model
- (void)hl_functionWithName:(NSString *)name orderLayout:(HLBaseOrderLayout *)layout;

@end

NS_ASSUME_NONNULL_END
