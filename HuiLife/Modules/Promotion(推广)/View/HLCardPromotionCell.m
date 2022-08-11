//
//  HLCardPromotionCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import "HLCardPromotionCell.h"
#import "HLSwitch.h"

@interface HLCardPromotionCell ()

@property(nonatomic,strong)UIImageView * tipImgV;

@property(nonatomic,strong)UILabel * nameLb;

@property(nonatomic,strong)UILabel * descLb;

@property(nonatomic,strong)UIView * bagView;

//@property(nonatomic,strong)HLSwitch * switchV;
@end

@implementation HLCardPromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
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
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(6), FitPTScreen(10), FitPTScreen(6), FitPTScreen(10)));
    }];
    
    _tipImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [_bagView addSubview:_tipImgV];
    [_tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.centerY.equalTo(self.bagView);
        make.width.height.equalTo(FitPTScreen(18));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor =UIColorFromRGB(0x333333);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _nameLb.text = @"买单推广";
    [_bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImgV.right).offset(FitPTScreen(8));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor =UIColorFromRGB(0xFF9F16);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _descLb.text = @"设置买单HUI卡推广";
    [_bagView addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(10));
    }];
    
//    _switchV = [[HLSwitch alloc]init];
//    [self.bagView addSubview:_switchV];
//    [_switchV makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(FitPTScreen(-18));
//        make.centerY.equalTo(self.bagView);
//        make.width.equalTo(FitPTScreen(43));
//        make.height.equalTo(FitPTScreen(22));
//    }];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    [_switchV addGestureRecognizer:tap];
    
    
    UIImageView * arrowV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_oriange"]];
    [_bagView addSubview:arrowV];
    [arrowV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLb.right).offset(FitPTScreen(12));
        make.centerY.equalTo(self.descLb);
    }];
}

-(void)setModel:(HLCardPromotion *)model{
    _model = model;
    [_tipImgV sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@""]];
    _nameLb.text = model.name;
    _descLb.text = model.desc;
}

-(void)tapClick:(UITapGestureRecognizer *)sender{
    HLSwitch * switchV = (HLSwitch *)sender.view;
    switchV.select = !switchV.select;
}
@end


@implementation HLCardPromotion



@end
