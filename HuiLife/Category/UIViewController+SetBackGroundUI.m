//
//  UIViewController+SetBackGroundUI.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/12.

#import "AppDelegate.h"
#import "UIViewController+SetBackGroundUI.h"

@implementation UIViewController (SetBackGroundUI)

- (void)hl_setBackgroundImage:(UIImage *)image {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundImageView];
    backgroundImageView.image = image;
}

- (void)hl_hideNavcationBar {
    self.navigationController.delegate = self;
}

- (void)hl_setTransparentNavtion {
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    //需要判断是不是iPhonex
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, Height_NavBar);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

- (void)hl_setTitle:(NSString *)title andTitleColor:(UIColor *)color {
    self.navigationItem.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName: [UIFont boldSystemFontOfSize:FitPTScreen(17)],
       NSForegroundColorAttributeName: color}];
}


- (void)hl_setTitle:(NSString *)title {
    [self hl_setTitle:title andTitleColor:UIColorFromRGB(0x333333)];
}

- (void)hl_setBackgroundColor:(UIColor *)color showLine:(BOOL)show {
    self.navigationController.navigationBar.translucent = YES;
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, Height_NavBar);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:(UIBarMetricsDefault)];
    //很关键（覆盖状态栏）
    self.navigationController.navigationBar.clipsToBounds = NO;
    if (!show) {
        //去掉下面的横线
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
}

- (void)hl_setBackgroundColor:(UIColor *)color {
    [self hl_setBackgroundColor:color showLine:YES];
}

- (void)hl_GradientColor:(UIColor *)color {
    [self hl_setBackgroundColor:color showLine:false];
}

- (void)hl_removeFromNav {
    NSMutableArray *navs = [self.navigationController.viewControllers mutableCopy];
    if (navs.count > 2) {
        UIViewController *con = navs[navs.count - 2];
        if ([con isEqual:self]) {
            [navs removeObjectAtIndex:navs.count - 2];
        }
    }
    self.navigationController.viewControllers = navs;
}

//除了跟视图控制器和最后一个 其他都移除
- (void)hl_removeAll {
    NSMutableArray *navs = [self.navigationController.viewControllers mutableCopy];
    if (navs.count > 2) {
        for (NSInteger i = 1; i < navs.count - 2; i++) {
            [navs removeObjectAtIndex:i];
        }
    }
    self.navigationController.viewControllers = navs;
}

- (void)hl_removeOthers {
    NSMutableArray *navs = [self.navigationController.viewControllers mutableCopy];
    if (navs.count > 1) {
        for (NSInteger i = 1; i < navs.count; i++) {
            [navs removeObjectAtIndex:i];
        }
    }
    self.navigationController.viewControllers = navs;
}

- (void)hl_interactivePopGestureRecognizerUseable {
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)hl_pushToController:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIViewController *)fatherController {
    for (UIResponder *next = [self nextResponder]; next; next = next.nextResponder) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
    }
    return nil;
}
@end
