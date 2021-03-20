//
//  HLVoucherSearchView.m
//  HuiLife
//
//  Created by 王策 on 2019/9/4.
//

#import "HLVoucherSearchView.h"

@interface HLVoucherSearchView () <UITextFieldDelegate>

@property (nonatomic, copy) UITextField *textField;

@property (nonatomic, strong) UIButton *searchBtn;

@end

@implementation HLVoucherSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    UILabel *tipLab = [[UILabel alloc] init];
    [self addSubview:tipLab];
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.text = @"网点查询";
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.centerY.equalTo(self);
    }];
    
    _searchBtn = [[UIButton alloc] init];
    [self addSubview:_searchBtn];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"voucher_searc_bg"] forState:UIControlStateNormal];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(104));
        make.top.bottom.equalTo(0);
    }];
    [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    bgView.layer.cornerRadius = FitPTScreen(5);
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = UIColorFromRGB(0xEFEFEF).CGColor;
    bgView.layer.masksToBounds = YES;
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLab.right).offset(FitPTScreen(20));
        make.centerY.equalTo(self);
        make.height.equalTo(FitPTScreen(38));
        make.right.equalTo(_searchBtn.left).offset(FitPTScreen(0));
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    [bgView addSubview:textField];
    textField.placeholder = @"请输入关键字";
    textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    textField.textColor = UIColorFromRGB(0x333333);
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-5));
    }];
    _textField = textField;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.delegate) {
        [self.delegate searchBtnClickWithSearchView:self];
    }
    return YES;
}

- (void)searchBtnClick{
    if (self.delegate) {
        [self.delegate searchBtnClickWithSearchView:self];
    }
}

- (void)configSearchBtnEnabled:(BOOL)enable{
    _searchBtn.userInteractionEnabled = enable;
    [_searchBtn setBackgroundImage:[UIImage imageNamed:enable ? @"voucher_searc_bg" : @"voucher_search_noenable"] forState:UIControlStateNormal];
}

- (NSString *)searchWord{
    return _textField.text ?:@"";
}

- (void)clearSearchWord{
    _textField.text = @"";
}


@end
