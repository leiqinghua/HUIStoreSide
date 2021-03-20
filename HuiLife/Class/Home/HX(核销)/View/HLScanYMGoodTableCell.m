//
//  HLScanYMGoodTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/6/18.
//

#import "HLScanYMGoodTableCell.h"
#import "HLScanYMMainInfo.h"

@interface HLScanYMGoodTableCell ()

@property(nonatomic, strong) UIView *bagView;
@property(nonatomic, strong) UILabel *titleLb;
@end

@implementation HLScanYMGoodTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.clearColor;
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.cornerRadius = FitPTScreen(10);
    _bagView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(12), 0, FitPTScreen(12)));
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x222222);
    _titleLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(12)];
    _titleLb.text = @"订单商品";
    [_bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(15));
    }];
}


- (void)setGoods:(NSArray<HLScanYMGoodInfo *> *)goods {
    if (_goods.count) {
        return;
    }
    _goods = goods;
    [self initGoodsView];
}

- (void)initGoodsView {
    for (NSInteger index = 0; index < _goods.count; index ++) {
        HLScanYMGoodView *goodView = [[HLScanYMGoodView alloc]init];
        goodView.good = _goods[index];
        [self.bagView addSubview:goodView];
        [goodView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bagView);
            make.height.equalTo(FitPTScreen(71));
            make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(71) *index + FitPTScreen(8));
        }];
    }
}

@end


@interface HLScanYMGoodView ()

@property(nonatomic, strong) UIImageView *headView;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *descLb;
@property(nonatomic, strong) UILabel *numLb;
@end

@implementation HLScanYMGoodView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _headView = [[UIImageView alloc]init];
    _headView.layer.cornerRadius = FitPTScreen(2.5);
    _headView.layer.masksToBounds = YES;
    [self addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(11));
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(FitPTScreen(55), FitPTScreen(55)));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor = UIColorFromRGB(0x222222);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [self addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(9));
        make.top.equalTo(self.headView).offset(FitPTScreen(5));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor = UIColorFromRGB(0x999999);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [self addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.bottom.equalTo(self.headView.bottom).offset(FitPTScreen(-5));
    }];
    
    _numLb = [[UILabel alloc]init];
    _numLb.textColor = UIColorFromRGB(0x999999);
    _numLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [self addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self);
    }];
}

- (void)setGood:(HLScanYMGoodInfo *)good {
    _good = good;
    [_headView sd_setImageWithURL:[NSURL URLWithString:good.pro_pic]];
    _nameLb.text = good.pro_name;
    _descLb.text = good.pro_param;
    _numLb.text = good.num;
}
@end
