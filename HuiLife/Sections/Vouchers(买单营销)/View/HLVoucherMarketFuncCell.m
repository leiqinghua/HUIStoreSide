//
//  HLVoucherMarketFuncCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import "HLVoucherMarketFuncCell.h"

@interface HLVoucherMarketFuncCell ()

@property (nonatomic, strong) UIImageView *tipImgV;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *descLab;

@end

@implementation HLVoucherMarketFuncCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _tipImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_tipImgV];
    _tipImgV.contentMode = UIViewContentModeScaleAspectFit;
    [_tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.left).offset(FitPTScreen(20));
        make.centerY.equalTo(self.contentView.top).offset(FitPTScreen(30));
        make.width.height.equalTo(FitPTScreen(15));
    }];
    
    _titleLab = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLab];
    _titleLab.textColor = UIColorFromRGB(0x333333);
    _titleLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tipImgV);
        make.left.equalTo(FitPTScreen(32));
    }];
    
    _descLab = [[UILabel alloc] init];
    [self.contentView addSubview:_descLab];
    _descLab.textColor = UIColorFromRGB(0x999999);
    _descLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_descLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.bottom).offset(FitPTScreen(7));
        make.left.equalTo(_titleLab);
    }];
    
    _addBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_addBtn];
    [_addBtn setTitleColor:UIColorFromRGB(0xFF8E16) forState:UIControlStateNormal];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _addBtn.layer.cornerRadius = FitPTScreen(5);
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.borderWidth = FitPTScreen(0.6);
    _addBtn.layer.borderColor = UIColorFromRGB(0xFF8E16).CGColor;
    [_addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-22));
        make.bottom.equalTo(FitPTScreen(-15));
        make.width.equalTo(FitPTScreen(79));
        make.height.equalTo(FitPTScreen(31));
    }];
    _addBtn.userInteractionEnabled = NO;
    
    UIView *bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = SeparatorColor;
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(25));
        make.height.equalTo(0.7);
        make.right.bottom.equalTo(0);
    }];
}

-(void)setActivityInfo:(HLVoucherMarketActivityInfo *)activityInfo{
    _activityInfo = activityInfo;
    
    [_tipImgV sd_setImageWithURL:[NSURL URLWithString:activityInfo.pic]];
    _titleLab.text = activityInfo.title;
    _descLab.text = activityInfo.desc;
    [_addBtn setTitle:activityInfo.clickTitle forState:UIControlStateNormal];
}

@end
