//
//  HLCalenderViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/21.
//

#import "HLCalenderViewCell.h"
#import "NSDate+HLCalendar.h"

@interface HLCalenderViewCell()

@property(strong,nonatomic)UILabel *label;

@end

@implementation HLCalenderViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _label = [[UILabel alloc]init];
    _label.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_label];
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.width.height.equalTo(FitPTScreenH(40));
    }];
}

-(void)setModel:(HLCalendarDayModel *)model{
    _model = model;
    self.label.text = [NSString stringWithFormat:@"%ld",model.day];
    self.label.backgroundColor = [UIColor whiteColor];
    [self setFTCornerdious:0.0 lable:self.label];
    
    NSDate * currentDate = [NSDate date];
    self.label.hidden = NO;

    if ([currentDate dateYear] == model.year && (((model.month == [currentDate dateMonth])&& (model.day >[currentDate dateDay])) || model.month > [currentDate dateMonth])){
        self.userInteractionEnabled = NO;
        self.label.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor hl_StringToColor:@"#CBCBCB"];
    }else{
        self.userInteractionEnabled = YES;
        self.label.textColor = model.lastMonthTitleColor? model.lastMonthTitleColor:[UIColor hl_StringToColor:@"#656565"];
        if (model.isToday) {
            self.label.text = @"今天";
            self.label.textColor = model.isSelected?UIColor.whiteColor: model.todayTitleColor?model.todayTitleColor:[UIColor hl_StringToColor:@"#FF8D26"];
        }
        if (model.isSelected) {
            [self showAnimationWithModel:model];
        }
    }
    
//    if (model.isNextMonth || model.isLastMonth) {
//        if (model.isShowLastAndNextDate) {//出现上月和下月的
//            self.label.hidden = NO;
//            if (model.isNextMonth) {
//                self.userInteractionEnabled = NO;
//                self.label.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor hl_StringToColor:@"#CBCBCB"];
//            }
//            if (model.isLastMonth) {
//                self.userInteractionEnabled = YES;
//                self.label.textColor = model.lastMonthTitleColor? model.lastMonthTitleColor:[UIColor hl_StringToColor:@"#656565"];
//                if (model.isSelected) {
//                    [self showAnimationWithModel:model];
//                }
//            }
//            return;
//        }
//        self.label.hidden = YES;
//
//    }else{
//        self.label.hidden = NO;
//        self.userInteractionEnabled = YES;
//        if (model.isSelected) {
//            [self showAnimationWithModel:model];
//        }
//        self.label.textColor = model.currentMonthTitleColor?model.currentMonthTitleColor:[UIColor hl_StringToColor:@"656565"];
//        if (model.isToday) {
//            self.label.text = @"今天";
//            self.label.textColor = model.isSelected?UIColor.whiteColor: model.todayTitleColor?model.todayTitleColor:[UIColor hl_StringToColor:@"#FF8D26"];
//        }
//    }
}


-(void)showAnimationWithModel:(HLCalendarDayModel*)model{
    [self setFTCornerdious:self.label.lx_width/2 lable:self.label];
    self.label.backgroundColor = model.selectBackColor?model.selectBackColor:[UIColor hl_StringToColor:@"#FF8D26"];
    if (model.isHaveAnimation) {
        [self addAnimaiton];
    }
}

-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.values = @[@0.6,@1.2,@1.0];
    anim.keyPath = @"transform.scale";  // transform.scale 表示长和宽都缩放
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;
    [self.label.layer addAnimation:anim forKey:nil];
}

-(void)setFTCornerdious:(CGFloat)cornerdious lable:(UILabel *)lable{
    lable.layer.cornerRadius = cornerdious;
    lable.layer.masksToBounds = YES;
}
@end
