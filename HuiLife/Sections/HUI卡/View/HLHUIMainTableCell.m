//
//  HLHUIMainTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/23.
//

#import "HLHUIMainTableCell.h"
#import "HLHUIMainInfo.h"

@interface HLHUIMainTableCell ()
@property(nonatomic, strong) UIView *bagView;
@property(nonatomic, strong) UIImageView *tagImV;
@property(nonatomic, strong) UILabel *tagLb;
@property(nonatomic, strong) UILabel *timeLbl;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *oriPriceLb;
@property(nonatomic, strong) UILabel *priceLb;
@property(nonatomic, strong) UILabel *numLb;
@property(nonatomic, strong) UIButton *moreBtn;
@end

@implementation HLHUIMainTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.cornerRadius = FitPTScreen(5);
    _bagView.layer.shadowColor = [UIColor hl_StringToColor:@"#000000" andAlpha:0.05].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(1,2);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(8);
    _bagView.layer.masksToBounds = NO;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(12), FitPTScreen(5), FitPTScreen(12)));
    }];
    
    _tagImV = [[UIImageView alloc]init];
    [self.bagView addSubview:_tagImV];
    [_tagImV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bagView);
    }];
    
    _tagLb = [UILabel hl_regularWithColor:@"#FFFFFF" font:11];
    [_tagImV addSubview:_tagLb];
    [_tagLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.tagImV);
    }];
    
    _timeLbl = [UILabel hl_regularWithColor:@"#565656" font:14];
    [self.bagView addSubview:_timeLbl];
    [_timeLbl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.left).offset(FitPTScreen(49));
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xF6F7F9);
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(98));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(0.5), FitPTScreen(78)));
    }];
    
    _nameLb = [UILabel hl_singleLineWithColor:@"#343434" font:14 bold:YES];
    [self.contentView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.right).offset(FitPTScreen(23));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _oriPriceLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
    [self.bagView addSubview:_oriPriceLb];
    [_oriPriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(12));
        make.left.equalTo(self.nameLb);
    }];
    
    UIView *priceLine = [[UIView alloc]init];
    priceLine.backgroundColor = UIColorFromRGB(0xAAAAAA);
    [self.contentView addSubview:priceLine];
    [priceLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.width.equalTo(self.oriPriceLb);
        make.height.equalTo(0.5);
    }];
    
    _priceLb = [UILabel hl_regularWithColor:@"#343434" font:12];
    [self.bagView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oriPriceLb.bottom).offset(FitPTScreen(7));
        make.left.equalTo(self.nameLb);
    }];
    
    _numLb = [UILabel hl_regularWithColor:@"#343434" font:12];
    [self.bagView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.bottom.equalTo(FitPTScreen(-18));
    }];
    
    _moreBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 image:@"share_h_grey_dot"];
    [self.bagView addSubview:_moreBtn];
    [_moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-7));
        make.top.equalTo(FitPTScreen(10));
        make.size.equalTo(CGSizeMake(FitPTScreen(28), FitPTScreen(16)));
    }];
    [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tagImV.image = [UIImage imageNamed:@"bag_tag_oriange"];
    _tagLb.text = @"销售中";
    _timeLbl.text = @"期限1年";
    _nameLb.text = @"HUI卡名称hui卡名称";
    _oriPriceLb.text = @"原价：¥128.88";
    _priceLb.text = @"售价：¥88.88";
    _numLb.text = @"已售222张";
    
}

- (void)setInfo:(HLHUIMainInfo *)info {
    _info = info;
    _tagImV.image = info.state == 0?[UIImage imageNamed:@"bag_tag_oriange"]:[UIImage imageNamed:@"bag_tag_grey"];
    _tagLb.text = info.stateDesc;
    _timeLbl.attributedText = info.timeAttr;
    _nameLb.text = info.cardName;
    _oriPriceLb.text = [NSString stringWithFormat:@"原价：¥%@",info.originalPrice];
    _priceLb.text = [NSString stringWithFormat:@"售价：¥%@",info.salePrice];
    _numLb.text = [NSString stringWithFormat:@"已售%ld张",info.saleNum];
}

- (void)moreClick {
    if ([self.delegate respondsToSelector:@selector(mainCell:moreWithInfo:)]) {
        [self.delegate mainCell:self moreWithInfo:_info];
    }
}

@end
