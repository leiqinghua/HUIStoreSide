//
//  HLHotSekillListViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLHotSekillListViewCell.h"

@interface HLHotSekillListViewCell ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *goodImgV;
@property (nonatomic, strong) UIImageView *stateImgV;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *goodNameLab;
@property (nonatomic, strong) UILabel *priceTipLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *orinalPriceLab;
@property (nonatomic, strong) UIView *reasonBgView;
@property (nonatomic, strong) UIButton *reasonBtn;

@property (nonatomic, strong) UILabel *effectLab;

@property (nonatomic, strong) UILabel *bottomOneLab;
@property (nonatomic, strong) UILabel *bottomTwoLab;
@property (nonatomic, strong) UILabel *bottomThreeLab;

@property (nonatomic, strong) UILabel *selectLab;


@end

@implementation HLHotSekillListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _mainView = [[UIView alloc] init];
    [self.contentView addSubview:_mainView];
    _mainView.layer.cornerRadius = FitPTScreen(6);
    _mainView.backgroundColor = UIColor.whiteColor;
    _mainView.layer.shadowRadius = FitPTScreen(6);
    _mainView.layer.shadowColor = UIColor.blackColor.CGColor;
    _mainView.layer.shadowOpacity = 0.08;
    _mainView.layer.shadowOffset = CGSizeMake(0, 0.5);
    _mainView.layer.borderColor = UIColorFromRGB(0xFF9F23).CGColor;
    _mainView.layer.borderWidth = 0;
    [_mainView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.right.equalTo(FitPTScreen(-13));
        make.height.equalTo(FitPTScreen(123));
        make.top.equalTo(FitPTScreen(6));
    }];
    
    _goodImgV = [[UIImageView alloc] init];
    [_mainView addSubview:_goodImgV];
    _goodImgV.layer.cornerRadius = FitPTScreen(8);
    _goodImgV.layer.masksToBounds = YES;
    [_goodImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mainView);
        make.left.equalTo(FitPTScreen(10));
        make.width.equalTo(FitPTScreen(92));
        make.height.equalTo(FitPTScreen(92));
    }];
    
    _stateImgV = [[UIImageView alloc] init];
    [_mainView addSubview:_stateImgV];
    [_stateImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.width.equalTo(FitPTScreen(38));
        make.height.equalTo(FitPTScreen(36));
    }];
    
    _stateLab = [[UILabel alloc] init];
    [_stateImgV addSubview:_stateLab];
    _stateLab.textColor = UIColorFromRGB(0x666666);
    _stateLab.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [_stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_goodImgV.left).offset(FitPTScreen(2));
        make.centerY.equalTo(_goodImgV.top).offset(FitPTScreen(-1));
    }];
    _stateLab.transform = CGAffineTransformRotate(_stateLab.transform, -M_PI_4);
    
    _reasonBgView = [[UIView alloc] init];
    _reasonBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [_mainView addSubview:_reasonBgView];
    _reasonBgView.layer.cornerRadius = FitPTScreen(8);
    _reasonBgView.layer.masksToBounds = YES;
    [_reasonBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.goodImgV);
    }];
    [_reasonBgView hl_addTarget:self action:@selector(reasonClick)];
    
    _reasonBtn = [[UIButton alloc] init];
    _reasonBtn.userInteractionEnabled = NO;
    [_reasonBgView addSubview:_reasonBtn];
    [_reasonBtn setBackgroundImage:[UIImage imageNamed:@"video_wenhao"] forState:UIControlStateNormal];
    [_reasonBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(28);
        make.center.equalTo(self.reasonBgView);
    }];
    
    _goodNameLab = [[UILabel alloc] init];
    [_mainView addSubview:_goodNameLab];
    _goodNameLab.textColor = UIColorFromRGB(0x333333);
    _goodNameLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    [_goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(15));
        make.left.equalTo(_goodImgV.right).offset(FitPTScreen(15));
        make.right.lessThanOrEqualTo(FitPTScreen(-50));
    }];
    
    _effectLab = [[UILabel alloc] init];
    [_mainView addSubview:_effectLab];
    _effectLab.textColor = UIColorFromRGB(0x80BCFF);
    _effectLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _effectLab.textAlignment = NSTextAlignmentCenter;
    _effectLab.layer.borderWidth = 0.7;
    _effectLab.layer.borderColor = UIColorFromRGB(0x80BCFF).CGColor;
    _effectLab.layer.cornerRadius = FitPTScreen(3);
    [_effectLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodNameLab.bottom).offset(FitPTScreen(5));
        make.left.equalTo(_goodNameLab);
        make.width.equalTo(FitPTScreen(88));
        make.height.equalTo(FitPTScreen(17));
    }];
    
    _moreBtn = [[UIButton alloc] init];
    [_mainView addSubview:_moreBtn];
    [_moreBtn setImage:[UIImage imageNamed:@"share_h_yellow_dot"] forState:UIControlStateNormal];
    [_moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_mainView);
        make.width.equalTo(FitPTScreen(43));
        make.height.equalTo(FitPTScreen(37));
    }];
    [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _priceTipLab = [[UILabel alloc] init];
    [_mainView addSubview:_priceTipLab];
    _priceTipLab.text = @"售价";
    [_priceTipLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _priceTipLab.textColor = UIColorFromRGB(0x666666);
    _priceTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_priceTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLab);
        make.top.equalTo(_effectLab.bottom).offset(FitPTScreen(10));
    }];
    
    _priceLab = [[UILabel alloc] init];
    [_priceLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_mainView addSubview:_priceLab];
    [_priceLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_priceTipLab.bottom).offset(FitPTScreen(3));
        make.left.equalTo(_priceTipLab.right).offset(FitPTScreen(3));
    }];
    
    _orinalPriceLab = [[UILabel alloc] init];
    [_mainView addSubview:_orinalPriceLab];
    _orinalPriceLab.textColor = UIColorFromRGB(0x999999);
    _orinalPriceLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_orinalPriceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLab.right).offset(FitPTScreen(10));
        make.bottom.equalTo(_priceTipLab.bottom).offset(FitPTScreen(0));
        make.right.lessThanOrEqualTo(FitPTScreen(-10));
    }];

    UIView *line = [[UIView alloc] init];
    [_orinalPriceLab addSubview:line];
    line.backgroundColor = UIColorFromRGB(0x999999);
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(_orinalPriceLab);
        make.height.equalTo(FitPTScreen(0.8));
    }];
    
    //
    _bottomOneLab = [[UILabel alloc] init];
    [_mainView addSubview:_bottomOneLab];
    _bottomOneLab.textColor = UIColorFromRGB(0x999999);
    _bottomOneLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_bottomOneLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLab);
        make.bottom.equalTo(_goodImgV.bottom).offset(FitPTScreen(-3));
    }];
    
    _bottomTwoLab = [[UILabel alloc] init];
    [_mainView addSubview:_bottomTwoLab];
    _bottomTwoLab.textColor = UIColorFromRGB(0x999999);
    _bottomTwoLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_bottomTwoLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_goodImgV.right).offset(FitPTScreen(120));
        make.bottom.equalTo(_bottomOneLab);
    }];
    
    _bottomThreeLab = [[UILabel alloc] init];
    [_mainView addSubview:_bottomThreeLab];
    _bottomThreeLab.textColor = UIColorFromRGB(0x999999);
    _bottomThreeLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_bottomThreeLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-11));
        make.bottom.equalTo(_bottomOneLab);
    }];
    
    _selectLab = [[UILabel alloc] init];
    [_mainView addSubview:_selectLab];
    _selectLab.layer.borderWidth = 1;
    _selectLab.layer.cornerRadius = FitPTScreen(12);
    _selectLab.textAlignment = NSTextAlignmentCenter;
    _selectLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_selectLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(_effectLab.centerY);
        make.width.equalTo(FitPTScreen(72));
        make.height.equalTo(FitPTScreen(26));
    }];
    _selectLab.hidden = YES;
}

- (void)moreBtnClick{
    if (self.delegate) {
        [self.delegate listViewCell:self moreBtnClick:self.goodModel];
    }
}

- (void)reasonClick{
    if (self.delegate) {
        [self.delegate listViewCell:self reasonClick:self.goodModel];
    }
}

-(void)setGoodModel:(HLHotSekillGoodModel *)goodModel{
    _goodModel = goodModel;
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:goodModel.pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _goodNameLab.text = goodModel.title;
    _orinalPriceLab.text = [NSString stringWithFormat:@"原价: %.2lf",goodModel.orgPrice];

    if (self.sekillType == HLHotSekillTypeNormal || self.sekillType == HLHotSekillType40) {
        _orinalPriceLab.hidden = NO;
        _priceTipLab.text = @"售价";
        _priceLab.attributedText = goodModel.priceAttr;
    }else{
        _orinalPriceLab.hidden = YES;
        _priceTipLab.text = @"价值";
        _priceLab.attributedText = goodModel.noNormalTypePriceAttr;
    }
    
    //1未开售 2已过期 3已售完 4销售中 5已下架 6未通过
    _stateImgV.image = goodModel.stateCode != 4 ? [UIImage imageNamed:@"tag_down"] : [UIImage imageNamed:@"tag_saling2"];
    _stateLab.text = goodModel.stateCode == 4 ? @"" : goodModel.state;
    
    _reasonBgView.hidden = goodModel.stateCode != 6;
    
    _bottomOneLab.text = [NSString stringWithFormat:@"订单数: %ld",goodModel.orderCnt];
    _bottomTwoLab.text = [NSString stringWithFormat:@"使用数: %ld",goodModel.usedCnt];
    _bottomThreeLab.text = [NSString stringWithFormat:@"浏览数: %ld",goodModel.hitsCnt];

    _effectLab.text = [NSString stringWithFormat:@"推广效果：%@",goodModel.popularize];
    _effectLab.textColor = [UIColor hl_StringToColor:goodModel.popularColor];
    _effectLab.layer.borderColor = [UIColor hl_StringToColor:goodModel.popularColor].CGColor;
    
    // 判断是否展示选中的状态
    if (self.showSelectView) {
        _selectLab.hidden = NO;
        _moreBtn.hidden = YES;
        _selectLab.text = goodModel.isSelected ? @"已选择" : @"选择";
        _selectLab.textColor = goodModel.isSelected ? UIColorFromRGB(0x555555) : UIColorFromRGB(0xFF8A00);
        _selectLab.layer.borderColor = goodModel.isSelected ? UIColorFromRGB(0xD8D8D8).CGColor : UIColorFromRGB(0xFFB016).CGColor;
        _mainView.layer.borderWidth = goodModel.userSelect ? 1 : 0;
        
    }else{
        _selectLab.hidden = YES;
        _moreBtn.hidden = NO;
    }
}

@end
