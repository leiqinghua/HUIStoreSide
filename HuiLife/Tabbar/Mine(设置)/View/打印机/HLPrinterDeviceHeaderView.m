//
//  HLPrinterDeviceHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//

#import "HLPrinterDeviceHeaderView.h"

@interface HLPrinterDeviceHeaderView (){
    UIView * _topline;
    
    UIView * _bottomline;
}

@property (assign,nonatomic)BOOL show;

@property (strong,nonatomic)NSString *title;
@end

@implementation HLPrinterDeviceHeaderView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title showAdd:(BOOL)show{
    if (self = [super initWithFrame:frame]) {
        _show = show;
        _title = title;
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    self.backgroundColor = UIColorFromRGB(0xFAFAFA);
    UILabel * titleLable = [[UILabel alloc]init];
    titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    titleLable.textColor = UIColorFromRGB(0xABABAB);
    titleLable.text = _title;
    [self addSubview:titleLable];
    [titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(self);
    }];
    
    UIButton * addBtn = [[UIButton alloc]init];
    [addBtn setImage:[UIImage imageNamed:@"add_square_oriange"] forState:UIControlStateNormal];
    [addBtn setTitle:@"  添加打印机" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(12)];
    [self addSubview:addBtn];
    addBtn.hidden = !_show;
    [addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self);
        make.width.equalTo(FitPTScreen(85));
        make.height.equalTo(FitPTScreenH(20));
    }];
    
    UIView * topline = [[UIView alloc]init];
    topline.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self addSubview:topline];
    [topline makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(FitPTScreen(1));
    }];
    _topline = topline;
    
    UIView * bottomline = [[UIView alloc]init];
    bottomline.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self addSubview:bottomline];
    [bottomline makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(FitPTScreen(1));
    }];
    _bottomline = bottomline;
    
}

-(void)addClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(addPrinter)]) {
        [self.delegate addPrinter];
    }
}

-(void)showBottomLine:(BOOL)show{
    _bottomline.hidden = !show;
}
@end
