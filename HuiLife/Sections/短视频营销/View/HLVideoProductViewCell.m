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
//    [self.stateBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    
//
//    _stateV = [[UIView alloc] init];
//    [self.videoImgV addSubview:self.stateV];
//    self.stateV.backgroundColor = UIColorFromRGB(0xFF9900);
//    self.stateV.layer.cornerRadius = FitPTScreen(1);
//    self.stateV.layer.masksToBounds = YES;
//    [self.stateV makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.top.equalTo(FitPTScreen(5));
//    }];
//
//
//
//    self.reasonBtn = [[UIButton alloc] init];
//    [self.reasonBtn setBackgroundImage:[UIImage imageNamed:@"video_wenhao"] forState:UIControlStateNormal];
//    [self.videoImgV addSubview:self.reasonBtn];
//    [self.reasonBtn addTarget:self action:@selector(reasonBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.reasonBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.stateV.right).offset(FitPTScreen(5));
//        make.centerY.equalTo(self.stateV);
//        make.width.height.equalTo(FitPTScreen(16));
//    }];
//
//    self.titleLab = [[UILabel alloc] init];
//    [self.contentView addSubview:self.titleLab];
//    self.titleLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
//    self.titleLab.textColor = UIColorFromRGB(0x333333);
//    self.titleLab.numberOfLines = 2;
//    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.videoImgV.right).offset(FitPTScreen(11));
//        make.right.equalTo(FitPTScreen(-12));
//        make.top.equalTo(self.videoImgV.top).offset(FitPTScreen(2));
//    }];
//
//    self.goodsView = [[UIView alloc] init];
//    [self.contentView addSubview:self.goodsView];
//    self.goodsView.backgroundColor = UIColorFromRGB(0xF6F6F6);
//    self.goodsView.layer.cornerRadius = FitPTScreen(12.5);
//    self.goodsView.layer.masksToBounds = YES;
//    [self.goodsView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLab);
//        make.top.equalTo(self.titleLab.bottom).offset(FitPTScreen(12));
//        make.height.equalTo(FitPTScreen(25));
//        make.right.lessThanOrEqualTo(self.titleLab.right).priorityHigh();
//    }];
//
//    UIImageView *goodsImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_good_tip"]];
//    [self.goodsView addSubview:goodsImgV];
//    [goodsImgV makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.goodsView);
//        make.left.equalTo(FitPTScreen(10.5));
//        make.width.equalTo(FitPTScreen(13));
//        make.height.equalTo(FitPTScreen(14));
//    }];
//
//    self.goodNameLab = [[UILabel alloc] init];
//    [self.goodsView addSubview:self.goodNameLab];
//    self.goodNameLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
//    self.goodNameLab.textColor = UIColorFromRGB(0x666666);
//    [self.goodNameLab makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(goodsImgV.right).offset(FitPTScreen(4.5));
//        make.right.equalTo(FitPTScreen(-11.5));
//        make.centerY.equalTo(self.goodsView);
//    }];
//
//    self.descLab = [[UILabel alloc] init];
//    [self.contentView addSubview:self.descLab];
//    self.descLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
//    self.descLab.textColor = UIColorFromRGB(0x999999);
//    self.descLab.numberOfLines = 2;
//    [self.descLab makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLab);
//        make.right.equalTo(self.titleLab);
//        make.top.equalTo(self.goodsView.bottom).offset(FitPTScreen(14));
//    }];
//
//    self.lookImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_look_tip"]];
//    [self.contentView addSubview:self.lookImgV];
//    [self.lookImgV makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.videoImgV.bottom).offset(FitPTScreen(-2));
//        make.left.equalTo(self.titleLab);
//        make.width.equalTo(FitPTScreen(14));
//        make.height.equalTo(FitPTScreen(9.5));
//    }];
//
//    self.lookLab = [[UILabel alloc] init];
//    [self.contentView addSubview:self.lookLab];
//    self.lookLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
//    self.lookLab.textColor = UIColorFromRGB(0x333333);
//    [self.lookLab makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.lookImgV.right).offset(FitPTScreen(3));
//        make.centerY.equalTo(self.lookImgV);
//    }];
//
//    self.payImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_pay_tip"]];
//    [self.contentView addSubview:self.payImgV];
//    [self.payImgV makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.lookImgV);
//        make.left.equalTo(self.lookLab.right).offset(FitPTScreen(16));
//        make.width.equalTo(FitPTScreen(11));
//        make.height.equalTo(FitPTScreen(10.5));
//    }];
//
//    self.payLab = [[UILabel alloc] init];
//    [self.contentView addSubview:self.payLab];
//    self.payLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
//    self.payLab.textColor = UIColorFromRGB(0x333333);
//    [self.payLab makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.payImgV.right).offset(FitPTScreen(3));
//        make.centerY.equalTo(self.lookLab);
//    }];
}



- (void)setModel:(HLVideoProductModel *)model{
    _model = model;
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _nameLab.text = model.name;
    _salePriceLab.text = [NSString stringWithFormat:@"售价: ¥%.2lf",model.price];
    _orinalPriceLab.text = [NSString stringWithFormat:@"门市价: ¥%.2lf",model.sale];
    _orinalPriceLab.hidden = !self.showOrinalPrice;
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

