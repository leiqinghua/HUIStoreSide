//
//  UIView+HLExtension.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/9.
//

#import "UIView+HLExtension.h"
#import "HLWithNotImgAlertView.h"

@implementation UIView (HLExtension)

-(void)setLx_x:(CGFloat)lx_x{
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(lx_x, y, width, height);
}

-(CGFloat)lx_x{
    return self.frame.origin.x;
}

-(void)setLx_y:(CGFloat)lx_y{
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, lx_y, width, height);
}
-(CGFloat)lx_y{
    return self.frame.origin.y;
}

-(void)setLx_width:(CGFloat)lx_width{
    CGRect frame = self.frame;
    frame.size.width = lx_width;
    self.frame = frame;
}
-(CGFloat)lx_width{
    return self.frame.size.width;
}

-(void)setLx_height:(CGFloat)lx_height{
    CGRect frame = self.frame;
    frame.size.height = lx_height;
    self.frame = frame;
}

-(CGFloat)lx_height{
    return self.frame.size.height;
}

- (CGFloat)lx_centerX {
    return self.center.x;
}

- (void)setLx_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)lx_centerY {
    return self.center.y;
}

- (void)setLx_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


-(void)setLx_left:(CGFloat)lx_left{
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(lx_left, y, width, height);
}
-(CGFloat)lx_left{
    return self.frame.origin.x;
}


-(void)setLx_top:(CGFloat)lx_top{
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, lx_top, width, height);
}

-(CGFloat)lx_top{
    return self.frame.origin.y;
}

-(void)setLx_right:(CGFloat)lx_right{
    CGRect frame = self.frame;
    frame.origin.x = lx_right - frame.size.width;
    self.frame = frame;
}
-(CGFloat)lx_right{
    return self.frame.origin.x + self.frame.size.width;
}
-(void)setLx_bottom:(CGFloat)lx_bottom{
    CGRect frame = self.frame;
    frame.origin.y = lx_bottom - frame.size.height;
    self.frame = frame;
}

-(CGFloat)lx_bottom{
    return self.frame.origin.y + self.frame.size.height;
}

-(CGSize)lx_size {
    return self.frame.size;
}

- (void)setLx_size:(CGSize)lx_size {
    CGRect frame = self.frame;
    frame.size = lx_size;
    self.frame = frame;
}

- (CGPoint)lx_origin {
    return self.frame.origin;
}

- (void)setLx_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/// 增加点击事件
- (void)hl_addTarget:(id)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

//-(void)hl_addPopAnimation{
//    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    popAnimation.duration = 0.4;
//    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
//    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.8f, @1.0f];
//    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [self.layer addAnimation:popAnimation forKey:nil];
//}


-(void)hl_addPopAnimation{
    self.alpha = 0.0;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)hideAnimate:(BOOL)animate{
    if (!animate) [self removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



-(void)removeEmptyView{
    for (UIView *subView in self.subviews) {
        if ([subView.class isEqual:[HLEmptyDataView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
}

-(BOOL)emptyViewIsShow{
    for (UIView *subView in self.subviews) {
        if ([subView.class isEqual:[HLEmptyDataView class]]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)showTokenView{
    for (UIView *subView in self.subviews) {
        if ([subView.class isEqual:[HLCustomAlert class]]) {
            return YES;
        }
    }
    return NO;
}


- (void)hl_shadowWithColor:(NSString *)colorStr alpha:(CGFloat)alpha offset:(CGSize)offset hadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius {
    UIColor *shadowColor = [HLTools hl_toColorByColorStr:colorStr alpha:alpha];
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

- (void)hl_shadowWithColor:(NSString *)colorStr alpha:(CGFloat)alpha hadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius {
    [self hl_shadowWithColor:colorStr alpha:alpha offset:CGSizeMake(0, 1) hadowOpacity:opacity shadowRadius:radius];
}

- (void)hl_shadowWithColor:(NSString *)colorStr alpha:(CGFloat)alpha shadowRadius:(CGFloat)radius {
    [self hl_shadowWithColor:colorStr alpha:alpha hadowOpacity:1.0 shadowRadius:radius];
}

- (void)hl_addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius,radius)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)hl_addCornerRadius:(CGFloat)radius bounds:(CGRect)bounds byRoundingCorners:(UIRectCorner)corner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius,radius)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
