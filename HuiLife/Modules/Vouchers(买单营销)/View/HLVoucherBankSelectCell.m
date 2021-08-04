//
//  HLVoucherBankSelectCell.m
//  HuiLife
//
//  Created by 王策 on 2019/9/2.
//

#import "HLVoucherBankSelectCell.h"

@interface HLVoucherBankSelectCell ()

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *selectLab;
@property (nonatomic, strong) UIImageView *selectImgV;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HLVoucherBankSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI {
    
    _selectLab = [[UILabel alloc] init];
    [self.contentView addSubview:_selectLab];
    _selectLab.text = @"选中";
    _selectLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _selectLab.textColor = UIColorFromRGB(0xFFA10D);
    _selectLab.layer.cornerRadius = FitPTScreen(4);
    _selectLab.layer.borderWidth = 0.8;
    _selectLab.textAlignment = NSTextAlignmentCenter;
    _selectLab.layer.borderColor = UIColorFromRGB(0xE6B362).CGColor;
    [_selectLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(FitPTScreen(-12));
        make.width.equalTo(FitPTScreen(40));
        make.height.equalTo(FitPTScreen(19));
    }];
    
    _selectImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_sector_2"]];
    [_selectLab addSubview:_selectImgV];
    [_selectImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(0);
        make.width.equalTo(FitPTScreen(10));
        make.height.equalTo(FitPTScreen(8));
    }];
    _selectImgV.hidden = YES;
    
    _nameLab = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLab];
    _nameLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _nameLab.textColor = UIColorFromRGB(0x555555);
    _nameLab.numberOfLines = 2;
    [_nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(FitPTScreen(21));
        make.right.lessThanOrEqualTo(_selectLab.left).offset(FitPTScreen(-6));
    }];
    
    _bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:_bottomLine];
    _bottomLine.backgroundColor = SeparatorColor;
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(0);
        make.height.equalTo(0.7);
        make.bottom.equalTo(0);
    }];
}

- (void)setBankInfo:(HLVoucherBankInfo *)bankInfo {
    _bankInfo = bankInfo;
    _nameLab.text = bankInfo.bank_name;
    _selectImgV.hidden = !bankInfo.select;
}

@end
