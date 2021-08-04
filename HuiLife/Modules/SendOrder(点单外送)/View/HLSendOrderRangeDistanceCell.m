//
//  HLSendOrderRangeDistanceCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderRangeDistanceCell.h"

@interface HLSendOrderRangeDistanceCell ()

@property (nonatomic, strong) UILabel *showLab;

@end

@implementation HLSendOrderRangeDistanceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _showLab = [[UILabel alloc] init];
        [self.contentView addSubview:_showLab];
        _showLab.textColor = UIColorFromRGB(0x666666);
        _showLab.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
        _showLab.layer.borderWidth = 1;
        _showLab.layer.cornerRadius = FitPTScreen(5);
        _showLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
        _showLab.textAlignment = NSTextAlignmentCenter;
        [_showLab makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        
    }
    return self;
}

-(void)setInfo:(HLSendOrderRangeSuggestionInfo *)info{
    _info = info;
    _showLab.text = info.name;
    if (info.select) {
        _showLab.textColor = UIColorFromRGB(0xFF8604);
        _showLab.layer.borderColor = UIColorFromRGB(0xFF8604).CGColor;
    }else{
        _showLab.textColor = UIColorFromRGB(0x666666);
        _showLab.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    }
}

@end
