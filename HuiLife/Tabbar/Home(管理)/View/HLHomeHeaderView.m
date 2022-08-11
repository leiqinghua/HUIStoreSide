//
//  HLHomeHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import "HLHomeHeaderView.h"
#import "HLReviewModel.h"

@interface HLHomeHeaderView ()

@property(nonatomic,strong)UIImageView * headView;

@property(nonatomic,strong)UIImageView * bgView;

@property(nonatomic,strong)UILabel * nameLb;

@property(nonatomic,strong)UILabel * addressLb;

@property(nonatomic, strong) UIView *shView;//审核

@property(nonatomic, strong) UILabel *statuLb;

@property(nonatomic, strong) UIButton *statuBtn;

@property(nonatomic, strong) UIButton *optionBtn;

@end

@implementation HLHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
//    home_top_bg
    _bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    _bgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(self);
        make.height.equalTo(FitPTScreen(157) + HIGHT_NavBar_MARGIN);
    }];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [_bgView addSubview:effectView];
    [effectView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    _headView = [[UIImageView alloc]init];
    _headView.layer.cornerRadius = FitPTScreen(2);
    _headView.layer.masksToBounds = YES;
    _headView.image = [UIImage imageNamed:@"store_pic"];
    [_bgView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(27));
        make.top.equalTo(FitPTScreen(60) + HIGHT_NavBar_MARGIN);
        make.width.height.equalTo(FitPTScreen(60));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor = UIColor.whiteColor;
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(17)];
    _nameLb.text = @"";
    [_bgView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(11));
        make.top.equalTo(self.headView).offset(FitPTScreen(10));
    }];
    
    UIImageView * locateView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_locate"]];
    [_bgView addSubview:locateView];
    [locateView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(12));
    }];
    
    _addressLb = [[UILabel alloc]init];
    _addressLb.textColor = UIColor.whiteColor;
    _addressLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _addressLb.numberOfLines = 2;
    [_bgView addSubview:_addressLb];
    [_addressLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locateView.right).offset(FitPTScreen(5));
        make.centerY.equalTo(locateView);
        make.width.lessThanOrEqualTo(FitPTScreen(250));
    }];
    
    _shView = [[UIView alloc]init];
    [self addSubview:_shView];
    _shView.backgroundColor = UIColor.whiteColor;
    _shView.layer.cornerRadius = FitPTScreen(6);
    _shView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    _shView.layer.shadowOffset = CGSizeMake(0,6);
    _shView.layer.shadowOpacity = 1;
    _shView.layer.shadowRadius = FitPTScreen(16);
    _shView.layer.masksToBounds = false;
    _shView.clipsToBounds = false;
    [_shView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(-FitPTScreen(15));
        make.height.equalTo(FitPTScreen(40));
        make.bottom.equalTo(FitPTScreen(-10));
    }];
    
    _statuLb = [UILabel hl_regularWithColor:@"#333333" font:12];
    [_shView addSubview:_statuLb];
    [_statuLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.centerY.equalTo(self.shView);
    }];
    
    _statuBtn = [UIButton hl_regularWithImage:@"ask_grey2" select:NO];
    [_shView addSubview:_statuBtn];
    [_statuBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statuLb.right);
        make.centerY.equalTo(self.statuLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(32), FitPTScreen(20)));
    }];
    
    _optionBtn = [[UIButton alloc]init];
    [_shView addSubview:_optionBtn];
    [_optionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-8));
        make.centerY.equalTo(self.shView);
    }];
    [_optionBtn addTarget:self action:@selector(optionClick) forControlEvents:UIControlEventTouchUpInside];
    [_statuBtn addTarget:self action:@selector(statuClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)optionClick {
    if ([self.delegate respondsToSelector:@selector(headerView:statu:)]) {
        [self.delegate headerView:self statu:NO];
    }
}

- (void)statuClick {
    if ([self.delegate respondsToSelector:@selector(headerView:statu:)]) {
        [self.delegate headerView:self statu:YES];
    }
}

- (void)setReviewInfo:(HLReviewModel *)reviewInfo {
    _reviewInfo = reviewInfo;
    _statuLb.attributedText = reviewInfo.tipAttr;
    if (_reviewInfo.state == 10) { //审核中
        [_optionBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _optionBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [_optionBtn setTitle:reviewInfo.optionTitle forState:UIControlStateNormal];
        _optionBtn.userInteractionEnabled = NO;
        [_optionBtn remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-8));
            make.centerY.equalTo(self.shView);
        }];
    } else if (_reviewInfo.state == 15) { //成功
        [_optionBtn setTitleColor:UIColorFromRGB(0x23A820) forState:UIControlStateNormal];
        _optionBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [_optionBtn setTitle:reviewInfo.optionTitle forState:UIControlStateNormal];
        _optionBtn.layer.cornerRadius = FitPTScreen(2);
        _optionBtn.layer.borderColor = UIColorFromRGB(0x23A820).CGColor;
        _optionBtn.layer.borderWidth = 0.5;
        _optionBtn.userInteractionEnabled = NO;
        [_optionBtn remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-8));
            make.centerY.equalTo(self.shView);
            make.size.equalTo(CGSizeMake(FitPTScreen(46), FitPTScreen(19)));
        }];
    } else { //未提审，审核异常，审核失败
        [_optionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _optionBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [_optionBtn setTitle:reviewInfo.optionTitle forState:UIControlStateNormal];
        [_optionBtn setBackgroundImage:[UIImage imageNamed:@"bag_btn_jb"] forState:UIControlStateNormal];
        [_optionBtn remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-8));
            make.centerY.equalTo(self.shView);
            make.size.equalTo(CGSizeMake(FitPTScreen(66), FitPTScreen(24)));
        }];
    }
}

- (void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    
    _nameLb.text = dataDict[@"name"]?:@"";
    _addressLb.text = dataDict[@"address"]?:@"";
    NSString *pic = dataDict[@"pic"] ?: @"";
    [_headView sd_setImageWithURL:[NSURL URLWithString:dataDict[@"pic"]?:@""] placeholderImage: [UIImage imageNamed:@"logo_list_default"]];
    
    // 如果没有头像
    if(pic.length){
        [_bgView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage: [UIImage imageNamed:@"logo_list_default"]];
    }
}


/**
 "id": "33451",
 "name": "反一石锅拌饭",
 "pic": "http://aimg8.dlszyht.net.cn/user_store_info/768_384/1744237/4544/9086513_1543918134.png?t=9777",
 "address": "北京北京朝阳区北京市朝阳区农光东里11号楼259"
 */

@end
