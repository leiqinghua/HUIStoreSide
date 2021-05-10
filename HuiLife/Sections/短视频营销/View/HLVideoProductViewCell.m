//
//  HLVideoProductViewCell.m
//  HuiLife
//
//  Created by 王策 on 2021/4/23.
//

#import "HLVideoProductViewCell.h"

@interface HLVideoProductViewCell ()

@property (nonatomic, strong) UIImageView *goodImgV;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *stateBtn;
@property (nonatomic, strong) UILabel *orinalPriceLab;
@property (nonatomic, strong) UILabel *salePriceLab;

@end

@implementation HLVideoProductViewCell

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
    _goodImgV.contentMode = UIViewContentModeScaleAspectFill;
    _goodImgV.clipsToBounds = YES;
    [_goodImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(FitPTScreen(12));
        make.width.equalTo(FitPTScreen(90));
        make.height.equalTo(FitPTScreen(90));
    }];
    
    _nameLab = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLab];
    _nameLab.textColor = UIColorFromRGB(0x555555);
    _nameLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _nameLab.numberOfLines = 2;
    [_nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.left.equalTo(_goodImgV.right).offset(FitPTScreen(16));
        make.top.equalTo(_goodImgV.top).offset(FitPTScreen(2));
    }];
    
    self.stateBtn = [[UIButton alloc] init];
    self.stateBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.stateBtn setTitle:@"选择" forState:UIControlStateNormal];
    [self.contentView addSubview:self.stateBtn];
    [self.stateBtn addTarget:self action:@selector(stateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.stateBtn.layer.cornerRadius = FitPTScreen(6);
    self.stateBtn.layer.masksToBounds = YES;
    self.stateBtn.layer.borderColor = UIColorFromRGB(0xFD9927).CGColor;
    self.stateBtn.layer.borderWidth = FitPTScreen(1);
    [self.stateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-15));
        make.right.equalTo(FitPTScreen(-12));
        make.height.equalTo(FitPTScreen(24));
        make.width.equalTo(FitPTScreen(55));
    }];
    
    _salePriceLab = [[UILabel alloc] init];
    [self.contentView addSubview:_salePriceLab];
    _salePriceLab.textColor = UIColorFromRGB(0x555555);
    _salePriceLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(12)];
    [_salePriceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLab);
        make.centerY.equalTo(self.stateBtn);
    }];
    
    _orinalPriceLab = [[UILabel alloc] init];
    [self.contentView addSubview:_orinalPriceLab];
    _orinalPriceLab.textColor = UIColorFromRGB(0x999999);
    _orinalPriceLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_orinalPriceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_salePriceLab);
        make.bottom.equalTo(_salePriceLab.top).offset(FitPTScreen(-9));
    }];
    
    UIView *line = [[UIView alloc] init];
    [self.orinalPriceLab addSubview:line];
    line.backgroundColor = UIColorFromRGB(0x999999);
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.orinalPriceLab);
        make.centerY.equalTo(self.orinalPriceLab);
        make.height.equalTo(FitPTScreen(1));
    }];
    
    UIImageView *vipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_product_vip"]];
    [self.contentView addSubview:vipImgV];
    [vipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(FitPTScreen(70));
        make.height.equalTo(FitPTScreen(27));
        make.top.equalTo(FitPTScreen(0));
        make.right.equalTo(FitPTScreen(-12));
    }];
}

- (void)stateBtnClick{
    
    // 使用中则不执行
    if (self.model.state == 1 && ![self.model.pro_id isEqualToString:self.pro_id]) {
        return;
    }
    
    if (self.delegate) {
        [self.delegate productViewCell:self selectProductModel:self.model];
    }
}

- (void)setModel:(HLVideoProductModel *)model{
    _model = model;
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _nameLab.text = model.name;
    _salePriceLab.text = [NSString stringWithFormat:@"售价: ¥%.2lf",model.sale];
    _orinalPriceLab.text = [NSString stringWithFormat:@"门市价: ¥%.2lf",model.price];
    _orinalPriceLab.hidden = !self.showOrinalPrice;
    // 不显示原价，说明为外卖
    if(!self.showOrinalPrice){
        _salePriceLab.text = [NSString stringWithFormat:@"售价: ¥%.2lf",model.sale];
    }
    if ([model.pro_id isEqualToString:self.pro_id]) {
        // 已选择
        [self.stateBtn setTitle:@"已选择" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.stateBtn.backgroundColor = UIColorFromRGB(0xFD9927);
        self.stateBtn.layer.borderWidth = 0;
    }else if(model.state == 1){
        // 使用中
        [self.stateBtn setTitle:@"使用中" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.stateBtn.backgroundColor = UIColorFromRGB(0xCCCCCC);
        self.stateBtn.layer.borderWidth = 0;
    }else if(model.state == 0){
        // 选择
        [self.stateBtn setTitle:@"选择" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:UIColorFromRGB(0xFD9927) forState:UIControlStateNormal];
        self.stateBtn.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.stateBtn.layer.borderWidth = FitPTScreen(1);
    }
}

@end

