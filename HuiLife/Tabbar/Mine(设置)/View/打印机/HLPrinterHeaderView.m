//
//  HLPrinterHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//

#import "HLPrinterHeaderView.h"

@interface HLPrinterHeaderView(){
    UIButton * _autoBtn;//自动
    UIButton * _sdBtn;//手动
}

@end

@implementation HLPrinterHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    UIView * topline = [[UIView alloc]init];
    topline.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self addSubview:topline];
    [topline makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(FitPTScreen(1));
    }];
    
    self.backgroundColor = UIColorFromRGB(0xFAFAFA);
    UILabel * title = [[UILabel alloc]init];
    title.text = @"打印模式";
    title.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    title.textColor = UIColorFromRGB(0xABABAB);
    [self addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(FitPTScreenH(20));
    }];
    
    UIView *bagView = [[UIView alloc]init];
    bagView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(FitPTScreenH(45));
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bagView);
        make.top.equalTo(bagView);
        make.height.equalTo(FitPTScreen(1));
    }];
    
    UIButton * aotu = [[UIButton alloc]init];
    aotu.tag = 0;
    [aotu setTitle:@"自动打印" forState:UIControlStateNormal];
    [aotu setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [aotu setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
    
    aotu.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(12)];
    aotu.backgroundColor = UIColorFromRGB(0XEDEDED);
    aotu.layer.cornerRadius = FitPTScreenH(13);
    [bagView addSubview:aotu];
    _autoBtn = aotu;
    
    
    [aotu addTarget:self action:@selector(printerClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * SD = [[UIButton alloc]init];
    SD.tag = 1;
    [SD setTitle:@"手动打印" forState:UIControlStateNormal];
    [SD setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [SD setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
    SD.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(12)];
    SD.backgroundColor = UIColorFromRGB(0XEDEDED);
    SD.layer.cornerRadius = FitPTScreenH(13);
    [bagView addSubview:SD];
    [SD addTarget:self action:@selector(printerClick:) forControlEvents:UIControlEventTouchUpInside];
    _sdBtn = SD;
    
    [aotu makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(bagView);
        make.width.equalTo(FitPTScreen(80));
        make.height.equalTo(FitPTScreenH(27));
    }];
    
    [SD makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aotu.mas_right).offset(FitPTScreen(15));
        make.centerY.equalTo(bagView);
        make.width.equalTo(FitPTScreen(80));
        make.height.equalTo(FitPTScreenH(27));
    }];
}

- (void)printerClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    [self setBtnSelected:sender.selected button:sender];
    
    NSString * type = @"1";
    if (_autoBtn.selected && _sdBtn.selected) {
        type = @"3";
    }
    if (!_autoBtn.selected && !_sdBtn.selected) {
        type = @"4";
    }
    if (!_autoBtn.selected && _sdBtn.selected) {
        type = @"2";
    }
    
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectType:button:)]) {
        [self.delegate headerView:self didSelectType:type button:sender];
    }
}

- (void)setBtnSelected:(BOOL)selected button:(UIButton *)sender{
    sender.selected = selected;
    sender.backgroundColor = sender.selected?UIColorFromRGB(0xFF8D26):UIColorFromRGB(0xEDEDED);
}

-(void)setSelectType:(NSString *)selectType{
    _selectType = selectType;
    
    if (_selectType.integerValue == 1) {
        [self setBtnSelected:YES button:_autoBtn];
        [self setBtnSelected:NO button:_sdBtn];
        return;
    }
    
    if (_selectType.integerValue == 2) {
        [self setBtnSelected:NO button:_autoBtn];
        [self setBtnSelected:YES button:_sdBtn];
        return;
    }
    
    if (_selectType.integerValue == 3) {
        [self setBtnSelected:YES button:_autoBtn];
        [self setBtnSelected:YES button:_sdBtn];
        return;
    }
    
    if (_selectType.integerValue == 4) {
        [self setBtnSelected:NO button:_autoBtn];
        [self setBtnSelected:NO button:_sdBtn];
    }
}
@end
