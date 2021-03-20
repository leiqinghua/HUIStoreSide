//
//  HLHUIGiftBaseTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/24.
//

#import "HLProfitGoodTableCell.h"

@interface HLProfitGoodTableCell ()
@property(nonatomic, strong) UIView *bagView;
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UIButton *editBtn;
@property(nonatomic, strong) UIView *hline;
@property(nonatomic, strong) UIView *vline;
@end

@implementation HLProfitGoodTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}
//删除
- (void)closeClick {
    if ([self.delegate respondsToSelector:@selector(giftCell:deleteInfo:)]) {
        [self.delegate giftCell:self deleteInfo:_goodInfo];
    }
}
//编辑
- (void)editClick {
    if ([self.delegate respondsToSelector:@selector(giftCell:editInfo:)]) {
        [self.delegate giftCell:self editInfo:_goodInfo];
    }
}

- (void)initSubView {
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.cornerRadius = FitPTScreen(3);
    _bagView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _bagView.layer.borderWidth = 0.5;
    _bagView.layer.shadowColor = [UIColor hl_StringToColor:@"#000000" andAlpha:0.05].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(1,1);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(4);
    _bagView.layer.masksToBounds = NO;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(15), FitPTScreen(12), 0, FitPTScreen(12)));
    }];
    
    _titleLb = [UILabel hl_singleLineWithColor:@"#343434" font:14 bold:YES];
    [self.bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(12));
    }];
    
    _editBtn = [UIButton hl_regularWithImage:@"eidt_circle_grey" select:NO];
    [self.bagView addSubview:_editBtn];
    [_editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(6));
        make.right.equalTo(FitPTScreen(-10));
    }];
    
    _closeBtn = [UIButton hl_regularWithImage:@"close_x_circle_less_white" select:NO];
    [self.bagView addSubview:_closeBtn];
    [_closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.editBtn);
        make.right.equalTo(self.editBtn.left).offset(FitPTScreen(-14));
    }];
    
    _hline = [[UIView alloc]init];
    _hline.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self.bagView addSubview:_hline];
    [_hline makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bagView);
        make.top.equalTo(FitPTScreen(40));
        make.height.equalTo(0.5);
    }];
    
    _vline = [[UIView alloc]init];
    _vline.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self.bagView addSubview:_vline];
    [_vline makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hline.bottom).offset(FitPTScreen(18));
        make.left.equalTo(FitPTScreen(108));
        make.width.equalTo(0.5);
        make.bottom.equalTo(FitPTScreen(-18));
    }];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setGoodInfo:(HLProfitGoodInfo *)goodInfo {
    _goodInfo = goodInfo;
    _titleLb.text = goodInfo.title;
}

@end

#pragma mark - HLHUIDiscountTableCell

@interface HLProfitDefaultTableCell ()
@property(nonatomic, strong) UILabel *discountLb;
@property(nonatomic, strong) UILabel *tipLb;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *detailLb;
@end

@implementation HLProfitDefaultTableCell
- (void)initSubView {
    [super initSubView];
    _discountLb = [UILabel hl_regularWithColor:@"#FE9E30" font:18];
    [self.bagView addSubview:_discountLb];
    [_discountLb makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bagView.centerY).offset(FitPTScreen(15));
        make.centerX.equalTo(self.bagView.left).offset(FitPTScreen(54));
    }];
    
    _tipLb = [UILabel hl_regularWithColor:@"#888888" font:13];
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.discountLb);
        make.top.equalTo(self.discountLb.bottom).offset(FitPTScreen(9));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#343434" font:13];
    [self.bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vline.right).offset(FitPTScreen(17));
        make.top.equalTo(self.hline.bottom).offset(FitPTScreen(20));
    }];
    
    _detailLb = [UILabel hl_lableWithColor:@"#9A9A9A" font:11 bold:NO numbers:1];
    [self.bagView addSubview:_detailLb];
    [_detailLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(10));
    }];
}

- (void)setGoodInfo:(HLProfitGoodInfo *)goodInfo {
    [super setGoodInfo:goodInfo];
    _nameLb.text = goodInfo.gainName;
    _discountLb.attributedText = goodInfo.discountAttr;
    _tipLb.text = goodInfo.gainTypeName;
    _nameLb.text = goodInfo.gainName;
    _detailLb.text = goodInfo.detailStr;
    if (!goodInfo.detailStr.length) {
        [_nameLb updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hline.bottom).offset(FitPTScreen(32));
        }];
        return;
    }
    [_nameLb updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hline.bottom).offset(FitPTScreen(20));
    }];
}

@end

#pragma mark - HLProfitYMTableCell
@implementation HLProfitYMTableCell
- (void)initSubView {
    [super initSubView];
    self.detailLb.numberOfLines = 0;
}

- (void)setGoodInfo:(HLProfitYMInfo *)goodInfo {
    [super setGoodInfo:goodInfo];
    self.detailLb.attributedText = goodInfo.detailAttr;
}

@end

#pragma mark - HLProfitGiftTableCell

@interface HLProfitGiftTableCell ()
@property(nonatomic, strong) UIImageView *headImV;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *detailLb;
@property(nonatomic, strong) UILabel *priceLb;
@property(nonatomic, strong) UILabel *dateLb;
@end

@implementation HLProfitGiftTableCell

- (void)initSubView {
    [super initSubView];
    _headImV = [[UIImageView alloc]init];
    [self.bagView addSubview:_headImV];
    [_headImV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bagView.left).offset(FitPTScreen(54));
        make.centerY.equalTo(self.bagView.centerY).offset(FitPTScreen(20));
        make.size.equalTo(CGSizeMake(FitPTScreen(75), FitPTScreen(75)));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#343434" font:13];
    [self.bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vline.right).offset(FitPTScreen(16));
        make.top.equalTo(self.hline.bottom).offset(FitPTScreen(17));
        make.width.lessThanOrEqualTo(FitPTScreen(200));
    }];
    
    _priceLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [self.bagView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(8));
    }];
    
    _detailLb = [UILabel hl_lableWithColor:@"#9A9A9A" font:11 bold:NO numbers:2];
    [self.bagView addSubview:_detailLb];
    [_detailLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.priceLb.bottom).offset(FitPTScreen(10));
        make.width.lessThanOrEqualTo(FitPTScreen(198));
    }];
    
    _dateLb = [UILabel hl_lableWithColor:@"#9A9A9A" font:11 bold:NO numbers:1];
    [self.bagView addSubview:_dateLb];
    [_dateLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLb);
        make.top.equalTo(self.detailLb.bottom).offset(FitPTScreen(10));
    }];
}

- (void)setGoodInfo:(HLProfitGiftInfo *)goodInfo {
    [super setGoodInfo:goodInfo];
    [_headImV sd_setImageWithURL:[NSURL URLWithString:goodInfo.imgLogo] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _nameLb.text = goodInfo.gainName;
    _priceLb.text = [NSString stringWithFormat:@"价值：%@",goodInfo.gainPrice];
    _detailLb.text = goodInfo.detailStr;
    _dateLb.hidden = goodInfo.open;
    _dateLb.text = [NSString stringWithFormat:@"%@-%@",goodInfo.startDate,goodInfo.endDate];
}
@end


@interface HLProfitPhoneFeeCell ()
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *dateLb;
@property(nonatomic, strong) UILabel *discountLb;
@property(nonatomic, strong) UILabel *tipLb;
@property(nonatomic, strong) UIView *tagView;
@property(nonatomic, strong) UILabel *tagLb;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *detailLb;
@property(nonatomic, strong) UILabel *bottomLb;
@end

@implementation HLProfitPhoneFeeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UIView *bagView = [[UIView alloc]init];
    bagView.backgroundColor = UIColor.whiteColor;
    bagView.layer.cornerRadius = FitPTScreen(3);
    bagView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    bagView.layer.borderWidth = 0.5;
    [self.contentView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(15), FitPTScreen(12), 0, FitPTScreen(12)));
    }];
    
    _titleLb = [UILabel hl_singleLineWithColor:@"#343434" font:14 bold:YES];
    [bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(12));
    }];
    
    _dateLb = [UILabel hl_regularWithColor:@"#999999" font:12];
    [bagView addSubview:_dateLb];
    [_dateLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.centerY.equalTo(self.titleLb);
    }];
    
    _discountLb = [UILabel hl_regularWithColor:@"#FE9E30" font:18];
    [bagView addSubview:_discountLb];
    [_discountLb makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bagView.centerY);
        make.centerX.equalTo(bagView.left).offset(FitPTScreen(54));
    }];
    
    _tipLb = [UILabel hl_regularWithColor:@"#888888" font:13];
    [bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.discountLb);
        make.top.equalTo(self.discountLb.bottom).offset(FitPTScreen(9));
    }];
    
    UIView *hline = [[UIView alloc]init];
    hline.backgroundColor = UIColorFromRGB(0xEDEDED);
    [bagView addSubview:hline];
    [hline makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bagView);
        make.top.equalTo(FitPTScreen(40));
        make.height.equalTo(0.5);
    }];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [bagView addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(bagView);
        make.bottom.equalTo(FitPTScreen(-30));
        make.height.equalTo(0.5);
    }];
    
    UIView *vline = [[UIView alloc]init];
    vline.backgroundColor = UIColorFromRGB(0xEDEDED);
    [bagView addSubview:vline];
    [vline makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hline.bottom).offset(FitPTScreen(18));
        make.left.equalTo(FitPTScreen(108));
        make.width.equalTo(0.5);
        make.bottom.equalTo(bottomLine.bottom).offset(FitPTScreen(-18));
    }];
    
    
    _tagView = [[UIView alloc]init];
    _tagView.layer.borderColor = UIColorFromRGB(0xFFC893).CGColor;
    _tagView.layer.cornerRadius = FitPTScreen(1.5);
    _tagView.layer.borderWidth = 0.5;
    [bagView addSubview:_tagView];
    [_tagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vline.right).offset(FitPTScreen(17));
        make.top.equalTo(hline.bottom).offset(FitPTScreen(19));
    }];
    
    _tagLb = [UILabel hl_regularWithColor:@"#FD942E" font:11];
    [_tagView addSubview:_tagLb];
    [_tagLb makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tagView).insets(UIEdgeInsetsMake(FitPTScreen(2), FitPTScreen(5), FitPTScreen(5), FitPTScreen(2)));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#333333" font:13];
    [bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagView.right).offset(FitPTScreen(7));
        make.centerY.equalTo(self.tagView);
    }];
    
    _detailLb = [UILabel hl_regularWithColor:@"#999999" font:12];
    [bagView addSubview:_detailLb];
    [_detailLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagView);
        make.top.equalTo(self.tagView.bottom).offset(FitPTScreen(12));
    }];
    
    _bottomLb = [UILabel hl_regularWithColor:@"#999999" font:12];
    [bagView addSubview:_bottomLb];
    [_bottomLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(11));
        make.top.equalTo(bottomLine.bottom).offset(FitPTScreen(10));
    }];
}


- (void)setGoodInfo:(HLPhoneFeeInfo *)goodInfo {
    _goodInfo = goodInfo;
    _titleLb.text = [NSString stringWithFormat:@"开卡送 - %ld张",goodInfo.gainNum];
    _dateLb.text = [NSString stringWithFormat:@"促销活动：%@-%@",goodInfo.startDate,goodInfo.endDate];
    _tipLb.text = @"话费券";
    _discountLb.attributedText = goodInfo.discountAttr;
    _tagLb.text = goodInfo.gainLable;
    _nameLb.text = goodInfo.gainName;
    _detailLb.text = goodInfo.gainDesc;
    _bottomLb.text = goodInfo.gainLableDesc;
}
@end
