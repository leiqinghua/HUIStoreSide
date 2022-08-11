//
//  HLCardPromoteViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/7.
//

#import "HLCardPromoteViewCell.h"
#import "HLSwitch.h"

@interface HLCardPromoteViewCell ()

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, copy) UILabel *descLb;

@property(nonatomic, copy) HLSwitch *switchV;


@end

@implementation HLCardPromoteViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    _titleLb.text = @"HUI卡推广";
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(14));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor = UIColorFromRGB(0x999999);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _descLb.text = @"永久免佣金推广";
    [self.contentView addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(9));
    }];
    
    _switchV = [[HLSwitch alloc]init];
    [self.contentView addSubview:_switchV];
    [_switchV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-17));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(43));
        make.height.equalTo(FitPTScreen(22));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchChanged:)];
    [_switchV addGestureRecognizer:tap];
}

- (void)switchChanged:(UITapGestureRecognizer *)sender {
    HLSwitch *switchV = (HLSwitch *)sender.view;
    switchV.select = !switchV.select;
    self.model.on = switchV.select?1:2;
    if ([self.delegate respondsToSelector:@selector(cardPromoteCell:switchOn:)]) {
        [self.delegate cardPromoteCell:self switchOn:switchV.select];
    }
}

- (void)setModel:(HLCardPromoteType *)model {
    _model = model;
    _titleLb.text = model.title;
    _descLb.text = model.desc;
    _switchV.select = model.on == 1;
}

@end



@interface HLCardDiscountViewCell ()

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, copy) UIButton *discountBtn;

@property(nonatomic, copy) UILabel *discountLb;

@property(nonatomic, copy) UIImageView *arrowImV;

@end

@implementation HLCardDiscountViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x222222);
    _titleLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    _titleLb.text = @"HUI卡首次买单折扣";
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.centerY.equalTo(self.contentView);
    }];
    
    _discountBtn = [[UIButton alloc]init];
    _discountBtn.backgroundColor = UIColorFromRGB(0xf8f9f8);
    _discountBtn.layer.cornerRadius = 1.5;
    _discountBtn.layer.borderColor = UIColorFromRGB(0xE1E1E1).CGColor;
    _discountBtn.layer.borderWidth = 0.5;
    [_discountBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    _discountBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_discountBtn setTitle:@"0.0" forState:UIControlStateNormal];
    [self.contentView addSubview:_discountBtn];
    [_discountBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(FitPTScreen(-51));
        make.width.equalTo(FitPTScreen(51));
        make.height.equalTo(FitPTScreen(27));
    }];
    
    _discountLb = [[UILabel alloc]init];
    _discountLb.textColor = UIColorFromRGB(0x999999);
    _discountLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _discountLb.text = @"折";
    [self.contentView addSubview:_discountLb];
    [_discountLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountBtn.right).offset(FitPTScreen(5));
        make.centerY.equalTo(self.contentView);
    }];
    
    _arrowImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [self.contentView addSubview:_arrowImV];
    [_arrowImV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-17));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setModel:(HLCardDiscount *)model {
    _model = model;
    _titleLb.text = model.title;
    [_discountBtn setTitle:model.set forState:UIControlStateNormal];
    if ([model.set floatValue]) {
        [_discountBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    } else {
        [_discountBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    }
    _discountLb.text = model.unit;
}

@end

@implementation HLCardDiscount



@end
