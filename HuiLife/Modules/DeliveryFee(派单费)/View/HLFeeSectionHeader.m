//
//  HLFeeSectionHeader.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import "HLFeeSectionHeader.h"
#import "HLSwitch.h"
#import "HLFeeMainInfo.h"

@interface HLFeeSectionHeader ()

@property(nonatomic, strong) UIImageView *tipV;
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *descLb;
@property(nonatomic, strong) UILabel *subTitleLab;
@property(nonatomic, strong) HLSwitch *switchView;

@end

@implementation HLFeeSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    _tipV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip_money"]];
    [self addSubview:_tipV];
    [_tipV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(19));
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    _titleLb.text = @"HUI到家配送设置";
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipV.right).offset(FitPTScreen(6)).priorityLow();
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _subTitleLab = [[UILabel alloc]init];
    _subTitleLab.textColor = UIColorFromRGB(0x999999);
    _subTitleLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self addSubview:_subTitleLab];
    [_subTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLb.bottom).offset(FitPTScreen(6));
        make.left.equalTo(_titleLb);
    }];
    _subTitleLab.hidden = YES;
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor = UIColorFromRGB(0x999999);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLb.right).offset(FitPTScreen(9));
        make.centerY.equalTo(_titleLb);
    }];
    
    _switchView = [[HLSwitch alloc]init];
    [self addSubview:_switchView];
    [_switchView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(9));
        make.top.equalTo(FitPTScreen(17));
        make.size.equalTo(CGSizeMake(FitPTScreen(43), FitPTScreen(22)));
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchClick:)];
    [_switchView addGestureRecognizer:tap];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.equalTo(self);
        make.height.equalTo(FitPTScreen(0.7));
    }];
}

- (void)switchClick:(UITapGestureRecognizer *)sender {
    _switchView.select = !_switchView.select;
    _headerInfo.on = _switchView.select;
    _headerInfo.value = @(_headerInfo.on);
    if ([self.delegate respondsToSelector:@selector(header:headerInfo:)]) {
        [self.delegate header:self headerInfo:_headerInfo];
    }
}

- (void)setHeaderInfo:(HLFeeHeaderInfo *)headerInfo {
    _headerInfo = headerInfo;
    _tipV.hidden = headerInfo.hideTipV;
    _switchView.hidden = headerInfo.hideSwitch;
    _titleLb.text = headerInfo.title;
    _descLb.text = headerInfo.desc;
    _switchView.select = headerInfo.on;
    _descLb.hidden = headerInfo.desc.length == 0;
    _subTitleLab.hidden = headerInfo.subTitle.length == 0;
    _subTitleLab.text = headerInfo.subTitle;
    
    if (headerInfo.hideTipV) {
        [_titleLb updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(13));
        }];
    } else {
        [_titleLb updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tipV.right).offset(FitPTScreen(6)).priorityLow();
        }];
    }
    
    if (headerInfo.subTitle.length > 0) {
        [_titleLb updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(9));
        }];
    } else {
        [_titleLb updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(18));
        }];
    }
}
@end
