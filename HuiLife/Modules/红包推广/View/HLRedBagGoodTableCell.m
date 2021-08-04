//
//  HLRedBagGoodTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/16.
//

#import "HLRedBagGoodTableCell.h"

@interface HLRedBagGoodTableCell ()
@property(nonatomic, strong) UILabel *tagLb;
@property(nonatomic, strong) UILabel *timeLb;
@property(nonatomic, strong) UIImageView *headView;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *totalLb;
@property(nonatomic, strong) UILabel *balanceLb;
@property(nonatomic, strong) UILabel *usedLb;
@property(nonatomic, strong) UILabel *returnLb;
@property(nonatomic, strong) UIButton *promoteBtn;
@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UIButton *redBagBtn;
@property(nonatomic, strong) UILabel *typeLb;

@end

@implementation HLRedBagGoodTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.clearColor;
    
    UIView *bagView = [[UIView alloc]init];
    [self.contentView addSubview:bagView];
    bagView.backgroundColor = UIColor.whiteColor;
    bagView.layer.shadowColor = [UIColor hl_StringToColor:@"#000000" andAlpha:0.05].CGColor;
    bagView.layer.shadowOffset = CGSizeMake(1,1);
    bagView.layer.shadowOpacity = 1;
    bagView.layer.shadowRadius = FitPTScreen(8);
    bagView.layer.cornerRadius = FitPTScreen(5);
    bagView.layer.masksToBounds = NO;
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(12), FitPTScreen(5), FitPTScreen(12)));
    }];
    
    _tagLb = [UILabel hl_regularWithColor:@"#FFFFFF" font:11];
    _tagLb.layer.cornerRadius = FitPTScreen(3);
    _tagLb.layer.masksToBounds = YES;
    _tagLb.textAlignment = NSTextAlignmentCenter;
    [bagView addSubview:_tagLb];
    [_tagLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(11));
        make.size.equalTo(CGSizeMake(FitPTScreen(44), FitPTScreen(17)));
    }];
    
    _timeLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_timeLb];
    [_timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.tagLb);
    }];
    
    UIView *vLine = [[UIView alloc]init];
    vLine.backgroundColor = UIColorFromRGB(0xDBDBDB);
    [bagView addSubview:vLine];
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLb.left).offset(FitPTScreen(-6));
        make.centerY.equalTo(self.timeLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(0.5), FitPTScreen(9)));
    }];
    
    _typeLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_typeLb];
    [_typeLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(vLine.left).offset(FitPTScreen(-6));
        make.centerY.equalTo(self.tagLb);
    }];
    
    UIView *hLine = [[UIView alloc]init];
    hLine.backgroundColor = UIColorFromRGB(0xDBDBDB);
    [bagView addSubview:hLine];
    [hLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bagView);
        make.top.equalTo(FitPTScreen(38));
        make.height.equalTo(FitPTScreen(0.5));
    }];
    
    _headView = [[UIImageView alloc]init];
    _headView.layer.cornerRadius = FitPTScreen(6);
    _headView.layer.masksToBounds = YES;
    [bagView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(hLine.bottom).offset(FitPTScreen(10));
        make.size.equalTo(CGSizeMake(FitPTScreen(80), FitPTScreen(80)));
    }];
    
    _nameLb = [UILabel hl_singleLineWithColor:@"#333333" font:14 bold:YES];
    [bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(12));
        make.top.equalTo(self.headView.top).offset(FitPTScreen(10));
        make.width.lessThanOrEqualTo(FitPTScreen(234));
    }];
    
    _totalLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_totalLb];
    [_totalLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(15));
    }];
    
    _usedLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_usedLb];
    [_usedLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.totalLb.bottom).offset(FitPTScreen(5));
    }];
    
    _balanceLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_balanceLb];
    [_balanceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalLb.right).offset(FitPTScreen(35));
        make.centerY.equalTo(self.totalLb);
    }];
    
    _returnLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_returnLb];
    [_returnLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceLb);
        make.centerY.equalTo(self.usedLb);
    }];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = UIColorFromRGB(0xDBDBDB);
    [bagView addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bagView);
        make.bottom.equalTo(FitPTScreen(-51));
        make.height.equalTo(FitPTScreen(0.5));
    }];
    
  
    _promoteBtn = [UIButton hl_regularWithImage:@"redbag_tip" select:NO];
    [bagView addSubview:_promoteBtn];
    [_promoteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.bottom.equalTo(FitPTScreen(-15));
        make.size.equalTo(CGSizeMake(FitPTScreen(30), FitPTScreen(30)));
    }];
    [_promoteBtn addTarget:self action:@selector(promoteClick) forControlEvents:UIControlEventTouchUpInside];
    
    _playBtn = [[UIButton alloc]init];
    [_playBtn setImage:[UIImage imageNamed:@"green_play"] forState:UIControlStateNormal];
    [bagView addSubview:_playBtn];
    [_playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promoteBtn.right).offset(FitPTScreen(13));
        make.centerY.equalTo(self.promoteBtn);
    }];
    [_playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _redBagBtn = [UIButton hl_regularWithTitle:@" 追加红包" titleColor:@"#FD9E2F" font:13 image:@"red_bag"];
    _redBagBtn.layer.borderColor = UIColorFromRGB(0xFD9E2F).CGColor;
    _redBagBtn.layer.cornerRadius = FitPTScreen(6);
    _redBagBtn.layer.borderWidth = 0.5;
    [bagView addSubview:_redBagBtn];
    [_redBagBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.playBtn);
        make.size.equalTo(CGSizeMake(FitPTScreen(98), FitPTScreen(30)));
    }];
    [_redBagBtn addTarget:self action:@selector(redBagClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setInfo:(HLRedBagPromoteInfo *)info {
    _info = info;
    if (info.state == 0) { //推广中
        _tagLb.backgroundColor = UIColorFromRGB(0x20BF64);
        _tagLb.text = @"推广中";
        [_playBtn setImage:[UIImage imageNamed:@"red_pause"] forState:UIControlStateNormal];
    }
    if (info.state == 1) {//暂停中
        _tagLb.backgroundColor = UIColorFromRGB(0xFF5656);
        _tagLb.text = @"暂停中";
        [_playBtn setImage:[UIImage imageNamed:@"green_play"] forState:UIControlStateNormal];
    }
    if (info.state == 2) { //已结束
        _tagLb.backgroundColor = UIColorFromRGB(0xCCCCCC);
        _tagLb.text = @"已结束";
        [_playBtn setImage:[UIImage imageNamed:@"grey_play"] forState:UIControlStateNormal];
    }
    _timeLb.text = info.timeStr;
    [_headView sd_setImageWithURL:[NSURL URLWithString:info.pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _nameLb.text = info.name;
    _totalLb.text = [NSString stringWithFormat:@"总额：%@元",info.total];
    _balanceLb.text = [NSString stringWithFormat:@"剩余：%@元",info.left];
    _usedLb.text = [NSString stringWithFormat:@"领取：%@人",info.get];
    _returnLb.text = [NSString stringWithFormat:@"退回：%@元",info.back?:@"0"];
    _typeLb.text = info.scopeStr;
}

- (void)redBagClick {
    if ([self.delegate respondsToSelector:@selector(redBagCell:promoteInfo:type:)]) {
        [self.delegate redBagCell:self promoteInfo:_info type:1];
    }
}

- (void)promoteClick {
    if ([self.delegate respondsToSelector:@selector(redBagCell:promoteInfo:type:)]) {
        [self.delegate redBagCell:self promoteInfo:_info type:0];
    }
}

- (void)playBtnClick {
    if ([self.delegate respondsToSelector:@selector(redBagCell:promoteInfo:type:)]) {
        [self.delegate redBagCell:self promoteInfo:_info type:2];
    }
}
@end
