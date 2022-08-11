//
//  HLPickUpGoodViewCell.m
//  HuiLife
//
//  Created by 王策 on 2020/1/15.
//

#import "HLPickUpGoodViewCell.h"

@interface HLPickUpGoodViewCell ()

@property (nonatomic, strong) UIImageView *goodImgV;
@property (nonatomic, strong) UILabel *goodNameLab;
@property (nonatomic, strong) UILabel *goodNumLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UIButton *redPriceBtn;
@property (nonatomic, strong) UILabel *sumTipLab;
@property (nonatomic, strong) UILabel *sumPriceLab;

@end

@implementation HLPickUpGoodViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _goodImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_goodImgV];
    _goodImgV.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [_goodImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(FitPTScreen(76));
    }];
    
    _goodNameLab = [[UILabel alloc] init];
    _goodNameLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _goodNameLab.textColor = UIColorFromRGB(0x222222);
    _goodNameLab.numberOfLines = 3;
    [self.contentView addSubview:_goodNameLab];
    [_goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodImgV.right).offset(FitPTScreen(11));
        make.top.equalTo(_goodImgV.top);
        make.right.lessThanOrEqualTo(FitPTScreen(-85));
    }];
    
    _goodNumLab = [[UILabel alloc] init];
    [self.contentView addSubview:_goodNumLab];
    _goodNumLab.textColor = UIColorFromRGB(0x333333);
    _goodNumLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_goodNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-17));
        make.top.equalTo(_goodImgV.top);
        make.width.lessThanOrEqualTo(FitPTScreen(70));
    }];
 
    _priceLab = [[UILabel alloc] init];
    [self.contentView addSubview:_priceLab];
    _priceLab.textColor = UIColorFromRGB(0x222222);
    _priceLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(13)];
    [_priceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLab);
        make.bottom.equalTo(_goodImgV.bottom).offset(FitPTScreen(3));
    }];
    
    // 立减的钱显示 Button
//    _redPriceBtn = [[UIButton alloc] init];
//    [self.contentView addSubview:_redPriceBtn];
//    _redPriceBtn.userInteractionEnabled = NO;
//    _redPriceBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(11)];
//    [_redPriceBtn setTitleColor:UIColorFromRGB(0xFF5454) forState:UIControlStateNormal];
//    [_redPriceBtn setBackgroundImage:[UIImage imageNamed:@"order_lijian_bg"] forState:UIControlStateNormal];
//    [_redPriceBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(FitPTScreen(80));
//        make.height.equalTo(FitPTScreen(16.5));
//        make.left.equalTo(_priceLab.right);
//        make.centerY.equalTo(_priceLab);
//    }];
    
    _sumPriceLab = [[UILabel alloc] init];
    [self.contentView addSubview:_sumPriceLab];
    _sumPriceLab.textColor = UIColorFromRGB(0xFF4040);
    _sumPriceLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(13)];
    [_sumPriceLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_goodNumLab);
        make.centerY.equalTo(_priceLab);
    }];
    
    _sumTipLab = [[UILabel alloc] init];
    [self.contentView addSubview:_sumTipLab];
    _sumTipLab.text = @"小计";
    _sumTipLab.textColor = UIColorFromRGB(0x5A5A5A);
    _sumTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_sumTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_sumPriceLab.left).offset(FitPTScreen(-3));
        make.centerY.equalTo(_sumPriceLab);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodImgV);
        make.right.equalTo(_goodNumLab);
        make.bottom.equalTo(0);
        make.height.equalTo(0.6);
    }];
}

- (NSAttributedString *)salePriceAttrWithMoney:(double)price{
    UIFont *font = [UIFont boldSystemFontOfSize:FitPTScreen(18)];
    NSString *allStr = [NSString stringWithFormat:@"¥%@",[NSString hl_stringNoZeroWithDoubleValue:price]];
    NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr];
    if ([allStr containsString:@"."]) {
        NSRange dotRange = [allStr rangeOfString:@"."];
        [moneyAttr addAttribute:NSFontAttributeName value:font range:NSMakeRange(1, dotRange.location - 1)];
    }else{
        [moneyAttr addAttribute:NSFontAttributeName value:font range:NSMakeRange(1, allStr.length - 1)];
    }
    return moneyAttr;
}

- (void)setGoodModel:(HLPickUpGoodModel *)goodModel {
    _goodModel = goodModel;
    // 设置 model 的 setter 方法中写这些
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:goodModel.pro_pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _goodNameLab.text = goodModel.pro_name;
    _goodNumLab.text = [NSString stringWithFormat:@"x%ld",goodModel.pro_num];
    // 单价
    _priceLab.attributedText = [self salePriceAttrWithMoney:goodModel.price];
//    [_redPriceBtn setTitle:@"红包减0.10元" forState:UIControlStateNormal];
    // 小计价格
    _sumPriceLab.attributedText = [self salePriceAttrWithMoney:goodModel.pay_price];
}

@end
