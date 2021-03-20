//
//  HLCusCardTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/4.
//

#import "HLCusCardTableCell.h"
#import "HLCustomerInfo.h"

@interface HLCusCardTableCell ()
@property(nonatomic, strong) UIView *bagView;
@property(nonatomic, strong) UILabel *tagLb;//HUI卡
@property(nonatomic, strong) UILabel *phoneLb;
@property(nonatomic, strong) UILabel *wayLb;//开卡方式
@property(nonatomic, strong) UILabel *gainLb;//收益
@property(nonatomic, strong) UILabel *startDateLb;
@property(nonatomic, strong) UILabel *endDateLb;
@end

@implementation HLCusCardTableCell

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
    _bagView.layer.cornerRadius = FitPTScreen(7);
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(12), FitPTScreen(5), FitPTScreen(12)));
    }];
    
    _tagLb = [UILabel hl_regularWithColor:@"#FFFFFF" font:11];
    _tagLb.backgroundColor = UIColorFromRGB(0xFD9E2F);
    _tagLb.layer.cornerRadius = FitPTScreen(1.5);
    _tagLb.layer.masksToBounds = YES;
    _tagLb.textAlignment = NSTextAlignmentCenter;
    [_bagView addSubview:_tagLb];
    [_tagLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(FitPTScreen(15));
        make.size.equalTo(CGSizeMake(FitPTScreen(39), FitPTScreen(16)));
    }];
    
    _phoneLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    [_bagView addSubview:_phoneLb];
    [_phoneLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLb.right).offset(FitPTScreen(5));
        make.centerY.equalTo(self.tagLb);
    }];
    
    _wayLb = [UILabel hl_regularWithColor:@"#555555" font:12];
    [_bagView addSubview:_wayLb];
    [_wayLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(self.tagLb.bottom).offset(FitPTScreen(10));
    }];
    
    _gainLb = [UILabel hl_regularWithColor:@"#555555" font:12];
    [_bagView addSubview:_gainLb];
    [_gainLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wayLb);
        make.top.equalTo(self.wayLb.bottom).offset(FitPTScreen(5));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [_bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-15));
        make.bottom.equalTo(FitPTScreen(-35));
        make.height.equalTo(FitPTScreen(0.5));
    }];
    
    _startDateLb = [UILabel hl_regularWithColor:@"#A9A9A8" font:11];
    [_bagView addSubview:_startDateLb];
    [_startDateLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(line.bottom).offset(FitPTScreen(11));
    }];
    
    _endDateLb = [UILabel hl_regularWithColor:@"#A9A9A8" font:11];
    [_bagView addSubview:_endDateLb];
    [_endDateLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.centerY.equalTo(self.startDateLb);
    }];
}

- (void)setInfo:(HLCustomerInfo *)info {
    _info = info;
    _tagLb.text = info.label;
    _phoneLb.text = info.phone;
    _wayLb.text = [NSString stringWithFormat:@"开卡方式：%@",info.openType];
    _gainLb.text = [NSString stringWithFormat:@"开卡收益：%@元",info.openProfit];
    _startDateLb.text = [NSString stringWithFormat:@"办卡时间：%@",info.startTime];
    _endDateLb.text = [NSString stringWithFormat:@"到期时间：%@",info.endTime];
}
@end
