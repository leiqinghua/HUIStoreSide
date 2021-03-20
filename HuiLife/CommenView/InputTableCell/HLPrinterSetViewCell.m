//
//  HLPrinterSetViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/12.
//

#import "HLPrinterSetViewCell.h"

@interface HLPrinterSetViewCell ()

@property(nonatomic,strong)UILabel * textLb;

@property(nonatomic,strong)UIImageView * leftImgV;

@property(nonatomic,strong)UIImageView * rightImgV;

@property (strong,nonatomic)UIActivityIndicatorView * loadingIV;

@end

@implementation HLPrinterSetViewCell

-(void)initSubUI{
    [super initSubUI];
    
    _leftImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImgV];
    [_leftImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.centerY.equalTo(self.contentView);
    }];
    
    _rightImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:_rightImgV];
    [_rightImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.contentView);
    }];
    
    _textLb = [[UILabel alloc]init];
    _textLb.textColor =UIColorFromRGB(0x333333);
    _textLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_textLb];
    [_textLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.rightImgV.left).offset(FitPTScreen(-10));
    }];
}


-(void)setBaseInfo:(HLPrinterInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    _textLb.text = baseInfo.text;
    _leftImgV.image = baseInfo.leftImg;
    _rightImgV.image = baseInfo.rightImg;
    
    if (baseInfo.leftImg) {
        [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImgV.right).offset(FitPTScreen(10));
            make.centerY.equalTo(self.contentView);
        }];
    }else{
        [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(13));
            make.centerY.equalTo(self.contentView);
        }];
    }
    
    if (baseInfo.loading) {
        [self startLoading];
    }else{
        [self endLoading];
    }
}


- (void)startLoading{
    _rightImgV.hidden = YES;
    _loadingIV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_loadingIV];
    _loadingIV.alpha = 0;
    [_loadingIV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(30));
        make.width.equalTo(FitPTScreen(30));
    }];
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingIV.alpha = 1;
    } completion:^(BOOL finished) {
        [self.loadingIV startAnimating];
    }];
}


- (void)endLoading{
    _rightImgV.hidden = NO;
    [_loadingIV stopAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingIV.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingIV removeFromSuperview];
        self.loadingIV = nil;
    }];
}

@end


@implementation HLPrinterInfo


@end
