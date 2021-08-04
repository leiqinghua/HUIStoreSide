//
//  HLGroupTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/14.
//

#import "HLGroupTableViewCell.h"

@interface HLGroupTableViewCell ()

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

//@property(nonatomic,strong)UIButton * selectBtn;

@end

@implementation HLGroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _mainView = [[UIView alloc] init];
    [self.contentView addSubview:_mainView];
    _mainView.layer.cornerRadius = FitPTScreen(6);
    _mainView.backgroundColor = UIColor.whiteColor;
    _mainView.layer.shadowRadius = FitPTScreen(6);
    _mainView.layer.shadowColor = UIColor.blackColor.CGColor;
    _mainView.layer.shadowOpacity = 0.08;
    _mainView.layer.shadowOffset = CGSizeMake(0, 0.5);
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
    
    _goodNameLab = [[UILabel alloc] init];
    [_mainView addSubview:_goodNameLab];
    _goodNameLab.textColor = UIColorFromRGB(0x333333);
    _goodNameLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    [_goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(15));
        make.left.equalTo(_goodImgV.right).offset(FitPTScreen(15));
        make.right.lessThanOrEqualTo(FitPTScreen(-50));
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
    _priceTipLab.text = @"拼团价";
    _priceTipLab.textColor = UIColorFromRGB(0x666666);
    _priceTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_priceTipLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_priceTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLab);
        make.top.equalTo(self.goodNameLab.bottom).offset(FitPTScreen(10));
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
    
//    _selectBtn = [[UIButton alloc]init];
//    [_selectBtn setTitle:@"选择" forState:UIControlStateNormal];
//    [_selectBtn setTitle:@"已选择" forState:UIControlStateSelected];
//    [_selectBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateSelected];
//    [_selectBtn setTitleColor:UIColorFromRGB(0xFF8A00) forState:UIControlStateNormal];
//    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
//    _selectBtn.layer.cornerRadius = FitPTScreen(13);
//    _selectBtn.layer.borderColor =UIColorFromRGB(0xFFB016).CGColor;
//    _selectBtn.layer.borderWidth = FitPTScreen(1);
//    [_mainView addSubview:_selectBtn];
//    [_selectBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(FitPTScreen(-15));
//        make.bottom.equalTo(FitPTScreen(-17));
//        make.width.equalTo(FitPTScreen(72));
//        make.height.equalTo(FitPTScreen(26));
//    }];
//    _selectBtn.userInteractionEnabled = false;
}

- (void)moreBtnClick{
    if (self.delegate) {
        [self.delegate listViewCell:self moreBtnClick:self.groupModel];
    }
}


-(void)setGroupModel:(HLGroupModel *)groupModel{
    _groupModel = groupModel;
    
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:groupModel.logo] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _goodNameLab.text = groupModel.name;
    _priceLab.attributedText = groupModel.priceAttr;
    _orinalPriceLab.text = [NSString stringWithFormat:@"原价: %.2lf",groupModel.orgPrice];
    
    //1未开售 2已过期 3已售完 4销售中 5已下架
    _stateImgV.image = groupModel.stateCode != 4 ? [UIImage imageNamed:@"tag_down"] : [UIImage imageNamed:@"tag_saling2"];
    _stateLab.text = groupModel.stateCode == 4 ? @"" : groupModel.state;
    
    _bottomOneLab.text = _groupModel.groupPeoNum;
    _bottomTwoLab.text = _groupModel.buyCnt;
    
    if (_select) {
        HLGroupSelectModel * selectModel = (HLGroupSelectModel *)_groupModel;
        
        [_goodImgV sd_setImageWithURL:[NSURL URLWithString:selectModel.pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
        _goodNameLab.text = selectModel.title;
        
        _mainView.layer.borderColor = selectModel.clicked?UIColorFromRGB(0xFF7D2E).CGColor:UIColor.clearColor.CGColor;
        _mainView.layer.shadowColor = selectModel.clicked?UIColorFromRGB(0xFFA758).CGColor:UIColor.blackColor.CGColor;
        _mainView.layer.borderWidth = selectModel.clicked?FitPTScreen(0.8):0;
        
        _mainView.layer.shadowOpacity = selectModel.clicked?0.27:0.08;
        _mainView.layer.shadowOffset = selectModel.clicked?CGSizeMake(0, 0):CGSizeMake(0, 0.5);
        
        _bottomOneLab.text = selectModel.orderNumText;
        _bottomTwoLab.text = selectModel.useNumText;
    }
    
}


-(void)setSelect:(BOOL)select{
    _select = select;
    _stateImgV.hidden = select;
    _moreBtn.hidden = select;
//    _selectBtn.hidden = !select;
}

@end
