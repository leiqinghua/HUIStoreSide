//
//  HLFunctionViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/30.
//

#import "HLFunctionViewCell.h"


@interface HLFunctionViewCell ()

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)UIImageView * leftImgV;

@property(nonatomic,strong)UILabel * titleLb;

@property(nonatomic,strong)UILabel * subLb;

@property(nonatomic,strong)UIImageView * arrow;

@end

@implementation HLFunctionViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.shadowColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:0.42].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(0,1);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(26);
    _bagView.layer.cornerRadius = FitPTScreen(5.5);
    _bagView.layer.masksToBounds = false;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(6), FitPTScreen(13), FitPTScreen(6), FitPTScreen(13)));
    }];
    
    _leftImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [_bagView addSubview:_leftImgV];
    _leftImgV.contentMode = UIViewContentModeScaleAspectFit;
    [_leftImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(7));
        make.centerY.equalTo(_bagView);
        make.width.equalTo(FitPTScreen(55));
        make.height.equalTo(FitPTScreen(55));
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    [_bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgV.right).offset(FitPTScreen(4));
        make.top.equalTo(FitPTScreen(22));
    }];
    
    _subLb = [[UILabel alloc]init];
    _subLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _subLb.textColor = UIColorFromRGB(0x666666);
    [_bagView addSubview:_subLb];
    [_subLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(10));
        make.width.lessThanOrEqualTo(FitPTScreen(250));
    }];
    
    _arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [_bagView addSubview:_arrow];
    [_arrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.centerY.equalTo(_bagView);
    }];
}

-(void)setModel:(HLFunctionModel *)model{
    _model = model;
    [_leftImgV sd_setImageWithURL:[NSURL URLWithString:model.backgroundImg] placeholderImage:[UIImage imageNamed:@""]];
    _titleLb.text = model.title;
    _subLb.text = model.content;
}

@end
