//
//  HLExpressionView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/17.
//

#import "HLExpressionView.h"
#import "HLAlertView.h"

@interface HLExpressionView()

@property(strong,nonatomic)UILabel * titleLable;

@property (strong,nonatomic)UIButton * expressBtn;

@property (strong,nonatomic)UIButton * openBtn;

@property(assign,nonatomic)HLExpressionViewType type;

@property (strong,nonatomic)UILabel * price;

@property (strong,nonatomic)UIImageView * arrowImgV;

@property(nonatomic,strong)UIView * openView;

@property(nonatomic,strong)UIView * line;

@end

@implementation HLExpressionView

-(void)expressClick:(UIButton*)sender{
    NSString * title = @"";
    NSString * subTitle = @"";
    switch (_type) {
        case HLExpressionSettlementType:
            title = @"结算金额";
            subTitle = @"结算金额=实付金额  - 分销佣金 - 手续费";
            break;
        case HLExpressionAcceptTKType:
            title = @"退款金额说明";
            subTitle = @"用户收到退款金额=商品原价/订单原价x用户实付金额 \n 退款方式：原路退回";
            break;
        case HLExpressionBearTKType:
            title = @"退款金额说明";
            subTitle = @"商家承担退款金额=商品原价/订单原价x（订单折扣价-商家补贴）";
            break;
        default:
            break;
    }
    [HLAlertView alertWithTitle:title subTitltle:subTitle type:HLAlertViewDefaultType];
}


-(void)setShowLine:(BOOL)showLine{
    _showLine = showLine;
    _line.hidden = !showLine;
}

-(instancetype)initWithFrame:(CGRect)frame show:(BOOL)show{
    if (self = [super initWithFrame:frame]) {
        _show = show;
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = UIColorFromRGB(0xFF656565);
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    [self addSubview:_titleLable];
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.centerY.equalTo(self);
    }];
    
    _expressBtn = [[UIButton alloc]init];
    [_expressBtn setImage:[UIImage imageNamed:@"waring_grey_big"] forState:UIControlStateNormal];
    [self addSubview:_expressBtn];
    [_expressBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(self);
        make.width.height.equalTo(FitPTScreen(40));
    }];
    [_expressBtn addTarget:self action:@selector(expressClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    _line.hidden = YES;
    [self addSubview:_line];
    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.bottom.equalTo(self);
        make.height.equalTo(FitPTScreen(0.7));
    }];
    
    
    if (self.show) {
        
        _openView = [[UIView alloc]init];
        _openView.backgroundColor = UIColor.whiteColor;
        _openView.layer.cornerRadius = FitPTScreen(12);
        _openView.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
        _openView.layer.borderWidth = FitPTScreen(0.7);
        [self addSubview:_openView];
        [_openView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-20));
            make.centerY.equalTo(self);
            make.width.equalTo(FitPTScreen(58));
            make.height.equalTo(FitPTScreenH(28));
        }];
        
        
        _arrowImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_grey_light"]];
        [_openView addSubview:_arrowImgV];
        [_arrowImgV makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-6));
            make.centerY.equalTo(_openView);
            make.width.equalTo(FitPTScreen(9));
            make.height.equalTo(FitPTScreen(5));
        }];
//
        _openBtn = [[UIButton alloc]init];
        _openBtn.backgroundColor = UIColor.whiteColor;
        [_openBtn setTitle:@"展开" forState:UIControlStateNormal];
        [_openBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_openBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _openBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [_openView addSubview:_openBtn];
        [_openBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImgV.left);
            make.centerY.equalTo(_openView);
            make.left.equalTo(_openView);
        }];
        [_openBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)clickBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    _arrowImgV.image = sender.selected?[UIImage imageNamed:@"arrow_up_grey"]:[UIImage imageNamed:@"grey_xl"];
    if ([self.delegate respondsToSelector:@selector(expressView:click:)]) {
        [self.delegate expressView:self click:sender];
    }
}

-(void)setShow:(BOOL)show{
    _openView.hidden = !show;
}

-(void)setIsSection:(BOOL)isSection{
    _isSection = isSection;
    _expressBtn.hidden = _isSection;
    _titleLable.text = @"部分退款";
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    _openBtn.selected = isSelected;
    _arrowImgV.image = _openBtn.selected?[UIImage imageNamed:@"arrow_up_grey"]:[UIImage imageNamed:@"grey_xl"];
}

-(void)setContent:(NSString *)money type:(HLExpressionViewType)type{
    _type = type;
    NSString * title = @"结算金额";
    switch (type) {
        case HLExpressionAcceptTKType:
            title = @"用户收到退款金额";
            break;
        case HLExpressionBearTKType:
            title = @"商家承担退款金额";
            break;
        default:
            break;
    }
    
    if (!money.length) {
        _titleLable.attributedText = [self attrWithText:title];
        return;
    }
    
    NSString * content = [NSString stringWithFormat:@"%@ %@",title,money];
    if (![money containsString:@"¥"]) {
        content = [NSString stringWithFormat:@"%@ ¥%@",title,money];
    }
    _titleLable.attributedText = [self attrWithText:content];
}




-(void)showPrice:(NSString *)price{
    if (_price) {
        _price.text = [NSString stringWithFormat:@"￥%@",price];
        return;
    }
    _price = [[UILabel alloc]init];
    _price.text = price;
    _price.font = [UIFont systemFontOfSize:FitPTScreen(18)];
    _price.textColor = [UIColor hl_StringToColor:@"#FF8D26"];
    [self addSubview:_price];
    [_price makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.centerY.equalTo(self);
    }];
}

-(NSAttributedString *)attrWithText:(NSString *)text{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = [text rangeOfString:@"¥"];
    if (range.location != NSNotFound) {
        NSDictionary * attributes = @{NSFontAttributeName :[UIFont boldSystemFontOfSize:FitPTScreen(20)],NSForegroundColorAttributeName:UIColorFromRGB(0xFF4040)};
        [attr addAttributes:attributes range:NSMakeRange(range.location, text.length - range.location)];
        
        [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(14)]} range:range];
    }
    
    return attr;
}

@end
