//
//  HLMatterItemViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import "HLMatterItemViewCell.h"

@interface HLMatterItemViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HLMatterItemViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = FitPTScreen(7);
        _imageView.backgroundColor = UIColorFromRGB(0xF6F6F6);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setItemInfo:(HLMatterMainItemInfo *)itemInfo {
    _itemInfo = itemInfo;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:itemInfo.smallImgUrl]];
}

@end
