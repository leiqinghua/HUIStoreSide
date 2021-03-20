//
//  HLLLTableViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/6/18.
//

#import "HLLLTableViewCell.h"

@interface HLLLTableViewCell ()

@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *contentLb;

@end

@implementation HLLLTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(self.contentView);
    }];
    
    _contentLb = [[UILabel alloc]init];
    _contentLb.textColor = UIColorFromRGB(0x333333);
    _contentLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_contentLb];
    [_contentLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(0.5);
    }];
}

- (void)titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont {
    _titleLb.textColor = titleColor;
    _titleLb.font = titleFont;
}

- (void)conColor:(UIColor *)conColor conFont:(UIFont *)coneFont {
    _contentLb.textColor = conColor;
    _contentLb.font = coneFont;
}

- (void)setTitle:(NSString *)title {
    _titleLb.text = title;
}

- (void)setContent:(NSString *)content {
    _contentLb.text = content;
}
@end
