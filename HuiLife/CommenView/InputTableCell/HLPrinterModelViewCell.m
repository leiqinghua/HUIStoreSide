//
//  HLPrinterModelViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/12.
//

#import "HLPrinterModelViewCell.h"

@interface HLPrinterModelViewCell ()

@property(nonatomic,strong)UIButton * autoBtn;

@property(nonatomic,strong)UIButton * SDBtn;

@end

@implementation HLPrinterModelViewCell

-(void)initSubUI{
    [super initSubUI];
    
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _autoBtn = [[UIButton alloc]init];
    _autoBtn.tag = 1000;
    [_autoBtn setTitle:@"自动打印" forState:UIControlStateNormal];
    [_autoBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [_autoBtn setTitleColor:UIColorFromRGB(0xFF8604) forState:UIControlStateSelected];
    _autoBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _autoBtn.layer.cornerRadius = FitPTScreen(14);
    _autoBtn.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    _autoBtn.layer.borderWidth = FitPTScreen(0.7);
    [self.contentView addSubview:_autoBtn];
    [_autoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTipLab);
        make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(15));
        make.width.equalTo(FitPTScreen(89));
        make.height.equalTo(FitPTScreen(27));
    }];
    
    _SDBtn = [[UIButton alloc]init];
    _SDBtn.tag = 1001;
    [_SDBtn setTitle:@"手动打印" forState:UIControlStateNormal];
    [_SDBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [_SDBtn setTitleColor:UIColorFromRGB(0xFF8604) forState:UIControlStateSelected];
    _SDBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _SDBtn.layer.cornerRadius = FitPTScreen(14);
    _SDBtn.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    _SDBtn.layer.borderWidth = FitPTScreen(0.7);
    [self.contentView addSubview:_SDBtn];
    [_SDBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.autoBtn.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.autoBtn);
        make.width.equalTo(FitPTScreen(89));
        make.height.equalTo(FitPTScreen(27));
    }];
    
    [_autoBtn addTarget:self action:@selector(printerClick:) forControlEvents:UIControlEventTouchUpInside];
    [_SDBtn addTarget:self action:@selector(printerClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)printerClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    sender.layer.borderColor = sender.selected?UIColorFromRGB(0xFF8604).CGColor:UIColorFromRGB(0xCDCDCD).CGColor;
    
    HLprinterModelInfo * model = (HLprinterModelInfo *) self.baseInfo;
    
    if (_autoBtn.selected && _SDBtn.selected) {
        model.modelType = 3;
    }else if (!_autoBtn.selected && !_SDBtn.selected){
        model.modelType = 4;
    }else if (!_autoBtn.selected && _SDBtn.selected){
        model.modelType = 2;
    }else{
        model.modelType = 1;
    }
    if ([self.delegate respondsToSelector:@selector(printeModelCell:autoClick:model:)]) {
        [self.delegate printeModelCell:self autoClick:sender.tag == 1000 model:(HLprinterModelInfo *)self.baseInfo];
    }
    
}

-(void)setBaseInfo:(HLprinterModelInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    _autoBtn.selected = baseInfo.modelType == 1 || baseInfo.modelType == 3;
    _SDBtn.selected = baseInfo.modelType == 2 || baseInfo.modelType == 3;
    _autoBtn.layer.borderColor = _autoBtn.selected?UIColorFromRGB(0xFF8604).CGColor:UIColorFromRGB(0xCDCDCD).CGColor;
    _SDBtn.layer.borderColor = _SDBtn.selected?UIColorFromRGB(0xFF8604).CGColor:UIColorFromRGB(0xCDCDCD).CGColor;
}


@end


@implementation HLprinterModelInfo


@end
