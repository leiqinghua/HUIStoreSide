//
//  HLCalanderWeekView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/21.
//

#import "HLCalanderWeekView.h"

@interface HLCalanderWeekView()

@property(strong,nonatomic)NSArray *dates;

@property(copy,nonatomic)HLCalanderCancel callBack;
@end

@implementation HLCalanderWeekView

-(instancetype)initWithFrame:(CGRect)frame callBack:(HLCalanderCancel) callBack{
    if (self = [super initWithFrame:frame]) {
        _callBack = callBack;
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    self.backgroundColor = UIColor.whiteColor;
    UIButton * cancel = [[UIButton alloc]init];
    [self addSubview:cancel];
    [cancel setImage:[UIImage imageNamed:@"colse_x_light_grey"] forState:UIControlStateNormal];
    [cancel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(15));
        make.width.height.equalTo(FitPTScreen(40));
    }];
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLable = [[UILabel alloc]init];
    titleLable.text = @"选择日期";
    titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    titleLable.textColor = [UIColor hl_StringToColor:@"#656565"];
    [self addSubview:titleLable];
    [titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancel);
        make.centerX.equalTo(self);
    }];
    
    CGFloat width = self.lx_width / 7;
    
    CGFloat hight = FitPTScreenH(50);
    for (int i=0; i<self.dates.count; i++) {
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(i*width,FitPTScreenH(50), width, hight)];
        lable.text = self.dates[i];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor hl_StringToColor:@"#656565"];
        lable.font = [UIFont systemFontOfSize:FitPTScreenH(17)];
        [self addSubview:lable];
    }
}


-(void)cancelClick{
    if (self.callBack) {
        self.callBack();
    }
}

-(NSArray *)dates{
    if (!_dates) {
        _dates = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    return _dates;
}


@end
