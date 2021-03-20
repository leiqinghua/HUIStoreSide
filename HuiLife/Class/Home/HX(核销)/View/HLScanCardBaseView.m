//
//  HLScanCardBaseView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/8/28.
//

#import "HLScanCardBaseView.h"
#import "HLScanCardMainInfo.h"

@interface HLScanCardBaseView ()
@property(nonatomic, strong) UIImageView *bottomView;
@property(nonatomic, strong) UIImageView *tagImV;
@property(nonatomic, strong) UILabel *tagLb;
@end

@implementation HLScanCardBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _bottomView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:_bottomView];
    
    _tagLb = [[UILabel alloc]init];
    _tagLb.frame = CGRectMake(FitPTScreen(302.5), FitPTScreen(5.5), FitPTScreen(60.5), FitPTScreen(16));
    _tagLb.textColor = UIColorFromRGB(0xFD9E2F);
    _tagLb.backgroundColor = UIColorFromRGB(0xFFF5E9);
    [_tagLb hl_addCornerRadius:FitPTScreen(4) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight];
    _tagLb.textAlignment = NSTextAlignmentCenter;
    _tagLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [self addSubview:_tagLb];
}

- (void)tagView:(BOOL)show {
    if (show && !_tagImV) {
        _tagImV = [[UIImageView alloc]init];
        [self addSubview:_tagImV];
        [_tagImV makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-25));
            make.bottom.equalTo(FitPTScreen(-10));
        }];
    }
    _tagImV.hidden = !show;
}

- (void)setGoodInfo:(HLScanCardGoodInfo *)goodInfo {
    _goodInfo = goodInfo;
    self.bottomView.image = goodInfo.gainState==0?[UIImage imageNamed:@"scan_able"]:[UIImage imageNamed:@"scan_unable"];
    [self tagView:(goodInfo.gainState==1)];
    _tagLb.text = goodInfo.gainTypeDesc;
    
    CGFloat width = [goodInfo.gainTypeDesc hl_widthForFont:[UIFont systemFontOfSize:FitPTScreen(11)]] + FitPTScreen(16);
    CGFloat oriX = CGRectGetMaxX(self.bounds) - FitPTScreen(12) - width;
    _tagLb.frame = CGRectMake(oriX, FitPTScreen(5.5), width, FitPTScreen(16));
    [_tagLb hl_addCornerRadius:FitPTScreen(4) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight];
}
@end

//卡
@interface HLScanCardView ()
@property(nonatomic, strong) UILabel *numLb;
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *dateLb;
@property(nonatomic, strong) UILabel *totalNumLb;
@end

@implementation HLScanCardView

- (void)initSubView {
    [super initSubView];
    _numLb = [[UILabel alloc]init];
    _numLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.bottomView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.left).offset(FitPTScreen(61.5));
        make.top.equalTo(FitPTScreen(30));
    }];
    
    _titleLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:11];
    _titleLb.text = @"服务卡";
    [self.bottomView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.numLb);
        make.top.equalTo(self.numLb.bottom).offset(FitPTScreen(10));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#3B3B3B" font:14];
    [self.bottomView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(151));
        make.top.equalTo(FitPTScreen(27));
    }];
    
    _dateLb = [UILabel hl_regularWithColor:@"#888888" font:11];
    [self.bottomView addSubview:_dateLb];
    [_dateLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(8));
    }];
    
    _totalNumLb = [UILabel hl_regularWithColor:@"#888888" font:11];
    [self.bottomView addSubview:_totalNumLb];
    [_totalNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.dateLb.bottom).offset(FitPTScreen(10));
    }];
}

- (void)setGoodInfo:(HLScanCardGoodInfo *)goodInfo {
    [super setGoodInfo:goodInfo];
    self.tagImV.image = [UIImage imageNamed:@"tag_useDone"];
    _numLb.textColor = goodInfo.gainState == 0? UIColorFromRGB(0xFE9E30):UIColorFromRGB(0xCCCCCC);
    NSInteger num = goodInfo.gainNum - goodInfo.gainUse;
    NSString *numStr = [NSString stringWithFormat:@"剩余%ld次",num];
    NSRange numRange = [numStr rangeOfString:[NSString stringWithFormat:@"%ld",num]];
    if (numRange.location != NSNotFound) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:numStr];
        [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)]} range:numRange];
        _numLb.attributedText = attr;
    }
    _nameLb.text = goodInfo.gainName;
    _dateLb.text = [NSString stringWithFormat:@"%@至%@",goodInfo.gainStartTime,goodInfo.gainEndTime];
    _totalNumLb.text = [NSString stringWithFormat:@"总计:%ld次",goodInfo.gainNum];
}

@end

//卷
@interface HLScanVolumeView ()
@property(nonatomic, strong) UILabel *priceLb;
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *dateLb;
@property(nonatomic, strong) UILabel *numLb;
@end

@implementation HLScanVolumeView
- (void)initSubView {
    [super initSubView];
    _priceLb = [[UILabel alloc]init];
    _priceLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.bottomView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.left).offset(FitPTScreen(61.5));
        make.top.equalTo(FitPTScreen(30));
    }];
    
    _titleLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:11];
    _titleLb.text = @"代金券";
    [self.bottomView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.priceLb);
        make.top.equalTo(self.priceLb.bottom).offset(FitPTScreen(10));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#3B3B3B" font:14];
    [self.bottomView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(151));
        make.top.equalTo(FitPTScreen(35));
    }];
    
    _dateLb = [UILabel hl_regularWithColor:@"#888888" font:11];
    [self.bottomView addSubview:_dateLb];
    [_dateLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(11));
    }];
    
    _numLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [self.bottomView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(30));
        make.centerY.equalTo(self.bottomView);
    }];
}

- (void)setGoodInfo:(HLScanCardGoodInfo *)goodInfo {
    [super setGoodInfo:goodInfo];
    _priceLb.textColor = goodInfo.gainState == 0? UIColorFromRGB(0xFE9E30):UIColorFromRGB(0xCCCCCC);
    NSString *price = [NSString stringWithFormat:@"¥%@元",goodInfo.gainPrice];
    NSRange priceRange = [price rangeOfString:goodInfo.gainPrice];
    if (priceRange.location != NSNotFound) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
        [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)]} range:priceRange];
        _priceLb.attributedText = attr;
    }
    _nameLb.text = goodInfo.gainName;
    _dateLb.text = [NSString stringWithFormat:@"%@至%@",goodInfo.gainStartTime,goodInfo.gainEndTime];
    _numLb.text = [NSString stringWithFormat:@"x%ld",goodInfo.gainUse];
    self.tagImV.image = [UIImage imageNamed:@"tag_used"];
}
@end

//礼品
@interface HLScanGiftView ()
@property(nonatomic, strong) UIImageView *picView;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *detailLb;
@end

@implementation HLScanGiftView
- (void)initSubView {
    [super initSubView];
    _picView = [[UIImageView alloc]init];
    _picView.layer.cornerRadius = FitPTScreen(2.5);
    _picView.layer.masksToBounds = YES;
    [self.bottomView addSubview:_picView];
    [_picView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.left).offset(FitPTScreen(61.5));
        make.centerY.equalTo(self.bottomView);
        make.size.equalTo(CGSizeMake(FitPTScreen(60), FitPTScreen(60)));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#3B3B3B" font:14];
    [self.bottomView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(151));
        make.top.equalTo(FitPTScreen(33));
    }];
    
    _detailLb = [UILabel hl_regularWithColor:@"#888888" font:11];
    [self.bottomView addSubview:_detailLb];
    [_detailLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(8));
    }];
}

- (void)setGoodInfo:(HLScanCardGoodInfo *)goodInfo {
    [super setGoodInfo:goodInfo];
    [_picView sd_setImageWithURL:[NSURL URLWithString:goodInfo.gainIcon] placeholderImage:[UIImage imageNamed:@"logo_default"]];
    _nameLb.text = goodInfo.gainName;
    _detailLb.text = goodInfo.gainDesc;
    self.tagImV.image = [UIImage imageNamed:@"tag_acceped"];
}
@end
