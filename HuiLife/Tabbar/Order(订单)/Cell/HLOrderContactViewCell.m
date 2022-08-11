//
//  HLOrderContactViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/1/13.
//

#import "HLOrderContactViewCell.h"

@interface HLOrderContactViewCell ()

@property(nonatomic, strong) UILabel *tipLb;

@property(nonatomic, strong) UILabel *contentLb;

@property(nonatomic, strong) UIButton *phoneBtn;

@end

@implementation HLOrderContactViewCell

- (void)initSubView {
    [super initSubView];
    self.showLine = YES;
    [self showArrow:NO];
    
    _tipLb = [UILabel hl_regularWithColor:@"#868686" font:14];
    _tipLb.text = @"联系方式：";
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.centerY.equalTo(self.bagView);
        make.width.lessThanOrEqualTo(FitPTScreen(240));
    }];
    
    _contentLb = [UILabel hl_regularWithColor:@"#555555" font:14];
    [self.bagView addSubview:_contentLb];
    [_contentLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLb.right).offset(FitPTScreen(3));
        make.centerY.equalTo(self.tipLb);
        make.width.lessThanOrEqualTo(FitPTScreen(200));
    }];
    
    _phoneBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 image:@"phone_green"];
    [self.bagView addSubview:_phoneBtn];
    [_phoneBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.contentLb);
        make.width.height.equalTo(FitPTScreen(30));
    }];
    [_phoneBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)callClick {
    HLScanOrderModel *model = (HLScanOrderModel *) _orderModel;
    if (model.tel.length) {
        [HLTools callPhone:model.tel];
    }
}

- (void)setOrderModel:(HLBaseOrderModel *)orderModel {
    _orderModel = orderModel;
    HLScanOrderModel *model = (HLScanOrderModel *) _orderModel;
    _contentLb.text = [NSString stringWithFormat:@"%@  %@",model.name,model.tel];
    _tipLb.text = model.contactTip;
    // 如果不用这个 cell 的话，外部仅仅设置 cell 的高度为 0，是会出现问题的，内部 cell 还会显示
    BOOL subViewHidden = (!model.name.length || !model.tel.length);
    _contentLb.hidden = _phoneBtn.hidden = _tipLb.hidden = subViewHidden;
}
@end
