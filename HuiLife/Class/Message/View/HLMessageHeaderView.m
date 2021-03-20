//
//  HLMessageHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/9/12.
//

#import "HLMessageHeaderView.h"

@interface HLMessageHeaderView()

@property(strong,nonatomic)UILabel * timeLable;

@end

@implementation HLMessageHeaderView

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView * bagview = [[UIView alloc]init];
    bagview.backgroundColor =  UIColor.whiteColor;
    [self addSubview:bagview];
    [bagview makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _timeLable = [[UILabel alloc]init];
    _timeLable.textColor = UIColorFromRGB(0x999999);
    _timeLable.text = @"2018-09-04";
    _timeLable.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [bagview addSubview:_timeLable];
    [_timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(bagview);
    }];
    
}

-(void)setTime:(NSString *)time{
    _time = time;
    _timeLable.text = time;
}

@end
