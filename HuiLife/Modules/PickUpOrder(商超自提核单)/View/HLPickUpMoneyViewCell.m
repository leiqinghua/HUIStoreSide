//
//  HLPickUpMoneyViewCell.m
//  HuiLife
//
//  Created by 王策 on 2020/1/15.
//

#import "HLPickUpMoneyViewCell.h"

@interface HLPickUpMoneyViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HLPickUpMoneyViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _bgView = [[UIView alloc] init];
    [self.contentView addSubview:_bgView];
    _bgView.backgroundColor = UIColorFromRGB(0xFFF8EB);
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10.5));
        make.right.equalTo(FitPTScreen(-10.5));
        make.top.bottom.equalTo(0);
    }];
    
    _tipLab = [[UILabel alloc] init];
    [_bgView addSubview:_tipLab];
    _tipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _tipLab.textColor = UIColorFromRGB(0xFC992F);
    [_tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(9.5));
        make.centerY.equalTo(_bgView);
    }];
    
    _moneyLab = [[UILabel alloc] init];
    [_bgView addSubview:_moneyLab];
    [_moneyLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-9.5));
        make.centerY.equalTo(_bgView);
    }];
    
    _bottomLine = [[UIView alloc] init];
    [_bgView addSubview:_bottomLine];
    _bottomLine.backgroundColor = UIColorFromRGB(0xF3D5B8);
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tipLab);
        make.right.equalTo(_moneyLab);
        make.bottom.equalTo(0);
        make.height.equalTo(0.6);
    }];
    
    
}

- (void)configTip:(NSString *)tip moneyAttr:(NSAttributedString *)moneyAttr showCorner:(BOOL)showCorner{
    _tipLab.text = tip;
    _moneyLab.attributedText = moneyAttr;
    _bottomLine.hidden = showCorner;
    if (showCorner) {
        if (_bgView.layer.mask == nil) {
            
            [self.contentView setNeedsLayout];
            [self.contentView layoutIfNeeded];
            
            CGRect bgFrame = _bgView.bounds;
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgFrame byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(FitPTScreen(6),FitPTScreen(6))];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = bgFrame;
            maskLayer.path = maskPath.CGPath;
            _bgView.layer.mask = maskLayer;
        }
    }else{
        _bgView.layer.mask = nil;
    }
}

@end
