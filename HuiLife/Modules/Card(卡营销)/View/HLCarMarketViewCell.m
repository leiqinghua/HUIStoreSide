//
//  HLCarMarketViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLCarMarketViewCell.h"

@interface HLCarMarketViewCell ()

@property(nonatomic,strong)UIImageView * statuImgV;

@property(strong,nonatomic)UILabel * statuLb;

@property(nonatomic,strong)UILabel * numLb;

@property(nonatomic,strong)UILabel * nameLb;

@property(nonatomic,strong)UIButton * shareBtn;

@property(nonatomic,strong)UILabel * orinPriceLb;

@property(nonatomic,strong)UILabel * priceLb;

@property(nonatomic,strong)UILabel * seilNumLb;

@property(nonatomic,strong)UILabel * tgLb;

@end

@implementation HLCarMarketViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_market_bg"]];
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgView.layer.cornerRadius = FitPTScreen(10);
    _bgView.layer.masksToBounds = YES;
    _bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(29), FitPTScreen(5), FitPTScreen(29)));
    }];
    
//    ys_ing ticket_statu
    _statuImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag_saling"]];
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_statuImgV];
    [_statuImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView);
    }];
    
    _numLb = [[UILabel alloc]init];
    _numLb.textColor =UIColorFromRGB(0x913000);
    _numLb.font = [UIFont systemFontOfSize:FitPTScreen(32)];
    _numLb.text = @"30次";
    [self.bgView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(FitPTScreen(37));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor =UIColorFromRGB(0x913000);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(17)];
    _nameLb.text = @"空调深度清洗";
    _nameLb.numberOfLines = 2;
    [self.bgView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLb.right).offset(FitPTScreen(39));
        make.centerY.equalTo(self.numLb);
        make.width.lessThanOrEqualTo(FitPTScreen(150));
    }];
    
    _orinPriceLb = [[UILabel alloc]init];
    _orinPriceLb.textColor =UIColorFromRGB(0x913000);
    _orinPriceLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _orinPriceLb.text = @"原价¥900";
    [self.bgView addSubview:_orinPriceLb];
    [_orinPriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLb);
        make.top.equalTo(self.numLb.bottom).offset(FitPTScreen(23));
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0x913000);
    [_orinPriceLb addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self.orinPriceLb);
        make.height.equalTo(0.6);
    }];
    
    _priceLb = [[UILabel alloc]init];
    _priceLb.textColor =UIColorFromRGB(0x913000);
    _priceLb.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    _priceLb.text = @"售价 ¥520";
    [self.bgView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orinPriceLb.right).offset(FitPTScreen(38));
        make.centerY.equalTo(self.orinPriceLb);
    }];
    
    _seilNumLb = [[UILabel alloc]init];
    _seilNumLb.textColor =UIColorFromRGB(0xBC8631);
    _seilNumLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _seilNumLb.text = @"已售：88份";
    [self.bgView addSubview:_seilNumLb];
    [_seilNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLb);
        make.bottom.equalTo(FitPTScreen(-20));
    }];
    
    _tgLb = [[UILabel alloc]init];
    _tgLb.textColor =UIColorFromRGB(0xFF5A3F);
    _tgLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _tgLb.text = @"推广效果：极佳";
    [self.bgView addSubview:_tgLb];
    [_tgLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-19));
        make.centerY.equalTo(self.seilNumLb);
    }];
    
    _shareBtn = [[UIButton alloc]init];
    [_shareBtn setImage:[UIImage imageNamed:@"share_h_yellow_dot"] forState:UIControlStateNormal];
    [self.bgView addSubview:_shareBtn];
    [_shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.nameLb);
    }];
    
    [_shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _statuLb = [[UILabel alloc]init];
    _statuLb.textColor =UIColorFromRGB(0x666666);
    _statuLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _statuLb.text = @"已过期";
    _statuLb.textAlignment = NSTextAlignmentCenter;
    [self.statuImgV addSubview:_statuLb];
    [_statuLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.statuImgV);
    }];
}


-(void)shareClick{
    if ([self.delegate respondsToSelector:@selector(cardMarkcetCell:shareWithModel:)]) {
        [self.delegate cardMarkcetCell:self shareWithModel:_baseModel];
    }
}


-(void)setIsPromote:(BOOL)isPromote{
    _isPromote = isPromote;
    _statuImgV.hidden = isPromote;
    
}

-(void)configSelectCell{
    _statuImgV.hidden = YES;
    _tgLb.hidden = YES;
    _shareBtn.hidden = YES;
}


-(void)setBaseModel:(HLCardListModel *)baseModel{
    _baseModel = baseModel;
    _numLb.attributedText = baseModel.numAttr;
    _statuImgV.image = [UIImage imageNamed:baseModel.couponStatus == 0?@"tag_saling":@"ticket_statu"];
    _statuLb.hidden = baseModel.couponStatus == 0;
    _statuLb.text = baseModel.statusDesc;
    _nameLb.text = baseModel.cardName;
    _orinPriceLb.text = baseModel.originaPrice;
    _seilNumLb.text = baseModel.saleDesc;
    _tgLb.text = baseModel.marketEffect;
    _tgLb.textColor = baseModel.promoteColor;
    _priceLb.text = baseModel.salePrice;
}


@end

