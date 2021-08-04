//
//  HLPushHistoryHeadView.m
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import "HLPushHistoryHeadView.h"

@interface HLPushHistoryHeadView ()

@property (nonatomic, strong) UIImageView *goodImgV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *rangeLab;
@property (nonatomic, strong) UILabel *pushNumLab;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UIButton *pushButton;


@end

@implementation HLPushHistoryHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    _goodImgV = [[UIImageView alloc] init];
    [self addSubview:_goodImgV];
    _goodImgV.contentMode = UIViewContentModeScaleAspectFill;
    _goodImgV.clipsToBounds = YES;
    [_goodImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(FitPTScreen(12));
        make.width.height.equalTo(FitPTScreen(60));
    }];
    
    self.titleLab = [[UILabel alloc] init];
    [self addSubview:self.titleLab];
    self.titleLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    self.titleLab.textColor = UIColorFromRGB(0x000000);
    self.titleLab.numberOfLines = 2;
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodImgV.right).offset(FitPTScreen(12));
        make.centerY.equalTo(_goodImgV.centerY);
        make.right.equalTo(FitPTScreen(-12.5));
    }];
    
    self.descLab = [[UILabel alloc] init];
    [self addSubview:self.descLab];
    self.descLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.descLab.textColor = UIColorFromRGB(0x999999);
    self.descLab.numberOfLines = 0;
    self.descLab.preferredMaxLayoutWidth = FitPTScreen(340);
    [self.descLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodImgV);
        make.right.equalTo(self.titleLab);
        make.top.equalTo(self.goodImgV.bottom).offset(FitPTScreen(12));
    }];
    [self.descLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    
    UIView *seprator = [[UIView alloc] init];
    seprator.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self addSubview:seprator];
    [seprator makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(10));
        make.top.equalTo(self.descLab.bottom).offset(FitPTScreen(14));
    }];

    UIView *timeView = [[UIView alloc] init];
    [self addSubview:timeView];
    [timeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(50));
        make.top.equalTo(seprator.bottom);
    }];
    [self creatTimeViewSubViews:timeView];

    UIView *rangeView = [[UIView alloc] init];
    [self addSubview:rangeView];
    [rangeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(50));
        make.top.equalTo(timeView.bottom);
    }];
    [self creatRangeViewSubViews:rangeView];

    UIView *pushNumView = [[UIView alloc] init];
    [self addSubview:pushNumView];
    pushNumView.backgroundColor = UIColorFromRGB(0xFFF2E7);
    [pushNumView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rangeView.bottom).offset(FitPTScreen(0));
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(40));
    }];
    
    self.pushNumLab = [[UILabel alloc] init];
    [pushNumView addSubview:self.pushNumLab];
    self.pushNumLab.textColor = UIColorFromRGB(0xFF9900);
    self.pushNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.pushNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pushNumView);
        make.centerX.equalTo(pushNumView);
    }];

    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    bottomView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pushNumView.bottom).offset(FitPTScreen(0));
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(102));
        make.bottom.equalTo(0);
    }];
    
    UIButton *pushButton = [[UIButton alloc] init];
    [bottomView addSubview:pushButton];
    [pushButton setTitle:@"确定推送" forState:UIControlStateNormal];
    pushButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [pushButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [pushButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [pushButton addTarget:self action:@selector(pushButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.pushButton = pushButton;

    self.numLab = [[UILabel alloc] init];
    [bottomView addSubview:self.numLab];
    self.numLab.textColor = UIColorFromRGB(0x666666);
    self.numLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.numLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pushButton.bottom);
        make.centerX.equalTo(pushNumView);
    }];
}

- (void)pushButtonClick{
    if (self.pushBtnClick) {
        self.pushBtnClick();
    }
}

- (void)confgiDataModel:(HLPushHistoryModel *)model{
    [self.goodImgV sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    self.titleLab.text = model.title;
    self.descLab.text = model.describe;
    self.timeLab.text = model.times.firstObject[@"name"];
    self.rangeLab.text = model.range;
    self.pushNumLab.text = [NSString stringWithFormat:@"预计推送人数：%ld人",model.total];
    self.numLab.text = [NSString stringWithFormat:@"今日还剩 %ld 次推送机会",model.number];
    
    [self.pushButton setBackgroundImage:[UIImage imageNamed:model.number > 0 ? @"voucher_bottom_btn" : @"bag_btn_unable"] forState:UIControlStateNormal];
    [self.pushButton setBackgroundImage:[UIImage imageNamed:model.number > 0 ? @"voucher_bottom_btn" : @"bag_btn_unable"] forState:UIControlStateHighlighted];
    self.pushButton.userInteractionEnabled = model.number > 0;
    if(model.number == 0){
        self.pushButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, FitPTScreen(3), 0);
    }
    
    CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.frame = CGRectMake(0, 0, ScreenW, height);
}

- (void)creatRangeViewSubViews:(UIView *)superView{
    UILabel *tipLab = [[UILabel alloc] init];
    [superView addSubview:tipLab];
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.text = @"推送范围:";
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(superView);
    }];
    
//    UIImageView *arrowImgV = [[UIImageView alloc] init];
//    [superView addSubview:arrowImgV];
//    arrowImgV.image = [UIImage imageNamed:@"arrow_right_grey"];
//    [arrowImgV makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(FitPTScreen(-12));
//        make.centerY.equalTo(superView);
//    }];
    
    self.rangeLab = [[UILabel alloc] init];
    [superView addSubview:self.rangeLab];
    self.rangeLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.rangeLab.textColor = UIColorFromRGB(0x666666);
    self.rangeLab.textAlignment = NSTextAlignmentRight;
    [self.rangeLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(superView);
    }];
}

- (void)creatTimeViewSubViews:(UIView *)superView{
    UILabel *tipLab = [[UILabel alloc] init];
    [superView addSubview:tipLab];
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.text = @"推送时间:";
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(superView);
    }];
    
//    UIImageView *arrowImgV = [[UIImageView alloc] init];
//    [superView addSubview:arrowImgV];
//    arrowImgV.image = [UIImage imageNamed:@"arrow_right_grey"];
//    [arrowImgV makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(FitPTScreen(-12));
//        make.centerY.equalTo(superView);
//    }];
    
    self.timeLab = [[UILabel alloc] init];
    [superView addSubview:self.timeLab];
    self.timeLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.timeLab.textColor = UIColorFromRGB(0x666666);
    self.timeLab.textAlignment = NSTextAlignmentRight;
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(superView);
    }];
}

@end

//id    60528
//pid    1346191
//uid    1954147
//token    oKYT0A5sGCXy6Ky2dgys
//push_time    [0,0]
//push_id    978
