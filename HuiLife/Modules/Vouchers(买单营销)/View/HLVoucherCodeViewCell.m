//
//  HLVoucherCodeViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/4.
//

#import "HLVoucherCodeViewCell.h"

@interface HLVoucherCodeViewCell ()

@property (nonatomic, strong) UIImageView *codeImgV;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *downBtn;

@end

@implementation HLVoucherCodeViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _codeImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_codeImgV];
    _codeImgV.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _codeImgV.layer.shadowColor = UIColorFromRGB(0xffe2a6).CGColor;
    _codeImgV.layer.shadowRadius = FitPTScreen(5);
    _codeImgV.layer.shadowOpacity = 0.3;
    _codeImgV.layer.shadowOffset = CGSizeMake(0, 0);
    [_codeImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(13));
        make.left.equalTo(FitPTScreen(13));
        make.right.equalTo(FitPTScreen(-13));
        make.height.equalTo(FitPTScreen(72));
    }];
    
    _downBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_downBtn];
    [_downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [_downBtn setTitleColor:UIColorFromRGB(0xFF8200) forState:UIControlStateNormal];
    _downBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_downBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(FitPTScreen(27));
        make.right.equalTo(self.contentView.centerX);
        make.width.equalTo(FitPTScreen(40));
        make.top.equalTo(_codeImgV.bottom).offset(FitPTScreen(13));
    }];
    [_downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    _deleteBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:UIColorFromRGB(0xFF5543) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.equalTo(_downBtn);
        make.left.equalTo(self.contentView.centerX);
    }];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)downBtnClick{
    if (self.delegate) {
        [self.delegate codeViewCell:self downImgUrl:self.codeInfo.bigUrl];
    }
}

- (void)deleteBtnClick{
    if (self.delegate) {
        [self.delegate codeViewCell:self deleteCodeInfo:self.codeInfo];
    }
}

-(void)setCodeInfo:(HLVoucherCodeInfo *)codeInfo{
    _codeInfo = codeInfo;
    [_codeImgV sd_setImageWithURL:[NSURL URLWithString:codeInfo.simUrl] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
}

@end
