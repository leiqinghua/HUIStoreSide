//
//  HLSelectShowViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/19.
//

#import "HLSelectShowViewCell.h"

@interface HLSelectShowViewCell()

@property(strong,nonatomic)UIImageView * img;
@end
@implementation HLSelectShowViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _title = [[UILabel alloc]init];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _title.text = @"";
    _title.textColor = UIColorFromRGB(0x999999);
    _title.backgroundColor = UIColor.whiteColor;
    _title.layer.cornerRadius = 4;
    _title.layer.borderWidth = 1;
    _title.numberOfLines = 0;
    [_title sizeToFit];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    [self addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lable_selct_tag"]];
    [self addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
    }];
    _img.hidden = YES;
   
}

-(void)setUIDefault:(BOOL)isDefault{
    if (isDefault) {
        _title.textColor = UIColorFromRGB(0x999999);
        _title.layer.borderColor =UIColorFromRGB(0xCDCDCD).CGColor;
    }else{
        _title.layer.borderColor =UIColorFromRGB(0xFF8604).CGColor;
        _title.textColor =UIColorFromRGB(0xFF8604);
    }
    _img.hidden = isDefault;
}


-(void)setModel:(HLFilterModel *)model{
    _model = model;
    _img.hidden = !model.selected;
    _title.text = model.title;
    if (model.selected) {
        _title.layer.borderColor =UIColorFromRGB(0xFF8604).CGColor;
        _title.textColor =UIColorFromRGB(0xFF8604);
    }else{
        _title.textColor = UIColorFromRGB(0x999999);
        _title.layer.borderColor =UIColorFromRGB(0xCDCDCD).CGColor;
    }
}
@end
