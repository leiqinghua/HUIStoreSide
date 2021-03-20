//
//  HLFilterReusableView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/2/27.
//

#import "HLFilterReusableView.h"

@interface HLFilterReusableView()

@property(nonatomic,strong)UILabel * titleLable;

@end

@implementation HLFilterReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = [UIColor hl_StringToColor:@"#333333"];
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [self addSubview:_titleLable];
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

-(void)setText:(NSString *)text{
    _text = text;
    _titleLable.text = _text;
}

@end
