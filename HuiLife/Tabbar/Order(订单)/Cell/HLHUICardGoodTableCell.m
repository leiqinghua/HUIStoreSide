//
//  HLHUICardGoodTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/1.
//

#import "HLHUICardGoodTableCell.h"
#import "HLOrderGoodModel.h"

@interface HLHUICardGoodTableCell ()
@property(nonatomic, strong) UIImageView *picView;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *numLb;
@property(nonatomic, strong) UILabel *priceLb;
@property(nonatomic, strong) UILabel*oriPriceLb;
@end

@implementation HLHUICardGoodTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _picView = [[UIImageView alloc]init];
    _picView.layer.cornerRadius = FitPTScreen(2);
    _picView.layer.masksToBounds = YES;
    [self.contentView addSubview:_picView];
    [_picView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(11));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(48), FitPTScreen(48)));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    [self.contentView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picView.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.contentView);
    }];
    
    _oriPriceLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:14];
    [self.contentView addSubview:_oriPriceLb];
    [_oriPriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0x9A9A9A);
    [_oriPriceLb addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerY.centerX.equalTo(self.oriPriceLb);
        make.height.equalTo(0.5);
    }];
    
    _priceLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    [self.contentView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.oriPriceLb.left).offset(FitPTScreen(-25));
        make.centerY.equalTo(self.contentView);
    }];
    
    _numLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:14];
    [self.contentView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLb.left).offset(FitPTScreen(-25));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setGoodInfo:(HLHUICardGoodInfo *)goodInfo {
    _goodInfo = goodInfo;
    [_picView sd_setImageWithURL:[NSURL URLWithString:goodInfo.pic] placeholderImage:[UIImage imageNamed:@"logo_default"]];
    _numLb.text = [NSString stringWithFormat:@"x%ld",goodInfo.num];
    _nameLb.text = goodInfo.title;
    if (![goodInfo.pay_price hl_hasChinese]) {
        _priceLb.text = [NSString moneyPrefixWithMoney:goodInfo.pay_price];
    } else _priceLb.text = goodInfo.pay_price;
    _oriPriceLb.text = [NSString moneyPrefixWithMoney:goodInfo.price];
}

@end
