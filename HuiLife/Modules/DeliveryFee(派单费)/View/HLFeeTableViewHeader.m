//
//  HLFeeTableViewHeader.m
//  HuiLife
//
//  Created by 王策 on 2021/6/8.
//

#import "HLFeeTableViewHeader.h"
#import "HLSwitch.h"

@interface HLFeeTableViewHeader ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descLb;
@property (nonatomic, strong) HLSwitch *switchView;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HLFeeTableViewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    _titleLb.text = @"商家自配送";
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor = UIColorFromRGB(0x999999);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self addSubview:_descLb];
    _descLb.text = @"开启后关闭第三方配送，所有订单自配送";
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLb);
        make.top.equalTo(_titleLb.bottom).offset(FitPTScreen(8));
    }];
    
    _switchView = [[HLSwitch alloc]init];
    [self addSubview:_switchView];
    [_switchView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(9));
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(FitPTScreen(43), FitPTScreen(22)));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchClick:)];
    [_switchView addGestureRecognizer:tap];
    
    _bottomLine = [[UIView alloc] init];
    [self addSubview:_bottomLine];
    _bottomLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
}

- (void)switchClick:(UITapGestureRecognizer *)sender {
    _switchView.select = !_switchView.select;
    if (self.delegate) {
        [self.delegate feeTableHeader:self switchChanged:_switchView.select];
    }
}

- (void)configSwitchOn:(BOOL)switchOn{
    self.switchView.select = switchOn;
}

@end
