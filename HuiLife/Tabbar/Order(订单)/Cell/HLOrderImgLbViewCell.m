//
//  HLDeskNumViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/1/13.
//

#import "HLOrderImgLbViewCell.h"

@interface HLOrderImgLbViewCell ()

@property(nonatomic, strong) UIImageView *tipImgV;

@property(nonatomic, strong) UILabel *tipLb;

@end

@implementation HLOrderImgLbViewCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:NO];
    self.showLine = YES;
    _tipImgV = [[UIImageView alloc]init];
    _tipImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.bagView addSubview:_tipImgV];
    [_tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(15));
        make.width.height.equalTo(FitPTScreen(13));
    }];
    
    _tipLb = [UILabel hl_regularWithColor:@"#555555" font:14];
    _tipLb.text = @"";
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImgV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.tipImgV);
        make.width.lessThanOrEqualTo(FitPTScreen(240));
    }];
}

- (void)setTipImgUrl:(NSString *)tipImgUrl {
    [_tipImgV sd_setImageWithURL:[NSURL URLWithString:tipImgUrl]];
}

- (void)setTip:(NSString *)tip {
    _tip = tip;
    _tipLb.text = tip;
}

- (void)controlSubViewsHidden:(BOOL)hidden{
    _tipLb.hidden = _tipImgV.hidden = hidden;
}

@end
