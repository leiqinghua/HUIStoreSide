//
//  HLOrderRemarkCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/30.
//

#import "HLOrderRemarkCell.h"

@interface HLOrderRemarkCell ()
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *contentLb;
@end

@implementation HLOrderRemarkCell

- (void)initSubView {
    [super initSubView];
    self.showLine = YES;
    [self showArrow:NO];
    _titleLb = [UILabel hl_regularWithColor:@"#666666" font:14];
    [self.bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    _contentLb = [UILabel hl_lableWithColor:@"#444444" font:14 bold:NO numbers:0];
    [self.bagView addSubview:_contentLb];
    [_contentLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.right).offset(FitPTScreen(5));
        make.top.equalTo(self.titleLb);
        make.width.lessThanOrEqualTo(FitPTScreen(250));
    }];
}

- (void)setTitle:(NSString *)title {
    _titleLb.text = title;
}

- (void)setContentAttr:(NSAttributedString *)contentAttr {
    _contentLb.attributedText = contentAttr;
}

@end
