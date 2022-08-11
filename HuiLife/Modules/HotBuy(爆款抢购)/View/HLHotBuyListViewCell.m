//
//  HLHotBuyListViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import "HLHotBuyListViewCell.h"

@interface HLHotBuyListViewCell ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *goodImgV;
@property (nonatomic, strong) UIImageView *stateImgV;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *goodNameLab;
@property (nonatomic, strong) UILabel *priceTipLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *orinalPriceLab;

@property (nonatomic, strong) UILabel *bottomOneLab;
@property (nonatomic, strong) UILabel *bottomTwoLab;
@property (nonatomic, strong) UILabel *bottomThreeLab;

@end

@implementation HLHotBuyListViewCell

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
        make.bottom.equalTo(FitPTScreen(-5));
        make.top.equalTo(FitPTScreen(5));
    }];
    
    _goodImgV = [[UIImageView alloc] init];
    [_mainView addSubview:_goodImgV];
    _goodImgV.layer.cornerRadius = FitPTScreen(8);
    _goodImgV.layer.masksToBounds = YES;
    [_goodImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(15));
        make.left.equalTo(FitPTScreen(10));
        make.width.equalTo(FitPTScreen(76.2));
        make.height.equalTo(FitPTScreen(76.2));
    }];
    
    _stateImgV = [[UIImageView alloc] init];
    [_mainView addSubview:_stateImgV];
    [_stateImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.width.equalTo(FitPTScreen(38));
        make.height.equalTo(FitPTScreen(36));
    }];
    
//
    
    _stateLab = [[UILabel alloc] init];
    [_stateImgV addSubview:_stateLab];
    _stateLab.textColor = UIColorFromRGB(0x666666);
    _stateLab.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [_stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_goodImgV.left).offset(FitPTScreen(2));
        make.centerY.equalTo(_goodImgV.top).offset(FitPTScreen(-1));
    }];
    _stateLab.transform = CGAffineTransformRotate(_stateLab.transform, -M_PI_4);
    
    _goodNameLab = [[UILabel alloc] init];
    [_mainView addSubview:_goodNameLab];
    _goodNameLab.textColor = UIColorFromRGB(0x333333);
    _goodNameLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    [_goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(25));
        make.left.equalTo(_goodImgV.right).offset(FitPTScreen(15));
        make.right.lessThanOrEqualTo(FitPTScreen(-15));
    }];
    
    UIImageView *vipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_tip"]];
    [_mainView addSubview:vipImgV];
    [vipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(5));
        make.right.equalTo(FitPTScreen(-5));
        make.width.equalTo(FitPTScreen(40));
        make.height.equalTo(FitPTScreen(20.5));
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
    _priceTipLab.text = @"抢购价";
    [_priceTipLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _priceTipLab.textColor = UIColorFromRGB(0x666666);
    _priceTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_priceTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLab);
        make.top.equalTo(_goodNameLab.bottom).offset(FitPTScreen(20));
    }];
    
    _priceLab = [[UILabel alloc] init];
    [_mainView addSubview:_priceLab];
    [_priceLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_priceLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_priceTipLab.bottom).offset(FitPTScreen(3));
        make.left.equalTo(_priceTipLab.right).offset(FitPTScreen(3));
    }];
    
    _orinalPriceLab = [[UILabel alloc] init];
    [_mainView addSubview:_orinalPriceLab];
    _orinalPriceLab.textColor = UIColorFromRGB(0x999999);
    _orinalPriceLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_orinalPriceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLab.right).offset(FitPTScreen(20));
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
    _bottomOneLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [_bottomOneLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodImgV);
        make.top.equalTo(_goodImgV.bottom).offset(FitPTScreen(8));
    }];
    
    UIView *verticalLine1 = [[UIView alloc] init];
    [_orinalPriceLab addSubview:verticalLine1];
    verticalLine1.backgroundColor = UIColorFromRGB(0xD7D7D7);
    [verticalLine1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomOneLab);
        make.left.equalTo(_bottomOneLab.right).offset(FitPTScreen(16));
        make.height.equalTo(FitPTScreen(10));
        make.width.equalTo(FitPTScreen(1));
    }];
    
    _bottomTwoLab = [[UILabel alloc] init];
    [_mainView addSubview:_bottomTwoLab];
    _bottomTwoLab.textColor = UIColorFromRGB(0x999999);
    _bottomTwoLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [_bottomTwoLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine1.right).offset(FitPTScreen(10));
        make.centerY.equalTo(_bottomOneLab);
    }];
    
    UIView *verticalLine2 = [[UIView alloc] init];
    [_orinalPriceLab addSubview:verticalLine2];
    verticalLine2.backgroundColor = UIColorFromRGB(0xD7D7D7);
    [verticalLine2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomOneLab);
        make.left.equalTo(_bottomTwoLab.right).offset(FitPTScreen(16));
        make.height.equalTo(FitPTScreen(10));
        make.width.equalTo(FitPTScreen(1));
    }];
    
    _bottomThreeLab = [[UILabel alloc] init];
    [_mainView addSubview:_bottomThreeLab];
    _bottomThreeLab.textColor = UIColorFromRGB(0x999999);
    _bottomThreeLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [_bottomThreeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine2.right).offset(FitPTScreen(10));
        make.centerY.equalTo(_bottomOneLab);
    }];
}

- (void)moreBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listViewCell:moreBtnClick:)]) {
        [self.delegate listViewCell:self moreBtnClick:self.listModel];
    }
}

-(void)setListModel:(HLHotBuyListModel *)listModel{
    _listModel = listModel;
    
    _goodNameLab.text = listModel.proname;
    _priceLab.attributedText = [listModel priceAttr];
    _orinalPriceLab.text = [NSString stringWithFormat:@"原价: %.2lf",listModel.market_price];
    _stateImgV.image = listModel.on_line == 1 ? [UIImage imageNamed:@"tag_saling2"] : [UIImage imageNamed:@"tag_down"];
    _stateLab.hidden = listModel.on_line == 1;
    _stateLab.text = listModel.state;
    _bottomOneLab.text = [NSString stringWithFormat:@"订单数: %@",listModel.num];
    _bottomTwoLab.text = [NSString stringWithFormat:@"使用数: %@",listModel.use_num];
    _bottomThreeLab.text = [NSString stringWithFormat:@"浏览数: %@",listModel.click_num];
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:listModel.propicpath] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
}

@end
