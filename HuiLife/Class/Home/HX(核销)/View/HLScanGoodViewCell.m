//
//  HLScanGoodViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/10/31.
//

#import "HLScanGoodViewCell.h"

@interface HLScanGoodViewCell ()

@property(nonatomic, strong) UILabel *orderLb;

@property(nonatomic, strong) UILabel *stateLb;

@property(nonatomic, strong) UIImageView *headView;

@property(nonatomic, strong) UILabel *nameLb;

@property(nonatomic, strong) UILabel *timeLb;

@property(nonatomic, strong) UILabel *priceLb;

@property(nonatomic, strong) UILabel *oriPriceLb;

@property(nonatomic, strong) UILabel *numLb;

@end

@implementation HLScanGoodViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.clearColor;
    UIView *bagView = [[UIView alloc]init];
    bagView.backgroundColor = UIColor.whiteColor;
    bagView.layer.cornerRadius = FitPTScreen(9);
    [self.contentView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(10), 0, FitPTScreen(10)));
    }];
    
    _orderLb = [[UILabel alloc]init];
    _orderLb.textColor = UIColorFromRGB(0x222222);
    _orderLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [bagView addSubview:_orderLb];
    [_orderLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(16));
    }];
    
    _stateLb = [[UILabel alloc]init];
    _stateLb.textColor = UIColorFromRGB(0xFF7213);
    _stateLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [bagView addSubview:_stateLb];
    [_stateLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.orderLb);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.right.equalTo(FitPTScreen(-13));
        make.top.equalTo(self.orderLb.bottom).offset(FitPTScreen(12));
        make.height.equalTo(0.8);
    }];
    
    _headView = [[UIImageView alloc]init];
    [bagView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.bottom.equalTo(FitPTScreen(-18));
        make.width.height.equalTo(FitPTScreen(76));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor = UIColorFromRGB(0x222222);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _nameLb.numberOfLines = 2;
    [bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(12));
        make.top.equalTo(line.bottom).offset(FitPTScreen(17));
        make.width.lessThanOrEqualTo(FitPTScreen(232));
    }];
    
    _timeLb = [[UILabel alloc]init];
    _timeLb.textColor = UIColorFromRGB(0x999999);
    _timeLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [bagView addSubview:_timeLb];
    [_timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(9));
    }];
    
    _priceLb = [[UILabel alloc]init];
    _priceLb.textColor = UIColorFromRGB(0xFF4040);
    [bagView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.bottom.equalTo(FitPTScreen(-11));
    }];
    
    _oriPriceLb = [[UILabel alloc]init];
    _oriPriceLb.textColor = UIColorFromRGB(0x888888);
    _oriPriceLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [bagView addSubview:_oriPriceLb];
    [_oriPriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLb.right).offset(FitPTScreen(10));
        make.bottom.equalTo(self.priceLb).offset(-2);
//        make.centerY.equalTo(self.priceLb);
    }];
    
    UIView *priceLine = [[UIView alloc]init];
    priceLine.backgroundColor = UIColorFromRGB(0x888888);
    [_oriPriceLb addSubview:priceLine];
    [priceLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.width.equalTo(self.oriPriceLb);
        make.height.equalTo(0.7);
    }];
    
    _numLb = [[UILabel alloc]init];
    _numLb.textColor = UIColorFromRGB(0x333333);
    _numLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [bagView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.bottom.equalTo(FitPTScreen(-19));
    }];
}

- (void)setGoodModel:(HLScanGoodModel *)goodModel {
    _goodModel = goodModel;
    _stateLb.text = goodModel.is_hx == 0 ? @"未使用" : @"已使用";
    _orderLb.text = [NSString stringWithFormat:@"订单号：%@",goodModel.order_id];
    [_headView sd_setImageWithURL:[NSURL URLWithString:goodModel.pro_pic] placeholderImage:[UIImage imageNamed:@"logo_default"]];
    _nameLb.text = goodModel.pro_name;
    _numLb.text = [NSString stringWithFormat:@"x%ld",goodModel.num];
    _timeLb.text = goodModel.closing_date;
    _oriPriceLb.text = [NSString stringWithFormat:@"￥%@",goodModel.price_y];
    _priceLb.attributedText = [goodModel priceAttr];
}

@end


@implementation HLScanGoodModel

- (NSAttributedString *)priceAttr {
    NSString *price = [NSString stringWithFormat:@"￥%@",_price];
    NSMutableAttributedString *muttr = [[NSMutableAttributedString alloc]initWithString:price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(18)]}];
    [muttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(13)]} range:NSMakeRange(0, 1)];
    NSRange dot = [price rangeOfString:@"."];
    if (dot.location != NSNotFound) {
        [muttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(17)]} range:dot];
        [muttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]} range:NSMakeRange(dot.location + 1, price.length - dot.location - 1)];
    }
    
    return muttr;
}

@end
