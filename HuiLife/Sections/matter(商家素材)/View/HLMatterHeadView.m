//
//  HLMatterHeadView.m
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import "HLMatterHeadView.h"

@interface HLMatterHeadView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIImageView *arrowImgV;
@property (nonatomic, strong) UIImageView *codeImgV;

@end

@implementation HLMatterHeadView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self creatSubUI];
        
        //
        self.backgroundColor = UIColor.whiteColor;
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowOpacity = 0.10;
        self.layer.shadowRadius = 7;
        self.layer.cornerRadius = 7;
    }
    return self;
}

- (void)creatSubUI {
    
    _titleLab = [[UILabel alloc] init];
    [self addSubview:_titleLab];
    _titleLab.textColor = UIColorFromRGB(0x333333);
    _titleLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    [_titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.centerY.equalTo(self);
    }];
    
    _descLab = [[UILabel alloc] init];
    [self addSubview:_descLab];
    _descLab.textColor = UIColorFromRGB(0x999999);
    _descLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_descLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self);
    }];
    
    _arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [self addSubview:_arrowImgV];
    [_arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(FitPTScreen(-18));
        make.width.equalTo(FitPTScreen(5));
        make.height.equalTo(FitPTScreen(9));
    }];
    
    _codeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"matter_code"]];
    [self addSubview:_codeImgV];
    [_codeImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_arrowImgV.left).offset(FitPTScreen(-11));
        make.width.height.equalTo(FitPTScreen(23));
    }];
    
    _titleLab.text = @"二维码";
    _descLab.text = @"店铺小程序二维码";
}

- (void)configTitle:(NSString *)title desc:(NSString *)desc codeUrl:(NSString *)codeUrl {
    _titleLab.text = title;
    _descLab.text = desc;
    [_codeImgV sd_setImageWithURL:[NSURL URLWithString:codeUrl] placeholderImage:[UIImage imageNamed:@"matter_code"]];
}

@end
