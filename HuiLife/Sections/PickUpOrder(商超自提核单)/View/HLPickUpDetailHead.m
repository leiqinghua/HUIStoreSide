//
//  HLPickUpDetailHead.m
//  HuiLife
//
//  Created by 王策 on 2020/1/15.
//

#import "HLPickUpDetailHead.h"

/*
 包含订单号和 是否自提状态内容
 包含订单商品总数 和 是否关闭开启按钮视图
 */

@interface HLPickUpDetailHead ()

@property (nonatomic, strong) UILabel *orderNumLab;
@property (nonatomic, strong) UILabel *stateLab;

@property (nonatomic, strong) UIView *colorView; // 需要切圆角的 view，展开时就是上面两个圆角，闭合时就是四个圆角

@property (nonatomic, strong) UIButton *sumNumBtn; // 共几件商品，仅仅显示，不提供点击事件
@property (nonatomic, strong) UIButton *upOrDownBtn; // 展开收起按钮

@end

@implementation HLPickUpDetailHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    // 订单号 label
    _orderNumLab = [[UILabel alloc] init];
    [self addSubview:_orderNumLab];
    _orderNumLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _orderNumLab.textColor = UIColorFromRGB(0x333333);
    [_orderNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10.5));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    // 自提状态 label
    _stateLab = [[UILabel alloc] init];
    [self addSubview:_stateLab];
    _stateLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _stateLab.textColor = UIColorFromRGB(0xFF7213);
    [_stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10.5));
        make.centerY.equalTo(_orderNumLab);
    }];
    
    // 带颜色的 view
    _colorView = [[UIView alloc] init];
    [self addSubview:_colorView];
    _colorView.backgroundColor = UIColorFromRGB(0xFFF8EB);
    [_colorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderNumLab.left);
        make.right.equalTo(_stateLab.right);
        make.height.equalTo(FitPTScreen(38));
        make.bottom.equalTo(0);
    }];
    
    // 商品总数显示 Button
    _sumNumBtn = [[UIButton alloc] init];
    [_colorView addSubview:_sumNumBtn];
    _sumNumBtn.userInteractionEnabled = NO;
    _sumNumBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [_sumNumBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_sumNumBtn setBackgroundImage:[UIImage imageNamed:@"order_pickup_numbg"] forState:UIControlStateNormal];
    [_sumNumBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(FitPTScreen(66.5));
        make.height.equalTo(FitPTScreen(18));
        make.left.equalTo(_colorView);
        make.centerY.equalTo(_colorView);
    }];
    
    // 展开收起按钮
    _upOrDownBtn = [[UIButton alloc] init];
    [_colorView addSubview:_upOrDownBtn];
    [_upOrDownBtn setImage:[UIImage imageNamed:@"arrow_down_cricle"] forState:UIControlStateNormal];
    [_upOrDownBtn setImage:[UIImage imageNamed:@"arrow_up_circle"] forState:UIControlStateSelected];
    [_upOrDownBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(FitPTScreen(35));
        make.right.equalTo(_colorView);
        make.centerY.equalTo(_colorView);
    }];
    [_upOrDownBtn addTarget:self action:@selector(upOrDownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

// 点击展开收起按钮
- (void)upOrDownBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (self.delegate) {
        [self.delegate detailHead:self expand:button.selected];
    }
    [self resizeColorViewCorner];
}

// 配置默认情况下展开闭合按钮的选中，选中则展开，不选中则收起
- (void)configDefaultSelect:(BOOL)select orderNum:(NSString *)orderNum goodNum:(NSString *)goodNum state:(NSString *)state{
    _upOrDownBtn.selected = select;
    [self resizeColorViewCorner];
    
    _orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",orderNum];
    _stateLab.text = state;
//    [_sumNumBtn setTitle:[NSString stringWithFormat:@"共%ld件商品",goodNum] forState:UIControlStateNormal];
    [_sumNumBtn setTitle:goodNum forState:UIControlStateNormal];

}

// 根据按钮的选中状态，更改 colorView 的圆角
- (void)resizeColorViewCorner{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight;
    if (!_upOrDownBtn.selected) {
        corner = corner | UIRectCornerAllCorners;
    }
    [_colorView hl_addCornerRadius:FitPTScreen(6) byRoundingCorners:corner];
}

@end
