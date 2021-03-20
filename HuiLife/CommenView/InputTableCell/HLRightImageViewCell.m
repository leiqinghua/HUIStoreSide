//
//  HLRightImageViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/4.
//

#import "HLRightImageViewCell.h"

@interface HLRightImageViewCell ()

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UIImageView *delImgV;

@property (nonatomic, strong) UILabel *countLab;

@end

@implementation HLRightImageViewCell

- (void)initSubUI{
    
    [super initSubUI];
    
    _imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageV];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    [_imageV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(FitPTScreen(-27));
        make.height.width.equalTo(FitPTScreen(78));
    }];
    
    _delImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete_red"]];
    [self.contentView addSubview:_delImgV];
    [_delImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imageV.top).offset(FitPTScreen(2));
        make.centerX.equalTo(_imageV.right).offset(FitPTScreen(-2));
        make.height.width.equalTo(FitPTScreen(19));
    }];
    
    _countLab = [[UILabel alloc] init];
    [_imageV addSubview:_countLab];
    _countLab.textColor = UIColor.whiteColor;
    _countLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _countLab.textAlignment = NSTextAlignmentCenter;
    _countLab.layer.cornerRadius = FitPTScreen(7.5);
    _countLab.layer.masksToBounds = YES;
    _countLab.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    [_countLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-3));
        make.bottom.equalTo(FitPTScreen(-5));
        make.width.equalTo(FitPTScreen(26));
        make.height.equalTo(FitPTScreen(15));
    }];
    _countLab.hidden = YES;
}

-(void)setBaseInfo:(HLBaseTypeInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    HLRightImageTypeInfo *imgInfo = (HLRightImageTypeInfo *)baseInfo;
    if (imgInfo.selectImage) {
        _imageV.image = imgInfo.selectImage;
        _delImgV.hidden = NO;
        _countLab.hidden = imgInfo.count == 0;
        _countLab.text = [NSString stringWithFormat:@"%ld",imgInfo.count];
    }else{
        _countLab.hidden = YES;
        _delImgV.hidden = imgInfo.imageUrl.length == 0;
        [_imageV sd_setImageWithURL:[NSURL URLWithString:imgInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"voucher_img_upload"]];
    }
}

@end

@implementation HLRightImageTypeInfo

-(BOOL)checkParamsIsOk{
    
    if (self.imageUrl.length > 0) {
        return YES;
    }
    
    if(self.mParams.count > 0){
        return YES;
    }
    
    return NO;
}

@end
