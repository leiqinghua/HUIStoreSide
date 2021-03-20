//
//  UIView+HLExtension.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/9.
//

#import <UIKit/UIKit.h>
#import "HLEmptyDataView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HLExtension)

@property (assign, nonatomic) CGFloat lx_x;

@property (assign, nonatomic) CGFloat lx_y;

@property (assign, nonatomic) CGFloat lx_width;

@property (assign, nonatomic) CGFloat lx_height;

@property (assign, nonatomic) CGFloat lx_left;

@property (assign, nonatomic) CGFloat lx_top;

@property (assign, nonatomic) CGFloat lx_right;

@property (assign, nonatomic) CGFloat lx_bottom;

@property (assign, nonatomic) CGSize lx_size;

@property (nonatomic) CGFloat lx_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat lx_centerY;     ///< Shortcut for center.y

@property (nonatomic) CGPoint lx_origin;      ///< Shortcut for frame.origin.

- (void)hl_addTarget:(id)target action:(SEL)action;

-(void)hl_addPopAnimation;

//移除空白view
-(void)removeEmptyView;

-(BOOL)emptyViewIsShow;
//是否已经弹出了404 
-(BOOL)showTokenView;


/// 设置阴影
/// @param colorStr 投影颜色
/// @param alpha 颜色透明度
/// @param offset 偏移量
/// @param opacity 透明度
/// @param radius 阴影圆角
- (void)hl_shadowWithColor:(NSString *)colorStr alpha:(CGFloat)alpha offset:(CGSize)offset hadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius;


/// 设置阴影
/// @param colorStr 投影颜色
/// @param alpha 颜色透明度
/// @param opacity 透明度
/// @param radius 阴影圆角
- (void)hl_shadowWithColor:(NSString *)colorStr alpha:(CGFloat)alpha hadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius;

/// 设置阴影
/// @param colorStr 投影颜色
/// @param alpha 颜色透明度
/// @param radius 阴影圆角
- (void)hl_shadowWithColor:(NSString *)colorStr alpha:(CGFloat)alpha shadowRadius:(CGFloat)radius;


/// 添加指定位置的圆角
/// @param radius 圆角
/// @param corner 指定哪个角
- (void)hl_addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corner;

/// 添加指定位置的圆角
/// @param radius  圆角
/// @param bounds 大小
/// @param corner 指定哪个角
- (void)hl_addCornerRadius:(CGFloat)radius bounds:(CGRect)bounds byRoundingCorners:(UIRectCorner)corner;
@end

NS_ASSUME_NONNULL_END
