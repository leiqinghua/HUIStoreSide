//
//  HLOrderAddressViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/1/13.
//

#import "HLOrderAddressViewCell.h"
#import "HLSubOrderModel.h"

@interface HLOrderAddressViewCell ()

@property(nonatomic, strong) UIImageView *tipImgV;

@property(nonatomic, strong) UILabel *tipLb;
/// 导航
@property(nonatomic, strong) UIButton *navigateBtn;

@property(nonatomic, strong) UILabel *addressLb;

@end

@implementation HLOrderAddressViewCell

- (void)initSubView {
    [super initSubView];
    self.showLine = YES;
    [self showArrow:false];
    
    _tipImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_location"]];
    _tipImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.bagView addSubview:_tipImgV];
    [_tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(15));
        make.width.height.equalTo(FitPTScreen(13));
    }];
    
    _tipLb = [UILabel hl_regularWithColor:@"#868686" font:14];
    _tipLb.text = @"配送地址：";
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImgV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.tipImgV);
        make.width.lessThanOrEqualTo(FitPTScreen(240));
    }];
    
    _addressLb = [UILabel hl_lableWithColor:@"#555555" font:14 bold:false numbers:0];
    [self.bagView addSubview:_addressLb];
    [_addressLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLb.right).offset(FitPTScreen(3));
        make.top.equalTo(self.tipLb);
        make.width.lessThanOrEqualTo(FitPTScreen(180));
    }];
    
    _navigateBtn = [UIButton hl_regularWithTitle:@" 导航" titleColor:@"#FF8604" font:13 image:@"order_navi"];
    [self.bagView addSubview:_navigateBtn];
    [_navigateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.tipLb);
    }];
    UIView *naviLine = [[UIView alloc]init];
    naviLine.backgroundColor = UIColorFromRGB(0xFF8604);
    [_navigateBtn.titleLabel addSubview:naviLine];
    [naviLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navigateBtn.titleLabel);
        make.height.equalTo(0.7);
    }];
    [_navigateBtn addTarget:self action:@selector(navigateBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setOrderModel:(HLBaseOrderModel *)orderModel {
    if ([orderModel isKindOfClass:NSClassFromString(@"HLScanOrderModel")]) {
        HLScanOrderModel *model = (HLScanOrderModel *)orderModel;
        _navigateBtn.hidden = !model.address.length;
        _tipImgV.hidden = !model.address.length;
        _tipLb.hidden = !model.address.length;
        _addressLb.text = model.address;
    }
}

- (void)navigateBtnClick {
    if ([self.delegate respondsToSelector:@selector(hl_addressCellClickToNavigatePage)]) {
        [self.delegate hl_addressCellClickToNavigatePage];
    }
}


@end
