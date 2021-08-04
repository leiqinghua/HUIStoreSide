//
//  HLVoucherAddTwoImageCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/20.
//

#import "HLVoucherAddTwoImageCell.h"

@interface HLVoucherAddTwoImageCell ()

@property (nonatomic, strong) UIImageView *leftImgV;
@property (nonatomic, strong) UIImageView *rightImgV;

@property (nonatomic, strong) UIImageView *leftDelImgV;
@property (nonatomic, strong) UIImageView *rightDelImgV;

@end

@implementation HLVoucherAddTwoImageCell

- (void)initSubUI{
    [super initSubUI];
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    self.leftImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.leftImgV];
    self.leftImgV.image = [UIImage imageNamed:@"vouche_add_big_place"];
    self.leftImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImgV.clipsToBounds = YES;
    [self.leftImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(21));
        make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(14));
        make.width.equalTo(FitPTScreen(164));
        make.height.equalTo(FitPTScreen(94));
    }];
    [self.leftImgV hl_addTarget:self action:@selector(leftImageClick)];
    
    UILabel *leftLab = [[UILabel alloc] init];
    [self.contentView addSubview:leftLab];
    leftLab.text = @"身份证头像面";
    leftLab.textColor = UIColorFromRGB(0x8C8C8C);
    leftLab.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [leftLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftImgV);
        make.top.equalTo(self.leftImgV.bottom).offset(FitPTScreen(10));
    }];
    
    self.rightImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.rightImgV];
    self.rightImgV.image = [UIImage imageNamed:@"vouche_add_big_place"];
    self.rightImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.rightImgV.clipsToBounds = YES;
    [self.rightImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-21));
        make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(14));
        make.width.equalTo(FitPTScreen(164));
        make.height.equalTo(FitPTScreen(94));
    }];
    [self.rightImgV hl_addTarget:self action:@selector(rightImageClick)];
    
    UILabel *rightLab = [[UILabel alloc] init];
    [self.contentView addSubview:rightLab];
    rightLab.text = @"身份证国徽面";
    rightLab.textColor = UIColorFromRGB(0x8C8C8C);
    rightLab.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [rightLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImgV);
        make.top.equalTo(self.rightImgV.bottom).offset(FitPTScreen(10));
    }];
    
    _leftDelImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vouche_add_big_place"]];
    [self.contentView addSubview:_leftDelImgV];
    [_leftDelImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftDelImgV.top).offset(FitPTScreen(2)).with.priorityHigh();
        make.centerX.equalTo(_leftDelImgV.right).offset(FitPTScreen(-2)).with.priorityHigh();
        make.height.width.equalTo(FitPTScreen(19));
    }];
    
    _rightDelImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vouche_add_big_place"]];
    [self.contentView addSubview:_rightDelImgV];
    [_rightDelImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightDelImgV.top).offset(FitPTScreen(2)).with.priorityHigh();
        make.centerX.equalTo(_rightDelImgV.right).offset(FitPTScreen(-2)).with.priorityHigh();
        make.height.width.equalTo(FitPTScreen(19));
    }];
}

- (void)leftImageClick{
    if (self.delegate) {
        [self.delegate twoImageCell:self selectLeftImage:YES];
    }
}

- (void)rightImageClick{
    if (self.delegate) {
        [self.delegate twoImageCell:self selectLeftImage:NO];
    }
}

-(void)setBaseInfo:(HLVoucherTwoImageInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    HLVoucherTwoImageInfo *imgInfo = (HLVoucherTwoImageInfo *)baseInfo;
    if (imgInfo.leftImage) {
        _leftImgV.image = imgInfo.leftImage;
        _leftDelImgV.hidden = NO;
    }else{
        _leftDelImgV.hidden = imgInfo.leftImageUrl.length == 0;
        [_leftImgV sd_setImageWithURL:[NSURL URLWithString:imgInfo.leftImageUrl] placeholderImage:[UIImage imageNamed:@"vouche_add_big_place"]];
    }
    
    if (imgInfo.rightImage) {
        _rightImgV.image = imgInfo.rightImage;
        _rightDelImgV.hidden = NO;
    }else{
        _rightDelImgV.hidden = imgInfo.rightImageUrl.length == 0;
        [_rightImgV sd_setImageWithURL:[NSURL URLWithString:imgInfo.rightImageUrl] placeholderImage:[UIImage imageNamed:@"vouche_add_big_place"]];
    }
}

@end

@implementation HLVoucherTwoImageInfo

-(BOOL)checkParamsIsOk{
    return self.leftImageUrl.length && self.rightImageUrl.length;
}

@end
