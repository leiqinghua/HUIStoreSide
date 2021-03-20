//
//  HLSendOrderRangeHead.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderRangeHead.h"

@interface HLSendOrderRangeHead ()

@property (nonatomic, strong) UIButton *customBtn;
@property (nonatomic, strong) UIButton *suggestionBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;

@end

@implementation HLSendOrderRangeHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _customBtn = [[UIButton alloc] init];
    [self addSubview:_customBtn];
    [_customBtn setTitle:@"  自定义范围" forState:UIControlStateNormal];
    [_customBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _customBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_customBtn setImage:[UIImage imageNamed:@"circle_normal"] forState:UIControlStateNormal];
    [_customBtn setImage:[UIImage imageNamed:@"single_ring_normal"] forState:UIControlStateSelected];
    [_customBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(FitPTScreen(0));
        make.height.equalTo(FitPTScreen(50));
        make.width.equalTo(FitPTScreen(105));
    }];
    [_customBtn addTarget:self action:@selector(customBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _suggestionBtn = [[UIButton alloc] init];
    [self addSubview:_suggestionBtn];
    [_suggestionBtn setTitle:@"  推荐范围" forState:UIControlStateNormal];
    [_suggestionBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _suggestionBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_suggestionBtn setImage:[UIImage imageNamed:@"circle_normal"] forState:UIControlStateNormal];
    [_suggestionBtn setImage:[UIImage imageNamed:@"single_ring_normal"] forState:UIControlStateSelected];
    [_suggestionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_customBtn.left);
        make.height.equalTo(FitPTScreen(50));
        make.width.equalTo(FitPTScreen(95));
    }];
    [_suggestionBtn addTarget:self action:@selector(suggestionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLab = [[UILabel alloc] init];
    [self addSubview:_titleLab];
    _titleLab.text = @"配送范围";
    _titleLab.textColor = UIColorFromRGB(0x333333);
    _titleLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(22));
        make.left.equalTo(FitPTScreen(15));
    }];
    
    _subTitleLab = [[UILabel alloc] init];
    [self addSubview:_subTitleLab];
    _subTitleLab.text = @"距离店铺多远内支持配送";
    _subTitleLab.textColor = UIColorFromRGB(0x999999);
    _subTitleLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_subTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.bottom).offset(FitPTScreen(10));
        make.left.equalTo(_titleLab);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.height.equalTo(FitPTScreen(1));
        make.bottom.equalTo(0);
        make.right.equalTo(FitPTScreen(-13));
    }];
}

- (void)customBtnClick:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    [self configIsCustom:YES];
}

- (void)suggestionBtnClick:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    [self configIsCustom:NO];
}


/// 配置是否custom
- (void)configIsCustom:(BOOL)isCustom{
    _customBtn.selected = isCustom;
    _suggestionBtn.selected = !isCustom;
    if (self.delegate) {
        [self.delegate rangeHead:self isCustom:isCustom];
    }
}

/// 配置数据
- (void)configDataWithRangeInfo:(HLSendOrderRangeInfo *)rangeInfo{
    _titleLab.text = rangeInfo.title;
    _subTitleLab.text = rangeInfo.subTitle;
    // 判断此时选择的是什么
    [self configIsCustom:[rangeInfo isCustumRange]];
}

@end
