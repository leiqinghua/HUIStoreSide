//
//  HLHeXiaoPassSetController.m
//  HuiLife
//
//  Created by 王策 on 2019/9/4.
//

#import "HLHeXiaoPassSetController.h"

@interface HLHeXiaoPassSetController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *controlBtn;

@end

@implementation HLHeXiaoPassSetController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"密码管理"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
    [self loadData];
}

- (void)creatSubViews{
    UIView *inputView = [[UIView alloc] init];
    [self.view addSubview:inputView];
    [inputView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(50));
        make.top.equalTo(Height_NavBar);
    }];
    
    UIView *line = [[UIView alloc] init];
    [inputView addSubview:line];
    line.backgroundColor = SeparatorColor;
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.right.bottom.equalTo(0);
        make.height.equalTo(0.7);
    }];
    
    UILabel *leftTipLab = [[UILabel alloc] init];
    [inputView addSubview:leftTipLab];
    leftTipLab.text = @"核销密码";
    leftTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    leftTipLab.textColor = UIColorFromRGB(0x333333);
    [leftTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView);
        make.left.equalTo(FitPTScreen(14));
    }];
    
    _controlBtn = [[UIButton alloc] init];
    [inputView addSubview:_controlBtn];
    [_controlBtn setImage:[UIImage imageNamed:@"user_password_isshow"] forState:UIControlStateNormal];
    [_controlBtn setImage:[UIImage imageNamed:@"user_password_show"] forState:UIControlStateSelected];
    [_controlBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(0);
        make.width.equalTo(FitPTScreen(50));
    }];
    [_controlBtn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _textField = [[UITextField alloc] init];
    [inputView addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.textColor = UIColorFromRGB(0x333333);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.placeholder = @"请输入核销密码";
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.secureTextEntry = YES;
    _textField.tintColor = UIColorFromRGB(0xff8717);
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(FitPTScreen(80));
        make.right.equalTo(_controlBtn.left).offset(FitPTScreen(0));
    }];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [self.view addSubview:saveButton];
    [saveButton setTitle:@"保存设置" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(FitPTScreen(-13) - Height_Bottom_Margn);
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSideA/BusinessHxpsd.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            _textField.text = responseObject.data[@"passwd"] ?:@"";
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self saveButtonClick];
    return YES;
}

- (void)saveButtonClick{
    
    [self.view endEditing:YES];
    
    NSString *text = _textField.text;
    if (text.length == 0) {
        HLShowHint(@"请输入核销密码", self.view);
        return;
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSideA/BusinessHxpsdSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"psd":text};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            HLShowText(@"保存成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

- (void)controlBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    _textField.secureTextEntry = !sender.selected;
}

@end
