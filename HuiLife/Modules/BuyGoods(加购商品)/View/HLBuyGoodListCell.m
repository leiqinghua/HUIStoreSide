//
//  HLBuyGoodListCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBuyGoodListCell.h"

@interface HLBuyGoodListCell ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *goodImgV;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *goodNameLab;
@property (nonatomic, strong) UILabel *priceTipLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *buyNumLab;
@property (nonatomic, strong) UIImageView *statesImgV;
@property (nonatomic, strong) UILabel *statesLab;

@end

@implementation HLBuyGoodListCell

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
    
    _statesImgV = [[UIImageView alloc] init];
    [_goodImgV addSubview:_statesImgV];
    [_statesImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.width.equalTo(FitPTScreen(40));
        make.height.equalTo(FitPTScreen(16));
    }];
    
    _statesLab = [[UILabel alloc] init];
    [_statesImgV addSubview:_statesLab];
    _statesLab.textColor = UIColorFromRGB(0x666666);
    _statesLab.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [_statesLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_statesImgV);
    }];
    
    _goodNameLab = [[UILabel alloc] init];
    [_mainView addSubview:_goodNameLab];
    _goodNameLab.textColor = UIColorFromRGB(0x333333);
    _goodNameLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    [_goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(15));
        make.left.equalTo(_goodImgV.right).offset(FitPTScreen(15));
        make.right.lessThanOrEqualTo(FitPTScreen(-30));
    }];
    
    _moreBtn = [[UIButton alloc] init];
    [_mainView addSubview:_moreBtn];
    [_moreBtn setImage:[UIImage imageNamed:@"share_h_yellow_dot"] forState:UIControlStateNormal];
    [_moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mainView);
        make.centerY.equalTo(_goodNameLab);
        make.width.equalTo(FitPTScreen(27));
        make.height.equalTo(FitPTScreen(27));
    }];
    [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _priceTipLab = [[UILabel alloc] init];
    [_mainView addSubview:_priceTipLab];
    _priceTipLab.text = @"售价";
    _priceTipLab.textColor = UIColorFromRGB(0x666666);
    _priceTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_priceTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLab);
        make.top.equalTo(_goodNameLab.bottom).offset(FitPTScreen(7));
    }];
    
    _priceLab = [[UILabel alloc] init];
    [_mainView addSubview:_priceLab];
    [_priceLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_priceTipLab.bottom).offset(FitPTScreen(2));
        make.left.equalTo(_priceTipLab.right).offset(FitPTScreen(5));
    }];
    
    _timeLab = [[UILabel alloc] init];
    [_mainView addSubview:_timeLab];
    _timeLab.textColor = UIColorFromRGB(0x999999);
    _timeLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLab);
        make.top.equalTo(_priceTipLab.bottom).offset(FitPTScreen(7));
    }];
    
    _buyNumLab = [[UILabel alloc] init];
    [_mainView addSubview:_buyNumLab];
    _buyNumLab.textColor = UIColorFromRGB(0x999999);
    _buyNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_buyNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLab);
        make.top.equalTo(_timeLab.bottom).offset(FitPTScreen(15));
    }];
}

- (void)moreBtnClick{
    if (self.delegate) {
        [self.delegate listCell:self controlGoodModel:self.goodModel];
    }
}

-(void)setGoodModel:(HLBuyGoodListModel *)goodModel{
    _goodModel = goodModel;
    [_goodImgV sd_setImageWithURL:[NSURL URLWithString:goodModel.goodsPic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _goodNameLab.text = goodModel.goodsName;
    _timeLab.text = goodModel.validDate;
    _buyNumLab.text = goodModel.addSum;
    _priceLab.attributedText = goodModel.priceAttr;
    _priceTipLab.text = goodModel.priceTitle;
    
    //1销售中 2已售完 3未开售 4已过期 5已下架
    // 如果是已上架
    if(goodModel.state == 1){
        _statesLab.text = @"";
        _statesImgV.image = [UIImage imageNamed:@"tag_saling"];
    }else{
        _statesLab.text = goodModel.stateTitle;
        _statesImgV.image = [UIImage imageNamed:@"ticket_statu"];
    }
}

@end
