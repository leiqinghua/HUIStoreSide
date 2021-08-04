//
//  HLMonthCardTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/7.
//

#import "HLMonthCardTableCell.h"
#import "HLCustomerInfo.h"

@interface HLMonthCardTableCell ()
@property(nonatomic, strong) UIView *bagView;
@property(nonatomic, strong) UILabel *tagLb;//HUI卡
@property(nonatomic, strong) UILabel *phoneLb;
@property(nonatomic, strong) UILabel *numLb;//消费次数
@property(nonatomic, strong) UILabel *totalLb;//消费总金额
@property(nonatomic, strong) UILabel *earnLb; //收益佣金
@end
@implementation HLMonthCardTableCell

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
    _tagLb.text = @"HUI卡";
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
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [_bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-15));
        make.top.equalTo(FitPTScreen(45));
        make.height.equalTo(FitPTScreen(0.5));
    }];
    
    _numLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [_bagView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(line.bottom).offset(FitPTScreen(15));
    }];
    
    _totalLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [_bagView addSubview:_totalLb];
    [_totalLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLb);
        make.top.equalTo(self.numLb.bottom).offset(FitPTScreen(5));
    }];
    
    _earnLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [_bagView addSubview:_earnLb];
    [_earnLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalLb);
        make.top.equalTo(self.totalLb.bottom).offset(FitPTScreen(5));
    }];
}

- (void)setMonthInfo:(HLMonthActiveInfo *)monthInfo {
    _monthInfo = monthInfo;
    _tagLb.text = monthInfo.label;
    _phoneLb.text = monthInfo.phone;
    _numLb.text = [NSString stringWithFormat:@"消费次数：%@",monthInfo.num];
    _totalLb.text = [NSString stringWithFormat:@"消费总金额：%@元",monthInfo.price];
    _earnLb.text = [NSString stringWithFormat:@"收益佣金：%@元",monthInfo.commission];
}

@end
