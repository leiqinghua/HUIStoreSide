//
//  HLPrinteHeader.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/12.
//

#import "HLPrinteHeader.h"


@interface HLPrinteHeader ()

@property(nonatomic,strong)UILabel * nameLb;

@property(nonatomic,strong)UIButton * addBtn;

@end

@implementation HLPrinteHeader


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}


-(void)initView{
    
    self.backgroundColor = UIColorFromRGB(0xF6F6F6);
    self.backgroundView = [UIView new];
    self.backgroundView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor = UIColorFromRGB(0x333333);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.centerY.equalTo(self);
    }];
    
    _addBtn = [[UIButton alloc]init];
    [_addBtn setImage:[UIImage imageNamed:@"add_printer"] forState:UIControlStateNormal];
    [self addSubview:_addBtn];
    [_addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self);
    }];
    [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setName:(NSString *)name{
    _name = name;
    _nameLb.text = _name;
    _addBtn.hidden = [_name isEqualToString:@"可配对设备"];
}

-(void)addClick{
    if ([self.delegate respondsToSelector:@selector(hlAddPrinteDevice)]) {
        [self.delegate hlAddPrinteDevice];
    }
}
@end
