//
//  HLMarketCollectionCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLMarketCollectionCell.h"

@interface HLMarketCollectionCell ()

@property(nonatomic,strong)UILabel * nameLb;

@property(nonatomic,strong)UILabel * statuLb;

@property(nonatomic,strong)UIImageView * bgImv;

@end

@implementation HLMarketCollectionCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    
    UIView * bagView = [[UIView alloc]init];
    bagView.layer.shadowColor = UIColorFromRGB(0xD3D3D3).CGColor;
    bagView.layer.shadowOffset = CGSizeMake(0,3);
    bagView.layer.shadowOpacity = 0.3;
    bagView.layer.shadowRadius = 7;
    bagView.layer.cornerRadius = 8.5;
    bagView.layer.masksToBounds = false;
    [self.contentView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.width.height.equalTo(FitPTScreen(97));
    }];
    
    _bgImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_list_default"]];
    [bagView addSubview:_bgImv];
    [_bgImv makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bagView);
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    _nameLb.text = @"";
    [bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bagView);
        make.top.equalTo(FitPTScreen(22));
    }];
    
    _statuLb = [[UILabel alloc]init];
    _statuLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _statuLb.text = @"";
    _statuLb.numberOfLines = 2;
    _statuLb.textAlignment = NSTextAlignmentCenter;
    [bagView addSubview:_statuLb];
    [_statuLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(5));
        make.width.lessThanOrEqualTo(FitPTScreen(69));
    }];
}

-(void)setModel:(HLMarketMainModel *)model{
    _model = model;
    [_bgImv sd_setImageWithURL:[NSURL URLWithString:model.backgroundImg] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _nameLb.text = model.name;
    _statuLb.text = model.state;
    _nameLb.textColor = [HLTools hl_toColorByColorStr:model.fontColor];
    _statuLb.textColor = [HLTools hl_toColorByColorStr:model.fontColor];
}

@end
