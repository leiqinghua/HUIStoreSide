//
//  HLCalendarHearder.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/21.
//

#import "HLCalendarHearder.h"

@interface HLCalendarHearder()

@property (strong, nonatomic) UIButton *leftBtn;

@property (strong, nonatomic) UIButton *rightBtn;

@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation HLCalendarHearder

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _leftBtn = [[UIButton alloc]init];
    [_leftBtn setImage:[UIImage imageNamed:@"arrow_left_oriange"] forState:UIControlStateNormal];
    [self addSubview:_leftBtn];
    [_leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.centerY.equalTo(self);
        make.width.height.equalTo(FitPTScreen(40));
    }];
    [_leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [[UIButton alloc]init];
    [_rightBtn setImage:[UIImage imageNamed:@"arrow_right_darkGrey"] forState:UIControlStateNormal];
    [self addSubview:_rightBtn];
    [_rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self);
        make.width.height.equalTo(FitPTScreen(40));
    }];
    [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.textColor = [UIColor hl_StringToColor:@"#282828"];
    _dateLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self addSubview:_dateLabel];
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
    }];
}

-(void)setDateStr:(NSString *)dateStr{
    _dateStr = dateStr;
    self.dateLabel.text = dateStr;
}

- (void)leftClick:(UIButton *)sender {
    if (self.leftClickBlock) {
        self.leftClickBlock();
    }
}

- (void)rightClick:(UIButton *)sender {
    if (self.rightClickBlock) {
        self.rightClickBlock();
    }
}

-(void)setIsShowLeftAndRightBtn:(BOOL)isShowLeftAndRightBtn{
    _isShowLeftAndRightBtn = isShowLeftAndRightBtn;
    self.leftBtn.hidden = self.rightBtn.hidden = !isShowLeftAndRightBtn;
}

-(void)hideLeftBtnAndRightBtn{
    self.leftBtn.hidden = self.rightBtn.hidden = YES;
}

@end
