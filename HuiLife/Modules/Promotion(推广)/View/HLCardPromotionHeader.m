//
//  HLCardPromotionHeader.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import "HLCardPromotionHeader.h"

@interface HLCardPromotionHeader ()

@property(nonatomic,strong)UILabel * nameLb;

@property(nonatomic,strong)UILabel * descLb;

@property(nonatomic,strong)UIImageView * bgImV ;
@end

@implementation HLCardPromotionHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = UIColor.clearColor;
    
    _bgImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self addSubview:_bgImV];
    [_bgImV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(5), 0, FitPTScreen(5)));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor =UIColorFromRGB(0xFA7C55);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    _nameLb.text = @"HUI卡推广";
    [_bgImV addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(17));
        make.top.equalTo(FitPTScreen(32));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor =UIColorFromRGB(0x666666);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _descLb.text = @"您将推广到1.8万HUI卡会员";
    [_bgImV addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(17));
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(10));
    }];
    
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    _nameLb.text = dict[@"name"];
    _descLb.text = dict[@"desc"];
    [_bgImV sd_setImageWithURL:[NSURL URLWithString:dict[@"icon"]] placeholderImage:[UIImage imageNamed:@""]];
    
}
@end
