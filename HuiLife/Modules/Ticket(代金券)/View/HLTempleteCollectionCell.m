//
//  HLTempleteCollectionCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLTempleteCollectionCell.h"

@interface HLTempleteCollectionCell ()

@property(strong,nonatomic)UIImageView * bgImgV;

@property(strong,nonatomic)UIView * coverView;

@property(strong,nonatomic)UILabel * titleLb;

@property(strong,nonatomic)UIImageView * statuImgV;

@property(nonatomic,strong)UIButton * deleteBtn;

@end

@implementation HLTempleteCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)deleteClick{
    if ([self.delegate respondsToSelector:@selector(collectionCell:deteleWithModel:)]) {
        [self.delegate collectionCell:self deteleWithModel:_model];
    }
}

-(void)initView{
    _bgImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_default"]];
    _bgImgV.layer.cornerRadius = FitPTScreen(5);
    _bgImgV.layer.masksToBounds = YES;
    _bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_bgImgV];
    [_bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(180));
        make.height.equalTo(FitPTScreen(144));
    }];
    
    _coverView = [[UIView alloc]init];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [_bgImgV addSubview:_coverView];
    [_coverView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.bgImgV);
        make.height.equalTo(FitPTScreen(31));
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor =UIColorFromRGB(0xFFFFFF);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _titleLb.text = @"使用主题";
    [_bgImgV addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.coverView);
    }];
    
    _statuImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag_using"]];
    [_bgImgV addSubview:_statuImgV];
    [_statuImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImgV);
        make.bottom.equalTo(FitPTScreen(-10));
    }];
    
     _deleteBtn = [[UIButton alloc]init];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete_red"] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImgV.right).offset(FitPTScreen(5));
        make.top.equalTo(self.bgImgV.top).offset(FitPTScreen(-5));
    }];
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(HLTemplateModel *)model{
    _model = model;
    _coverView.hidden = model.isUse;
    _titleLb.hidden = model.isUse;
    _statuImgV.hidden = !model.isUse;
    _deleteBtn.hidden = !model.selectImg;
    _titleLb.text = model.isDefault?[NSString stringWithFormat:@"自定义模版(750*600)"]:@"使用主题";
    if (model.selectImg) {
        _bgImgV.image = model.selectImg;
    }else{
        _bgImgV.image = [UIImage imageNamed:@"logo_default"];
    }
    if (model.imgUrl.length) {
        [_bgImgV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"logo_default"]];
    }
}

@end
