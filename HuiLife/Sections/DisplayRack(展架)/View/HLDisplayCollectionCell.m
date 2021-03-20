//
//  HLDisplayCollectionCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/25.
//

#import "HLDisplayCollectionCell.h"

@interface HLDisplayCollectionCell ()

@property(nonatomic, strong)UIImageView *bagView;

@property(nonatomic, strong)UILabel *useNumLb;

@property(nonatomic, strong)UILabel *nameLb;

@end

@implementation HLDisplayCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundView.backgroundColor = UIColor.whiteColor;
    
    _bagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"display_bg"]];
    _bagView.contentMode = UIViewContentModeScaleAspectFill;
    _bagView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo(FitPTScreen(230));
    }];
    
    UIImageView *bottomBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"display_bottom_bg"]];
    bottomBgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bagView addSubview:bottomBgView];
    [bottomBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bagView);
    }];
    
    UIImageView *tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"display_tip"]];
    [self.bagView addSubview:tipView];
    [tipView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(31));
        make.bottom.equalTo(FitPTScreen(-9));
    }];
    
    _useNumLb = [[UILabel alloc]init];
    _useNumLb.textColor = UIColorFromRGB(0xA73605);
    _useNumLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [self.bagView addSubview:_useNumLb];
    [_useNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView.right).offset(FitPTScreen(8));
        make.centerY.equalTo(tipView);
    }];
    
    _nameLb = [[UILabel alloc]init];
//    _nameLb.text = @"KTV酒吧";
    _nameLb.textColor = UIColorFromRGB(0x333333);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bagView.bottom).offset(FitPTScreen(10));
        make.centerX.equalTo(self.bagView);
    }];
    
}

- (void)setDisplayModel:(HLDisplayModel *)displayModel {
    _displayModel = displayModel;
    [_bagView sd_setImageWithURL:[NSURL URLWithString:displayModel.image] placeholderImage:[UIImage imageNamed:@""]];
    _useNumLb.text = displayModel.num;
    _nameLb.text = displayModel.title;
}

@end
