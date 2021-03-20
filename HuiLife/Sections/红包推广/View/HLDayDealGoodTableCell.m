//
//  HLDayDealGoodTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/17.
//

#import "HLDayDealGoodTableCell.h"
#import "HLDayDealGoodInfo.h"

@interface HLDayDealGoodTableCell ()
@property(nonatomic, strong) UIImageView *headImV;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *timeLb;
@property(nonatomic, strong) UILabel *totalNumLb;
@property(nonatomic, strong) UILabel *blanceLb;
@property(nonatomic, strong) UIImageView *selectImV;
@property(nonatomic, strong) UIView *tagView;
@property(nonatomic, strong) UILabel *tagLb;
@property(nonatomic, strong) UIView *coverView;
@end

@implementation HLDayDealGoodTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UIView *bagView = [[UIView alloc]init];
    bagView.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    bagView.layer.borderWidth = 0.5;
    bagView.layer.cornerRadius = FitPTScreen(6);
    [self.contentView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(12), 0, FitPTScreen(12)));
    }];
    
    _headImV = [[UIImageView alloc]init];
    [bagView addSubview:_headImV];
    [_headImV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(FitScreenH(10));
        make.size.equalTo(CGSizeMake(FitPTScreen(75), FitPTScreen(75)));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#000000" font:14];
    [bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImV.right).offset(FitPTScreen(13));
        make.top.equalTo(FitPTScreen(18));
    }];
    
    _timeLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_timeLb];
    [_timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(6));
    }];
    
    _totalNumLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_totalNumLb];
    [_totalNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.bottom.equalTo(FitPTScreen(-15));
    }];
    
    _blanceLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    [bagView addSubview:_blanceLb];
    [_blanceLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalNumLb);
        make.left.equalTo(self.totalNumLb.right).offset(FitPTScreen(13));
    }];
    
    _selectImV = [[UIImageView alloc]init];
    _selectImV.image = [UIImage imageNamed:@"select_md_normal"];
    [bagView addSubview:_selectImV];
    [_selectImV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bagView);
        make.right.equalTo(FitPTScreen(-10));
        make.size.equalTo(CGSizeMake(FitPTScreen(18), FitPTScreen(18)));
    }];
    
    _tagView = [[UIView alloc]init];
    _tagView.layer.cornerRadius = FitPTScreen(8.5);
    _tagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [_headImV addSubview:_tagView];
    [_tagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(FitScreenH(3));
        make.height.equalTo(FitPTScreen(17));
    }];
    
    _tagLb = [UILabel hl_regularWithColor:@"#FFFFFF" font:11];
    [_tagView addSubview:_tagLb];
    [_tagLb makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tagView).insets(UIEdgeInsetsMake(FitPTScreen(3), FitPTScreen(6),FitPTScreen(3), FitPTScreen(6)));
    }];
    
    _coverView = [[UIView alloc]init];
    _coverView.userInteractionEnabled = NO;
    _coverView.backgroundColor = [UIColor hl_StringToColor:@"#F3F3F3" andAlpha:0.6];
    [bagView addSubview:_coverView];
    [_coverView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bagView);
    }];
    _coverView.hidden = YES;
    
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    tipLb.text = @"已被选择";
    [_coverView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.coverView);
    }];
}

- (void)setGoodInfo:(HLDayDealGoodInfo *)goodInfo {
    _goodInfo = goodInfo;
    _selectImV.image = goodInfo.click?[UIImage imageNamed:@"success_yellow_light"]:[UIImage imageNamed:@"select_md_normal"];
    _coverView.hidden = !goodInfo.isSelected;
    _tagLb.text = goodInfo.stateDesc;
    _nameLb.text = goodInfo.title;
    _timeLb.text = goodInfo.end_time;
    _totalNumLb.text = [NSString stringWithFormat:@"总份数：%ld",goodInfo.count];
    _blanceLb.text = [NSString stringWithFormat:@"剩余分数：%ld",goodInfo.stock_num];
    [_headImV sd_setImageWithURL:[NSURL URLWithString:goodInfo.pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
}
@end
