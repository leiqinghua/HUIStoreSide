//
//  HLHotToast.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/19.
//

#import "HLHotToast.h"

@interface HLHotToast ()

@property(nonatomic, strong) UIImageView *headView;

@property(nonatomic, strong) UILabel *tipLb;

@end

@implementation HLHotToast

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = FitPTScreen(15);
    self.layer.shadowColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:0.1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = FitPTScreen(10);
    self.layer.borderWidth = 0.5;
    self.layer.masksToBounds = NO;
    self.layer.borderColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor;
    
    _headView = [[UIImageView alloc]init];
    _headView.layer.cornerRadius = FitPTScreen(20)/2;
    [self addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(5));
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(FitPTScreen(20), FitPTScreen(20)));
    }];
    
    _tipLb = [UILabel hl_regularWithColor:@"#222222" font:12];
    [self addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self);
    }];
}

- (void)setModel:(HLHotToastModel *)model {
    _model = model;
     [_headView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    _tipLb.text = model.content;
}

@end


@implementation HLHotToastModel



@end
