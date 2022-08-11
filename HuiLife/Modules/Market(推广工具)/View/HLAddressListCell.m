//
//  HLAddressListCell.m
//  HuiLife
//
//  Created by 王策 on 2019/9/29.
//

#import "HLAddressListCell.h"

@interface HLAddressListCell ()

@property (strong, nonatomic) UIImageView *selectImgV;

@property (strong, nonatomic) UILabel *detailLab;

@property (strong, nonatomic) UILabel *allLab;

@end

@implementation HLAddressListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    _detailLab = [[UILabel alloc] init];
    [self.contentView addSubview:_detailLab];
    _detailLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    _detailLab.textColor = UIColorFromRGB(0x333333);
    [_detailLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(15));
        make.left.equalTo(FitPTScreen(13));
        make.right.lessThanOrEqualTo(FitPTScreen(-15));
    }];
    
    _allLab = [[UILabel alloc] init];
    [self.contentView addSubview:_allLab];
    _allLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _allLab.textColor = UIColorFromRGB(0x999999);
    [_allLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-13));
        make.left.equalTo(FitPTScreen(13));
        make.right.lessThanOrEqualTo(FitPTScreen(-15));
    }];
}

-(void)setPoiInfo:(HLAddressPOIInfo *)poiInfo{
    _poiInfo = poiInfo;
    _allLab.text = poiInfo.all;
    _detailLab.text = poiInfo.detail;
}

-(void)setKeyWord:(NSString *)keyWord{
    _keyWord = keyWord;
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:self.poiInfo.detail];
    if (keyWord.length > 0) {
        [mAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF9900) range:[self.poiInfo.detail rangeOfString:keyWord]];
    }
    _detailLab.attributedText = mAttr;
}

@end

