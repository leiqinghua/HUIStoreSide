//
//  HLHomeCollectionCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import "HLHomeCollectionCell.h"

@interface HLHomeCollectionCell ()


@property(strong,nonatomic)UILabel * titleLb;

@end

@implementation HLHomeCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _topImageV = [[UIImageView alloc]init];
    _topImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_topImageV];
    [_topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(FitPTScreen(23));
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(FitPTScreen(58));
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    _titleLb.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageV.bottom).offset(FitPTScreen(10));
        make.centerX.equalTo(self.contentView);
    }];
    
}

-(void)setItemData:(HLHomeModel *)itemData{
    _itemData = itemData;
    _titleLb.text = itemData.name;
    [_topImageV sd_setImageWithURL:[NSURL URLWithString:itemData.background]];
}
@end
