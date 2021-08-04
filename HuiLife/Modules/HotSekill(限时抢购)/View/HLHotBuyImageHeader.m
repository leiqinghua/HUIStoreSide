//
//  HLHotBuyImageHeader.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/3.
//

#import "HLHotBuyImageHeader.h"

@interface HLHotBuyImageHeader ()

@property (nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UILabel *subTitleLb;

@end

@implementation HLHotBuyImageHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xF6F6F6);
        
        _titleLab = [[UILabel alloc] init];
        [self addSubview:_titleLab];
        _titleLab.textColor = UIColorFromRGB(0x333333);
        _titleLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [_titleLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(14));
            make.centerY.equalTo(self.centerY);
        }];
        
        _subTitleLb = [[UILabel alloc] init];
        [self addSubview:_subTitleLb];
        _subTitleLb.textColor = UIColorFromRGB(0x979897);
        _subTitleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [_subTitleLb makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-12));
            make.centerY.equalTo(self.centerY);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _titleLab.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitleLb.text = subTitle;
}
@end


