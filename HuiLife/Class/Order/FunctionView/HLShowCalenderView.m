//
//  HLShowCalenderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/24.
//

#import "HLShowCalenderView.h"
#import "HLCalenderView.h"

@interface HLShowCalenderView()

@property(strong,nonatomic)HLCalenderView *calenderView;

@property(copy,nonatomic)SelectDay select;

@property(copy,nonatomic)TouchBlock touch;

@end

@implementation HLShowCalenderView


+ (void)calenderViewWithFrame:(CGRect)frame callBack:(SelectDay)select touch:(TouchBlock)touch{
    HLShowCalenderView * showView = [[HLShowCalenderView alloc] initWithBlock:select touch:touch frame:frame];
    [KEY_WINDOW addSubview:showView];
}

-(instancetype)initWithBlock:(SelectDay)select touch:(TouchBlock)touch frame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _select = select;
        _touch = touch;
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    UIView * bagView = [[UIView alloc]initWithFrame:self.bounds];
    bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:bagView];
    
    self.calenderView =[[HLCalenderView alloc]initWithFrame:CGRectMake(0,0, ScreenW, 0)];
    self.calenderView.isCanScroll = YES;
    self.calenderView.isShowLastAndNextBtn = YES;
    self.calenderView.isShowLastAndNextDate = YES;
    self.calenderView.isHaveAnimation = YES;
    [self.calenderView dealData];
    self.calenderView.backgroundColor =[UIColor whiteColor];
    self.calenderView.selectDate = _select;
    [self addSubview:self.calenderView];
}

+(void)remove{
    [HLNotifyCenter postNotificationName:HLStatuBarHidenNotifi object:@NO];
    for (UIView *subView in KEY_WINDOW.subviews) {
        if ([subView.class isEqual:[self class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *subView in KEY_WINDOW.subviews) {
        if ([subView.class isEqual:[self class]]) {
            [HLNotifyCenter postNotificationName:HLStatuBarHidenNotifi object:@NO];
            [subView removeFromSuperview];
            if (self.touch) {
                self.touch();
            }
            break;
        }
    }
}
@end
