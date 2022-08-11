//
//  HLVoucherMarketHead.m
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import "HLVoucherMarketHead.h"

@interface HLVoucherMarketHead ()

/// 生成按钮
@property (nonatomic, strong) UIButton *creatBtn;

@property (nonatomic, strong) UILabel *topTitleLab;

/// 状态视图
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIImageView *statusImgV;
@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UILabel *bigTipLab;
@property (nonatomic, strong) UILabel *smallTipLab;

@property (nonatomic, strong) UIImageView *passImgV;
@property (nonatomic, strong) UILabel *passLab;


@end

@implementation HLVoucherMarketHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    self.backgroundColor = UIColor.whiteColor;
    
    UIImageView *topImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voucher_creatmd_image"]];
    [self addSubview:topImgV];
    [topImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(0);
        make.height.equalTo(FitPTScreen(57));
    }];
    
    _topTitleLab = [[UILabel alloc] init];
    [topImgV addSubview:_topTitleLab];
    _topTitleLab.textColor = UIColorFromRGB(0x994E00);
    _topTitleLab.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [_topTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topImgV);
        make.right.lessThanOrEqualTo(FitPTScreen(-13));
        make.left.equalTo(FitPTScreen(52));
    }];
    
    UIImageView *bottomBgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voucher_creat_bottombg"]];
    [self addSubview:bottomBgImgV];
    [bottomBgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(FitPTScreen(0));
        make.bottom.equalTo(0);
        make.height.equalTo(FitPTScreen(133));
    }];
    
    _creatBtn = [[UIButton alloc] init];
    [self addSubview:_creatBtn];
    [_creatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _creatBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_creatBtn setBackgroundImage:[UIImage imageNamed:@"voucher_creat_button"] forState:UIControlStateNormal];
    [_creatBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-36));
        make.bottom.equalTo(FitPTScreen(-8));
        make.width.equalTo(FitPTScreen(130));
        make.height.equalTo(FitPTScreen(59));
    }];
    [_creatBtn addTarget:self action:@selector(creatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *bigTipLab = [[UILabel alloc] init];
    [self addSubview:bigTipLab];
    bigTipLab.text = @"生成买单牌";
    bigTipLab.textColor = UIColorFromRGB(0x501D00);
    bigTipLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(18)];
    [bigTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_creatBtn);
        make.top.equalTo(bottomBgImgV.top).offset(FitPTScreen(14));
    }];
    _bigTipLab = bigTipLab;
    
    UILabel *smallTipLab = [[UILabel alloc] init];
    [self addSubview:smallTipLab];
    smallTipLab.text = @"扫描买单牌  直接买单";
    smallTipLab.textColor = UIColorFromRGB(0x7D523A);
    smallTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [smallTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_creatBtn);
        make.top.equalTo(bigTipLab.bottom).offset(FitPTScreen(8));
    }];
    _smallTipLab = smallTipLab;
    
    /// 审核中，审核失败的状态view
    _statusView = [[UIView alloc] init];
    [self addSubview:_statusView];
    _statusView.layer.cornerRadius = FitPTScreen(9);
    _statusView.layer.masksToBounds = YES;
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.height.equalTo(FitPTScreen(18));
        make.centerY.equalTo(bottomBgImgV.top);
    }];
    
    _statusImgV = [[UIImageView alloc] init];
    [_statusView addSubview:_statusImgV];
    [_statusImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(5));
        make.centerY.equalTo(_statusView);
        make.height.width.equalTo(FitPTScreen(9));
    }];
    
    _statusLab = [[UILabel alloc] init];
    [_statusView addSubview:_statusLab];
    _statusLab.textColor = UIColorFromRGB(0x67A200);
    _statusLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_statusLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_statusView).with.priorityHigh();
        make.left.equalTo(FitPTScreen(17));
        make.right.equalTo(FitPTScreen(-6));
        make.height.equalTo(_statusView);
    }];
    
    /// 审核通过后的样式
    _passImgV = [[UIImageView alloc] init];
    [self addSubview:_passImgV];
    [_passImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_creatBtn.centerX);
        make.height.width.equalTo(FitPTScreen(36));
        make.top.equalTo(topImgV.bottom).offset(FitPTScreen(16));
    }];
    
    _passLab = [[UILabel alloc] init];
    [self addSubview:_passLab];
    _passLab.textColor = UIColorFromRGB(0x333333);
    _passLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_passLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_passImgV);
        make.top.equalTo(_passImgV.bottom).offset(FitPTScreen(12));
    }];
    
    _passLab.text = @"审核通过";
    _passImgV.image = [UIImage imageNamed:@"success_green"];
}

- (void)creatBtnClick{
    if (self.delegate) {
        [self.delegate marketHead:self addButtonClick:_creatBtn];
    }
}

/// 配置数据
- (void)configState:(NSInteger)state stateTitle:(NSString *)stateTitle{

    _bigTipLab.text = @"生成买单牌";
    _smallTipLab.text = @"扫描买单牌  直接买单";
    _topTitleLab.text = stateTitle;
    
    _passImgV.hidden = (state != 3);
    _passLab.hidden = (state != 3);
    
    _bigTipLab.hidden = (state == 3);
    _smallTipLab.hidden = (state == 3);
    
    switch (state) {
        case -1:
        case 0:
        {
            _statusView.hidden = YES;
            [_creatBtn setTitle:@"立即生成" forState:UIControlStateNormal];
        }
            break;
        case 1:
            _statusView.hidden = NO;
            _statusLab.text = @"审核中";
            _statusLab.textColor = UIColorFromRGB(0x67A200);
            _statusView.backgroundColor = UIColorFromRGB(0xEEF8DE);
            _statusImgV.image = [UIImage imageNamed:@"time_green"];
            [_creatBtn setTitle:@"耐心等待" forState:UIControlStateNormal];
            break;
        case 2:
            _statusView.hidden = NO;
            _statusLab.text = @"审核失败";
            _statusLab.textColor = UIColorFromRGB(0xFB4100);
            _statusView.backgroundColor = UIColorFromRGB(0xFFF3EC);
            _statusImgV.image = [UIImage imageNamed:@"tip_red"];
            [_creatBtn setTitle:@"修改信息" forState:UIControlStateNormal];
            break;
        case 3:
            _statusView.hidden = YES;
            [_creatBtn setTitle:@"绑定买单牌" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

@end
