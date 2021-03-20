//
//  HLLBHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import "HLLBHeaderView.h"
#import "HLWithNotImgAlertView.h"

@interface HLLBHeaderView (){
    UIView *lineview;
    UIView *topLineview;
}
@property(strong,nonatomic)UIButton * addbtn;

@property(strong,nonatomic)UIButton * deletebtn;


@end
@implementation HLLBHeaderView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
       [self createUI];
    }
    return self;
}

-(void)createUI{
    UIView * bagView = [[UIView alloc]init];
    bagView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.backgroundColor = [UIColor whiteColor];
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = UIColorFromRGB(0x656565);
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    _titleLable.text = @"火锅类";
    [self addSubview:_titleLable];
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(FitPTScreen(20));
    }];
    
    _addbtn = [[UIButton alloc]init];
    [_addbtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addbtn.backgroundColor = UIColorFromRGB(0xFF8D26);
    _addbtn.layer.cornerRadius = 2;
    _addbtn.titleLabel.font =[UIFont systemFontOfSize:FitPTScreenH(10)];
    [self addSubview:_addbtn];
    [_addbtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(FitPTScreen(240));
        make.width.equalTo(FitPTScreen(50));
        make.height.equalTo(FitPTScreen(24));
    }];
    [_addbtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _deletebtn = [[UIButton alloc]init];
    [_deletebtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deletebtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
    _deletebtn.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _deletebtn.layer.cornerRadius = 2;
    _deletebtn.layer.borderColor =UIColorFromRGB(0xFF8D26).CGColor;
    _deletebtn.layer.borderWidth = 1;
    _deletebtn.titleLabel.font =[UIFont systemFontOfSize:FitPTScreenH(10)];
    [self addSubview:_deletebtn];
    [_deletebtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.addbtn.mas_right).offset(FitPTScreen(15));
        make.width.equalTo(FitPTScreen(50));
        make.height.equalTo(FitPTScreenH(24));
    }];
    [_deletebtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    lineview = [[UIView alloc]init];
    lineview.backgroundColor =UIColorFromRGB(0xDDDDDD);
    [self addSubview:lineview];
    [lineview makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self);
        make.height.equalTo(FitPTScreen(1));
    }];
    
    topLineview = [[UIView alloc]init];
    topLineview.backgroundColor =UIColorFromRGB(0xDDDDDD);
    [self addSubview:topLineview];
    [topLineview makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self);
        make.height.equalTo(FitPTScreen(1));
    }];
    
    //user_xialasanjiao
    _sanjiao = [[UIButton alloc]init];
    [_sanjiao setImage:[UIImage imageNamed:@"select_md_normal"] forState:UIControlStateNormal];
    [_sanjiao setImage:[UIImage imageNamed:@"select_md_selected"] forState:UIControlStateSelected];
    [self addSubview:_sanjiao];
    [_sanjiao makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(FitPTScreen(-15));
        make.width.height.equalTo(FitPTScreen(40));
    }];
    _sanjiao.hidden = YES;
    [_sanjiao addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tap:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_isSelect) {
        //如果是选择类别，点击view展开数据
        if (self.delegate) {
            [self.delegate tapTheViewSelect:_isSelect indexpath:_index];
        }
    }//如果是管理类别，不做处理
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _addbtn.hidden = isSelect;
    _deletebtn.hidden = isSelect;
    _sanjiao.hidden = !isSelect;
}

-(void)addClick:(UIButton *)sender{
    NSLog(@"添加小类");
    [self.superview endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(cancelFirstResponder)]) {
        [self.delegate cancelFirstResponder];
    }
    MJWeakSelf;
    HLWithNotImgAlertView *alertView=[[HLWithNotImgAlertView alloc]initWithTitle:@"添加小类" placeHolder:@"请输入新建小类" hight:FitPTScreen(177) concern:^(NSString *text) {
        if (text.length > 14) {
            [HLTools showWithText:@"不得超过14个字"];
            return;
        }
        if (weakSelf.delegate) {
            [weakSelf.delegate addSmallClassAtIndexPath:weakSelf.index className:text];
        }
    } cancel:^{
        
    }];
    [KEY_WINDOW addSubview:alertView];
    
}

-(void)deleteClick:(UIButton *)sender{
     NSLog(@"删除一个大类");
    [self.superview endEditing:YES];
    MJWeakSelf;
    HLWithNotImgAlertView *alertView = [[HLWithNotImgAlertView alloc]initWithTitle:@"是否删除类别" subTitle:_titleLable.text hight:FitPTScreen(155) subColor:UIColorFromRGB(0xFF8D26) oncern:^{
        if (weakSelf.delegate) {
            [weakSelf.delegate deleteBigClassAtIndexPath:weakSelf.index];
        }
    } cancel:^{
        
    }];
    [KEY_WINDOW addSubview:alertView];
    
}

-(void)hideBottomLine:(BOOL)hide{
    lineview.hidden = hide;
}

-(void)setSelectLB:(BOOL)isSelect{
    _sanjiao.selected = isSelect;
}
@end
