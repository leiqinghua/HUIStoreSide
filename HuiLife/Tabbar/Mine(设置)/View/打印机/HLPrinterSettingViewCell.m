//
//  HLPrinterSettingViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//

#import "HLPrinterSettingViewCell.h"

@interface HLPrinterSettingViewCell()

@property (strong,nonatomic)UIImageView * leftImg;

@property (strong,nonatomic)UIImageView * rightImg;

@property (strong,nonatomic)UILabel * title;

@property (strong,nonatomic)UILabel * subTitle;

@property (strong,nonatomic)UISwitch * switchView;

@property (strong,nonatomic)UIView *line;

@property (strong,nonatomic)UIActivityIndicatorView * loadingIV;
@end

@implementation HLPrinterSettingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(HLPrinterSetModel *)model{
    _model = model;
    _leftImg.image = [UIImage imageNamed:_model.leftPic?:@""];
    _title.text = _model.title?:@"";
    _subTitle.text = _model.subTitle?:@"";
    _rightImg.image =[UIImage imageNamed:_model.rightPic?:@""];
    if (model.isSwitch) {
        self.switchView.hidden = NO;
    }else{
        _switchView.hidden = YES;
    }
    _switchView.on = model.isON;
    if (model.isLoading) {
        [self startLoading];
    }else{
        [self endLoading];
    }
    
    [self layout];
}


-(void)changeValue:(UISwitch *)sender{
    if ([self.delegate respondsToSelector:@selector(tableVeiwCell:showDevicesWithON:)]) {
         [self.delegate tableVeiwCell:self showDevicesWithON:sender.on];
    }
}


-(void)showTopLine:(BOOL)show gap:(CGFloat)gap{
    _line.hidden = !show;
    [_line updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gap);
        make.right.equalTo(-gap);
    }];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    _leftImg = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImg];
    
    _title = [[UILabel alloc]init];
    _title.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    _title.textColor = UIColorFromRGB(0x656565);
    [self.contentView addSubview:_title];
    
    _subTitle = [[UILabel alloc]init];
    _subTitle.font = [UIFont systemFontOfSize:FitPTScreenH(12)];
    _subTitle.textColor = UIColorFromRGB(0x989898);
    _subTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    _subTitle.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_subTitle];
    
    _rightImg = [[UIImageView alloc]init];
    [self.contentView addSubview:_rightImg];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self.contentView addSubview:_line];
    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.top.equalTo(self.contentView);
        make.height.equalTo(FitPTScreen(1));
    }];
    
    [self layout];
}

- (void)layout{
    [_leftImg remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([self.model.leftPic hl_isAvailable]? FitPTScreen(20):0);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_title remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).offset([self.model.leftPic hl_isAvailable]?FitPTScreen(10):FitPTScreen(20));
        make.centerY.equalTo(self.contentView);
    }];
    
    [_rightImg remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self.contentView);
    }];
    
    [_subTitle remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImg.mas_left).offset(FitPTScreen(-10));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(200));
    }];
    
}

-(UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc]init];
        _switchView.tintColor = [UIColor clearColor];
        _switchView.onTintColor = UIColorFromRGB(0xFF8D26);
        [_switchView setBackgroundColor:UIColorFromRGB(0xFFF2F2F2)];
        _switchView.layer.cornerRadius = _switchView.bounds.size.height/2.0;
        [self.contentView addSubview:_switchView];
        _switchView.hidden = YES;
        [_switchView addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
        _switchView.hidden = YES;
        
        [_switchView remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-20));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _switchView;
}

- (void)startLoading{
    _rightImg.hidden = YES;
    
    _loadingIV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_loadingIV];
    _loadingIV.alpha = 0;
    [_loadingIV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(30));
        make.width.equalTo(FitPTScreen(30));
    }];
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingIV.alpha = 1;
    } completion:^(BOOL finished) {
        [self.loadingIV startAnimating];
    }];
    
}

- (void)endLoading{
    _rightImg.hidden = NO;
    [_loadingIV stopAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingIV.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingIV removeFromSuperview];
        self.loadingIV = nil;
    }];
}

@end
