//
//  HLTextFieldViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/28.
//

#import "HLTextFieldViewCell.h"

@interface HLTextFieldViewCell()

@end

@implementation HLTextFieldViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _textfield = [[UITextField alloc]init];
    _textfield.textAlignment = NSTextAlignmentCenter;
    _textfield.font = [UIFont systemFontOfSize:FitPTScreenH(12)];
    _textfield.textColor = UIColorFromRGB(0xC5C5C5);
    _textfield.backgroundColor =UIColorFromRGB(0xF2F2F2);
    _textfield.layer.cornerRadius = 4;
    _textfield.clipsToBounds = YES;
    _textfield.placeholder = @"请输入会员号/手机号/用户名";
    self.clipsToBounds = YES;
    [self.contentView addSubview:_textfield];
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(272));
    }];
    
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
