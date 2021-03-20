//
//  HLHotelCalanderHeader.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/22.
//

#import "HLHotelCalanderHeader.h"

@interface HLHotelCalanderHeader ()

@property(strong,nonatomic)UILabel * titleLable;

@end

@implementation HLHotelCalanderHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
       [self initSubView];
    }
    return self;
}

-(void)initSubView{
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = UIColor.whiteColor;
        view;
    });
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = [UIColor hl_StringToColor:@"373828"];
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    [self addSubview:_titleLable];
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor hl_StringToColor:@"#DDDDDD"];
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self);
        make.height.equalTo(FitPTScreenH(1));
    }];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLable.text = title;
}

@end
