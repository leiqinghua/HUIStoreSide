//
//  HLRefundReasonView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/24.
//

#import "HLRefundReasonView.h"
#import "HLTKResonView.h"

@interface HLRefundReasonView()

@property(strong,nonatomic)UILabel *subTitle;

@property(assign,nonatomic)NSInteger selectIndex;

@property(strong,nonatomic)NSArray *reasons;
@end

@implementation HLRefundReasonView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 3;
    self.layer.shadowColor =UIColorFromRGB(0xFFFFFF).CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.8f;
    self.layer.masksToBounds = false;
    self.clipsToBounds = false;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    UILabel * titleLable = [[UILabel alloc]init];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    titleLable.text = @"退款原因";
    titleLable.textColor = UIColorFromRGB(0x282828);
    [self addSubview:titleLable];
    [titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(FitPTScreen(20));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FitPTScreen(92));
        make.top.equalTo(FitPTScreen(8));
        make.width.equalTo(FitPTScreen(1));
        make.height.equalTo(FitPTScreen(29));
    }];
    
    _subTitle = [[UILabel alloc]init];
    _subTitle.textColor = [UIColor hl_StringToColor:@"#565656"];;
    _subTitle.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _subTitle.text = @"不想要了";
    [self addSubview:_subTitle];
    [_subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(line.mas_right).offset(FitPTScreen(15));
    }];
    
    UIButton * alertBtn = [[UIButton alloc]init];
    [alertBtn setImage:[UIImage imageNamed:@"arrow_down_black"] forState:UIControlStateNormal];
    [self addSubview:alertBtn];
    [alertBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(FitPTScreen(-15));
        make.width.height.equalTo(FitPTScreen(40));
    }];
    [alertBtn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)alertBtnClick:(UIButton *)sender{
    [HLTKResonView showWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) dataSource:self.reasons selectIndex:_selectIndex callBack:^(NSString *title, NSInteger index) {
        self.subTitle.text = title;
        self.selectIndex = index;
        if (self.select) {
            self.select(index + 1);
        }
    }];
}

-(NSArray *)reasons{
    if (!_reasons) {
        _reasons = @[@"不想要了",@"买重复了",@"买错了，重新买",@"忘记使用优惠",@"不喜欢",@"其他问题",@"商品描述不符",@"商品质量问题"];
    }
    return _reasons;
}
@end
