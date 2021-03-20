//
//  HLOrderPriceDescView.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderPriceDescView.h"
#import "HLAlertView.h"

@interface HLOrderPriceDescView ()

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, strong) UILabel *moneyLb;

@property(nonatomic, strong) UIButton *descBtn;

@property(nonatomic, strong) UIView *openBtn;

@property(nonatomic, strong) UILabel *openLb;

@property(nonatomic, strong) UIImageView *openView;

@end

@implementation HLOrderPriceDescView


- (void)setOpen:(BOOL)open {
    _open = open;
    _openLb.text = _open ? @"收起" : @"展开";
    _openView.image = [UIImage imageNamed:_open?@"arrow_up_grey":@"arrow_down_grey_light"];
}


- (void)setMoney:(NSString *)money {
    _money = money;
    if (![money containsString:@"￥"] && ![money containsString:@"¥"]) {
        _money = [NSString stringWithFormat:@"¥%@",money];
    }
    NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:_money];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]} range:NSMakeRange(0, 1)];
    _moneyLb.attributedText = mutarr;
}


- (void)setType:(HLOrderPriceDescType)type {
    _type = type;
    _titleLb.text = [self priceDesTitle];
}


- (instancetype)initWithType:(HLOrderPriceDescType)type {
    if (self = [super init]) {
        _type = type;
        [self initSubView];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.contentView.backgroundColor = UIColor.whiteColor;
    _titleLb = [UILabel hl_regularWithColor:@"#868686" font:14];
    _titleLb.text = [self priceDesTitle];
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(self);
    }];
    
    _moneyLb = [UILabel hl_singleLineWithColor:@"#FF4040" font:20 bold:YES];
    [self addSubview:_moneyLb];
    [_moneyLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.right).offset(FitPTScreen(8));
        make.centerY.equalTo(self);
    }];
    
//    _descBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 image:@"waring_grey_big"];
//    [self addSubview:_descBtn];
//    [_descBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(FitPTScreen(-135));
//        make.centerY.equalTo(self.titleLb);
//        make.width.height.equalTo(FitPTScreen(30));
//    }];
//    [_descBtn addTarget:self action:@selector(descBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _openBtn = [[UIView alloc]init];
    _openBtn.layer.cornerRadius = FitPTScreen(11);
    _openBtn.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    _openBtn.layer.borderWidth = FitPTScreen(0.5);
    [self addSubview:_openBtn];
    [_openBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-11));
        make.centerY.equalTo(self.titleLb);
        make.width.equalTo(FitPTScreen(54));
        make.height.equalTo(FitPTScreen(23));
    }];
    UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openBtnClick:)];
    [_openBtn addGestureRecognizer:openTap];
    
    
    _openLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    _openLb.text = @"展开";
    [_openBtn addSubview:_openLb];
    [_openLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(9));
        make.centerY.equalTo(self.openBtn);
    }];
    
    _openView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_xia"]];
    [_openBtn addSubview:_openView];
    [_openView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-6));
        make.centerY.equalTo(self.openBtn);
    }];
}

- (NSString *)priceDesTitle {
    switch (_type) {
        case HLOrderPriceDescUserType:
            return @"用户收到退款金额";
            break;
        case HLOrderPriceDescStoreType:
            return @"商家承担退款金额";
            break;
        case HLOrderPriceDescSettleType:
            return @"结算金额";
            break;
        default:
            return @"";
            break;
    }
}

- (void)openBtnClick:(UITapGestureRecognizer *)sender {
    self.open = !self.open;
    if ([self.delegate respondsToSelector:@selector(hl_footerViewWithOpenClick:)]) {
        [self.delegate hl_footerViewWithOpenClick:self.open];
    }
}

- (void)descBtnClick:(UIButton *)sender {
    NSString * title = @"";
    NSString * subTitle = @"";
    switch (_type) {
        case HLOrderPriceDescSettleType:
            title = @"结算金额";
            subTitle = @"结算金额=实付金额  - 分销佣金 - 手续费";
            break;
        case HLOrderPriceDescUserType:
            title = @"退款金额说明";
            subTitle = @"用户收到退款金额=商品原价/订单原价x用户实付金额 \n 退款方式：原路退回";
            break;
        case HLOrderPriceDescStoreType:
            title = @"退款金额说明";
            subTitle = @"商家承担退款金额=商品原价/订单原价x（订单折扣价-商家补贴）";
            break;
        default:
            break;
    }
    [HLAlertView alertWithTitle:title subTitltle:subTitle type:HLAlertViewDefaultType];
}
@end
