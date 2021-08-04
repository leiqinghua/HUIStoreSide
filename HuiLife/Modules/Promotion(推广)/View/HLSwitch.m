//
//  HLSwitch.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import "HLSwitch.h"

@interface HLSwitch ()

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)UIView * buttonV;
@end

@implementation HLSwitch

- (instancetype)init{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    _bagView.layer.cornerRadius = FitPTScreen(11);
    _bagView.layer.borderColor = UIColorFromRGB(0xD7D7D7).CGColor;
    _bagView.layer.borderWidth = FitPTScreen(1);
    [self addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _buttonV = [[UIView alloc]init];
    _buttonV.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _buttonV.layer.cornerRadius = FitPTScreen(10);
    [_bagView addSubview:_buttonV];
    [_buttonV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_bagView);
        make.width.height.equalTo(FitPTScreen(20));
    }];
    
    _buttonV.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    _buttonV.layer.shadowOffset = CGSizeMake(0,1);
    _buttonV.layer.shadowOpacity = 1;
    _buttonV.layer.shadowRadius = FitPTScreen(8);
}

- (void)setSelect:(BOOL)select{
    _select = select;
    _bagView.backgroundColor = select?UIColorFromRGB(0xFFFFFF):UIColorFromRGB(0xF8F8F8);
    _bagView.layer.borderColor =select?UIColorFromRGB(0xFF9A16).CGColor:UIColorFromRGB(0xD7D7D7).CGColor;
    _buttonV.backgroundColor = select?UIColorFromRGB(0xFF9A16):UIColorFromRGB(0xFFFFFF);
    
    if (select) {
        [_buttonV remakeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(self.bagView);
            make.width.height.equalTo(FitPTScreen(20));
        }];
    }else{
        [_buttonV remakeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.bagView);
            make.width.height.equalTo(FitPTScreen(20));
        }];
    }
}
@end
