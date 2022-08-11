//
//  HLMineHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/21.
//

#import "HLMineHeaderView.h"

@interface HLMineHeaderView()


@property (strong,nonatomic)UIImageView * bagView;

@property(strong,nonatomic)UILabel *nameLb;
//管理员或店长
@property(strong,nonatomic)UIImageView *userTypeImgV;

@property(strong,nonatomic)UILabel *userTypeLb;

@property (strong,nonatomic)UILabel * storeNameLb;
//工号
@property (strong,nonatomic)UILabel * numLable;
//地址
@property (strong,nonatomic)UILabel * addressLb;

@property (strong,nonatomic)UIImageView * addressImgV;

@property (strong,nonatomic)UIView * midView;

// 有效期展示
@property (nonatomic, strong) UIButton *timeShowBtn;

@end

@implementation HLMineHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _bagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_header_bg"]];
    [self addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self);
        make.height.equalTo(FitPTScreen(176) + HIGHT_NavBar_MARGIN);
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.text = @"";
    _nameLb.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLb.textColor = UIColorFromRGB(0xFFFFFF);
    _nameLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(16)];
    _nameLb.lineBreakMode = NSLineBreakByTruncatingTail;
    [_bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bagView.centerX).offset(FitPTScreen(-35));
        make.top.equalTo(FitPTScreen(60)+HIGHT_NavBar_MARGIN);
    }];
    
    _userTypeImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_userType"]];
    [_bagView addSubview:_userTypeImgV];
    [_userTypeImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.right).offset(FitPTScreen(11));
        make.bottom.equalTo(self.nameLb);
    }];
    
    _userTypeLb = [[UILabel alloc]init];
    _userTypeLb.text = @"";
    _userTypeLb.textColor = UIColorFromRGB(0xFFFFFF);
    _userTypeLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _userTypeLb.lineBreakMode = NSLineBreakByTruncatingTail;
    [_bagView addSubview:_userTypeLb];
    [_userTypeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.right).offset(FitPTScreen(22));
        make.centerY.equalTo(self.userTypeImgV);
    }];
    
    _midView = [[UIView alloc]init];
    [_bagView addSubview:_midView];
    [_midView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bagView);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(20));
    }];
    
    _storeNameLb = [[UILabel alloc]init];
    _storeNameLb.text = @"";
    _storeNameLb.textColor = [UIColor whiteColor];
    _storeNameLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_midView addSubview:_storeNameLb];
    [_storeNameLb remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.midView);
    }];
    
    _numLable = [[UILabel alloc]init];
    _numLable.text = @"";
    _numLable.textColor = [UIColor whiteColor];
    _numLable.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    [_midView addSubview:_numLable];
    [_numLable remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.midView);
        make.left.equalTo(self.storeNameLb.right).offset(FitPTScreen(11));
    }];
    
    _addressLb = [[UILabel alloc]init];
    _addressLb.text= @"";
    _addressLb.textColor = [UIColor whiteColor];
    _addressLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _addressLb.textAlignment = NSTextAlignmentCenter;
    [_bagView addSubview:_addressLb];
    [_addressLb remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bagView);
        make.top.equalTo(self.midView.bottom).offset(FitPTScreen(17));
        make.width.lessThanOrEqualTo(FitPTScreen(300));
    }];
    
    
    _addressImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_address"]];
    [self.bagView addSubview:_addressImgV];
    [_addressImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressLb.left).offset(FitPTScreen(-5));
        make.centerY.equalTo(self.addressLb);
    }];
    
    _timeShowBtn = [[UIButton alloc] init];
    [self.bagView addSubview:_timeShowBtn];
    [_timeShowBtn setTitleColor:UIColorFromRGB(0xFF7E00) forState:UIControlStateNormal];
    _timeShowBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _timeShowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, FitPTScreen(2), 0);
    [_timeShowBtn setBackgroundImage:[UIImage imageNamed:@"user_time_head"] forState:UIControlStateNormal];
    [_timeShowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_userTypeLb.top).offset(FitPTScreen(-1));
        make.left.equalTo(_nameLb.right).offset(FitPTScreen(-5));
        make.width.equalTo(FitPTScreen(81));
        make.height.equalTo(FitPTScreen(28));
    }];
    _timeShowBtn.hidden = YES;
}

- (void)updateData {
    HLAccount * account = [HLAccount shared];;
    NSInteger type = account.role;
    switch (type) {
        case 1:
            _userTypeLb.text = @" 管理员";
            break;
        case 2:
            _userTypeLb.text = @" 店长";
            break;
        default:
            _userTypeLb.text = @" 员工";
            break;
    }
    
    _nameLb.text = account.name;
    _storeNameLb.text = ([account.store_name isKindOfClass:[NSString class]]) ? account.store_name : @"";
    if (account.user_name.length) {
        _numLable.text = [NSString stringWithFormat:@"工号：%@",account.user_name];
    }
    _addressLb.text = [NSString stringWithFormat:@"门店地址：%@",account.store_address];
}

- (void)configUserTimeTipString:(NSString *)timeTipString{
    [_timeShowBtn setTitle:timeTipString forState:UIControlStateNormal];
    _timeShowBtn.hidden = timeTipString.length == 0;
}

-(void)completeBtnClick:(UIButton *)sender{
    
}
@end
