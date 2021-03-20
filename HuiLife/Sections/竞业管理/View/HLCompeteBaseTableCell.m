//
//  HLCompeteBaseTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/11.
//

#import "HLCompeteBaseTableCell.h"
#import "HLCompeteStoreInfo.h"

@interface HLCompeteBaseTableCell ()
@property(nonatomic, strong) UILabel *typeLb;
@property(nonatomic, strong) UIButton *stateBtn;
@property(nonatomic, strong) UILabel *distanceLb;
@property(nonatomic, strong) UIImageView *headImV;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *addressLb;
@property(nonatomic, strong) UIButton *optionBtn;
@end

@implementation HLCompeteBaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.clearColor;
    UIView *bagView= [[UIView alloc]init];
    bagView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(FitPTScreen(-5));
    }];
    
    _typeLb = [UILabel hl_regularWithColor:@"#333333" font:12];
    [bagView addSubview:_typeLb];
    [_typeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(24));
    }];
    
    _stateBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:12 image:@""];
    [bagView addSubview:_stateBtn];
    [_stateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLb.right).offset(FitPTScreen(15));
        make.centerY.equalTo(self.typeLb);
    }];
    
    UIView *distanceBagView = [[UIView alloc]init];
    distanceBagView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    distanceBagView.layer.borderWidth = 0.5;
    distanceBagView.layer.cornerRadius = FitPTScreen(19.5);
    [bagView addSubview:distanceBagView];
    [distanceBagView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bagView.right);
        make.top.equalTo(FitPTScreen(9));
        make.size.equalTo(CGSizeMake(FitPTScreen(142), FitPTScreen(39)));
    }];
    
    _distanceLb = [UILabel hl_regularWithColor:@"#333333" font:12];
    [distanceBagView addSubview:_distanceLb];
    [_distanceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(FitPTScreen(6));
    }];
    
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#666666" font:10];
    tipLb.text = @"距离我店";
    [distanceBagView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.distanceLb);
        make.top.equalTo(self.distanceLb.bottom).offset(FitPTScreen(2));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(57));
        make.right.equalTo(FitPTScreen(-0.5));
        make.height.equalTo(FitPTScreen(0.5));
    }];
    
    _headImV = [[UIImageView alloc]init];
    _headImV.layer.cornerRadius = FitPTScreen(3);
    _headImV.layer.masksToBounds = YES;
    [bagView addSubview:_headImV];
    [_headImV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.bottom.equalTo(FitPTScreen(-15));
        make.size.equalTo(CGSizeMake(FitPTScreen(44), FitPTScreen(44)));
    }];
    
    _nameLb = [UILabel hl_singleLineWithColor:@"#333333" font:14 bold:YES];
    [bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImV.right).offset(FitPTScreen(14));
        make.top.equalTo(self.headImV.top).offset(FitPTScreen(5));
    }];
    
    _addressLb = [UILabel hl_singleLineWithColor:@"#888888" font:12 bold:NO];
    [bagView addSubview:_addressLb];
    [_addressLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.bottom.equalTo(FitPTScreen(-15));
        make.width.lessThanOrEqualTo(FitPTScreen(150));
    }];
    
    _optionBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"#FD9E2F" font:12 image:@""];
    _optionBtn.layer.cornerRadius = FitPTScreen(6);
    _optionBtn.layer.masksToBounds = YES;
    _optionBtn.layer.borderColor = UIColorFromRGB(0xFD9E2F).CGColor;
    _optionBtn.layer.borderWidth = 0.5;
    [bagView addSubview:_optionBtn];
    [_optionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.bottom.equalTo(FitPTScreen(-22));
        make.width.equalTo(FitPTScreen(98));
        make.height.equalTo(FitPTScreen(30));
    }];
    [_optionBtn addTarget:self action:@selector(optionClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setStoreInfo:(HLCompeteStoreInfo *)storeInfo {
    _storeInfo = storeInfo;
    _typeLb.text = storeInfo.typeName;
    if (storeInfo.state == 1) {
        [_stateBtn setTitle:@" 营业中" forState:UIControlStateNormal];
        [_stateBtn setImage:[UIImage imageNamed:@"success_deep_green"] forState:UIControlStateNormal];
        [_stateBtn setTitleColor:UIColorFromRGB(0x29A437) forState:UIControlStateNormal];
        [_optionBtn setTitle:@"立即下架" forState:UIControlStateNormal];
        [_optionBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(FitPTScreen(98));
        }];
    } else {
        [_stateBtn setTitle:@" 下架中" forState:UIControlStateNormal];
        [_stateBtn setImage:[UIImage imageNamed:@"error_red"] forState:UIControlStateNormal];
        [_stateBtn setTitleColor:UIColorFromRGB(0xFF4949) forState:UIControlStateNormal];
        [_optionBtn setTitle:@"上架" forState:UIControlStateNormal];
        [_optionBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(FitPTScreen(66));
        }];
    }
    _distanceLb.text = storeInfo.distance;
    _addressLb.text = storeInfo.address;
    _nameLb.text = storeInfo.business_name;
    [_headImV sd_setImageWithURL:[NSURL URLWithString:storeInfo.logo] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
}

- (void)optionClick {
    if (self.upDownCallBack) {
        self.upDownCallBack(self.storeInfo);
    }
}

@end
