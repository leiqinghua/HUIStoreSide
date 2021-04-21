//
//  HLVideoMarketAddController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLVideoMarketAddController.h"

@interface HLVideoMarketAddController ()

@property (nonatomic, strong) UITextField *goodNameLab;
@property (nonatomic, strong) UITextView *titleInput;
@property (nonatomic, strong) UITextView *descInput;

@end

@implementation HLVideoMarketAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建短视频";
    UIView *topView = [self creatGoodNameSelectView];
    [topView hl_addTarget:self action:@selector(selectGoods)];
}

#pragma mark - Method

/// 选择商品
- (void)selectGoods{
    
}

#pragma mark - View

- (UIView *)creatGoodNameSelectView{
    
    UIView *goodNameSelectView = [[UIView alloc] init];
    goodNameSelectView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:goodNameSelectView];
    [goodNameSelectView makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.top.equalTo(Height_NavBar);
        make.height.equalTo(FitPTScreen(50));
    }];
    
    UILabel *starLab = [[UILabel alloc] init];
    [goodNameSelectView addSubview:starLab];
    starLab.text = @"*";
    starLab.textColor = UIColorFromRGB(0xEB1731);
    starLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [starLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodNameSelectView);
        make.left.equalTo(FitPTScreen(12));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [goodNameSelectView addSubview:tipLab];
    tipLab.text = @"选择推广商品";
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodNameSelectView);
        make.left.equalTo(starLab.right).offset(FitPTScreen(8));
    }];
    
    UIImageView *arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [goodNameSelectView addSubview:arrowImgV];
    [arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(goodNameSelectView);
        make.width.equalTo(FitPTScreen(9));
        make.height.equalTo(FitPTScreen(11));
    }];
    
    _goodNameLab = [[UITextField alloc] init];
    [goodNameSelectView addSubview:_goodNameLab];
    _goodNameLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _goodNameLab.textColor = UIColorFromRGB(0x333333);
    _goodNameLab.placeholder = @"请选择商品";
    _goodNameLab.enabled = NO;
    [_goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLab.right).offset(FitPTScreen(5));
        make.right.equalTo(arrowImgV.left).offset(FitPTScreen(-5));
        make.top.bottom.equalTo(0);
    }];
    
    return goodNameSelectView;
}

@end
