//
//  HLStoreBuyPayTypeCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import "HLStoreBuyPayTypeCell.h"

@interface HLStoreBuyPayTypeCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIImageView *selectImgV;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HLStoreBuyPayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageV];
    [_imageV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.width.height.equalTo(FitPTScreen(23));
        make.centerY.equalTo(self.contentView);
    }];
    
    _selectImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_selectImgV];
    [_selectImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-28));
        make.width.height.equalTo(FitPTScreen(17));
        make.centerY.equalTo(self.contentView);
    }];
    
    _tipLab = [[UILabel alloc] init];
    [self.contentView addSubview:_tipLab];
    _tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _tipLab.textColor = UIColorFromRGB(0x333333);
    [_tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_imageV.right).offset(FitPTScreen(8));
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = SeparatorColor;
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(0);
        make.height.equalTo(0.6);
        make.left.equalTo(FitPTScreen(50));
    }];
    _bottomLine = bottomLine;
}

-(void)setInfo:(HLStoreBuyTypeInfo *)info{
    _info = info;
    _tipLab.text = info.value;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:info.image]];
    _selectImgV.image = [UIImage imageNamed:info.select ? @"single_ring_normal" : @"circle_white_normal"];
}

-(void)setHideBottomLine:(BOOL)hideBottomLine{
    _hideBottomLine = hideBottomLine;
    _bottomLine.hidden = hideBottomLine;
}

@end
