//
//  HLPrinterButton.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/26.
//

#import "HLPrinterButton.h"

@interface HLPrinterButton()

@property (strong,nonatomic)UILabel * nameLable;

@property (strong,nonatomic)UIView * line;

@property (strong,nonatomic)UIImageView * cancel;

@property (copy,nonatomic)NSString * name;


@end

@implementation HLPrinterButton

-(instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        _name = name;
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    self.backgroundColor = UIColorFromRGB(0xFF8D26);
    self.layer.cornerRadius = FitPTScreen(15);
    
    _nameLable = [[UILabel alloc]init];
    _nameLable.text = _name;
    _nameLable.textColor = UIColor.whiteColor;
    _nameLable.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self addSubview:_nameLable];
   
    _line = [[UIView alloc]init];
    _line.backgroundColor = UIColor.whiteColor;
    [self addSubview:_line];
   
    _cancel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"close_x_white"]];
    [self addSubview:_cancel];
    
    //默认选中
    self.selected = YES;
}


-(void)layout{
    [_nameLable remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selected?FitPTScreen(11):FitPTScreen(20));
        make.top.equalTo(FitPTScreen(8));
        make.bottom.equalTo(FitPTScreen(-8));
        if (!self.selected) {
          make.right.equalTo(FitPTScreen(-20));
        }
    }];
    
    
    [_line remakeConstraints:^(MASConstraintMaker *make) {
        if (self.selected) {
       make.left.equalTo(self.nameLable.mas_right).offset(FitPTScreen(4));
            
        }
        make.centerY.equalTo(self.nameLable);
        make.width.equalTo(FitPTScreen(1));
        make.height.equalTo(FitPTScreen(15));
    }];
    
    [_cancel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_right).offset(FitPTScreen(5));
        make.centerY.equalTo(self.line);
        if (self.selected) {
           make.right.equalTo(self).offset(FitPTScreen(-11));
        }
    }];
    
}

-(void)addTarget:(NSObject *)target selecter:(SEL)selector{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
}

- (CGFloat)width{
    return self.bounds.size.width;
}


-(void)setSelected:(BOOL)selected{
    _selected = selected;
    _line.hidden = !_selected;
    _cancel.hidden = !_selected;
    self.backgroundColor = _selected?UIColorFromRGB(0xFF8D26):UIColorFromRGB(0xEDEDED);
    _nameLable.textColor = _selected?UIColor.whiteColor:UIColorFromRGB(0x989898);
    
    [self layout];
}
@end
