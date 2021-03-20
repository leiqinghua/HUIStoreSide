//
//  HLCardSecretController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/25.
//

#import "HLCardSecretController.h"
#import "HLExportRecordController.h"
#import "HLStatuAlert.h"
#import "HLCardRecordController.h"

@interface HLCardSecretController () <UITextFieldDelegate>
@property(nonatomic, strong) UILabel *nameLb ;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIButton *oneBtn;
@property(nonatomic, strong) UIButton *twoBtn;
//推荐的数量
@property(nonatomic, strong) NSArray *commendNums;
@property(nonatomic, copy) NSString *selectNum;
@property(nonatomic, assign) NSInteger cardNum;
@property(nonatomic, assign) NSInteger cardUse;

@property(nonatomic, strong) UILabel *tipLb;
@property(nonatomic, strong) UILabel *contentLb;
@end

@implementation HLCardSecretController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"生成卡密"];
    [self hl_setBackImage:@"back_black"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultData:NO];
}

#pragma mark - Request
- (void)loadDefaultData:(BOOL)update {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/SecretHome.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"cardId":_cardId};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (!update) {
                [self initSubView];
                self.nameLb.text = result.data[@"cardName"];
                self.commendNums = result.data[@"recommend"];
                self.cardNum = [result.data[@"cardNum"] integerValue];
                self.cardUse = [result.data[@"cardUse"] integerValue];
                NSString *oneStr = [NSString stringWithFormat:@"%@张",self.commendNums.firstObject];
                NSString *twoStr = [NSString stringWithFormat:@"%@张",self.commendNums.lastObject];
                [self.oneBtn setTitle:oneStr forState:UIControlStateNormal];
                [self.twoBtn setTitle:twoStr forState:UIControlStateNormal];
                [self numClick:self.oneBtn];
            }
            self.contentLb.text = @"";
            self.contentLb.attributedText = [self contentAttrWithContent:result.data[@"action"]];
            self.tipLb.hidden = !self.contentLb.text.length;
            self.contentLb.hidden = !self.contentLb.text.length;
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)createSecreat {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/SecretCreate.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"cardId":_cardId,@"cardNum":self.selectNum};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSString *message = [NSString stringWithFormat:@"成功生成%@张\n请前往生成记录下载",self.selectNum];
            [HLStatuAlert showWithStatuPic:@"success" message:message callBack:^(void){
                [self loadDefaultData:YES];
            }];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


#pragma mark -Event
//立即生成
- (void)productClick {
    if (!self.selectNum.integerValue) {
        [HLTools showWithText:@"生成数量必须大于零"];
        return;
    }
    
    NSInteger enableNum = self.cardNum - self.cardUse;
    if (self.selectNum.integerValue > enableNum) {
        [HLTools showWithText:[NSString stringWithFormat:@"最多可生成%ld条记录",enableNum]];
        return;
    }
    [_textField resignFirstResponder];
    [self createSecreat];
}

- (void)numClick:(UIButton *)sender {
    _twoBtn.selected = sender.tag == 1001;
    _oneBtn.selected = sender.tag == 1000;
    _textField.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _textField.textColor = UIColorFromRGB(0x222222);
    [self configSelect:_twoBtn];
    [self configSelect:_oneBtn];
    if (sender.tag == 1000) {
        self.selectNum = self.commendNums.firstObject;
        return;
    }
    self.selectNum = self.commendNums.lastObject;
}

//生成记录
- (void)exportClick {
    HLCardRecordController *exportVC = [[HLCardRecordController alloc]init];
    [self.navigationController pushViewController:exportVC animated:YES];
}

- (void)configSelect:(UIButton *)sender {
    if (sender.selected) {
        sender.layer.borderColor = UIColorFromRGB(0xFD9E30).CGColor;
    } else {
        sender.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    }
}

#pragma mark - Method
- (NSAttributedString *)contentAttrWithContent:(NSString *)content {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 3;
    NSAttributedString *contentAttr = [[NSAttributedString alloc]initWithString:content attributes:@{NSParagraphStyleAttributeName:style}];
    return contentAttr;
}

#pragma mark - UITextFieldDelegate
//开始编辑
- (void)textFieldEditing:(UITextField *)textField {
    self.selectNum = textField.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.oneBtn.selected = NO;
    self.twoBtn.selected = NO;
    [self configSelect:_oneBtn];
    [self configSelect:_twoBtn];
    textField.layer.borderColor = UIColorFromRGB(0xFD9E2F).CGColor;
    textField.textColor = UIColorFromRGB(0xFD9E2F);
    self.selectNum = textField.text;
}

#pragma mark - UIView
- (void)initSubView {
    
    UIButton *exportBtn = [UIButton hl_regularWithTitle:@"生成记录" titleColor:@"#FE9E30" font:14 image:@""];
    UIBarButtonItem *exportItem = [[UIBarButtonItem alloc]initWithCustomView:exportBtn];
    self.navigationItem.rightBarButtonItem = exportItem;
    [exportBtn addTarget:self action:@selector(exportClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bagView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(205))];
    bagView.backgroundColor = UIColor.whiteColor;
    self.view.backgroundColor = UIColorFromRGB(0xf5f6f9);
    [self.view addSubview:bagView];
    
    UILabel *tipLb = [UILabel hl_singleLineWithColor:@"#222222" font:17 bold:YES];
    tipLb.text = @"在线生成";
    [bagView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(24));
    }];
    
    UILabel *nameTipLb = [UILabel hl_regularWithColor:@"#666666" font:14];
    nameTipLb.text = @"HUI卡名称";
    [bagView addSubview:nameTipLb];
    [nameTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(tipLb.bottom).offset(FitPTScreen(30));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    [bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(nameTipLb);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(nameTipLb.bottom).offset(FitPTScreen(15));
        make.height.equalTo(0.5);
    }];
    
    UILabel *numTipLb = [UILabel hl_regularWithColor:@"#666666" font:13];
    numTipLb.text = @"生成数量";
    [bagView addSubview:numTipLb];
    [numTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(line.bottom).offset(FitPTScreen(19));
    }];
    
    _oneBtn = [UIButton hl_regularWithTitle:@"1000张" titleColor:@"#222222" font:14 image:@""];
    [_oneBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [_oneBtn setTitleColor:UIColorFromRGB(0xFD9E2F) forState:UIControlStateSelected];
    _oneBtn.backgroundColor = UIColor.whiteColor;
    _oneBtn.layer.cornerRadius = FitPTScreen(3);
    _oneBtn.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _oneBtn.layer.borderWidth = 0.5;
    _oneBtn.tag = 1000;
    [bagView addSubview:_oneBtn];
    [_oneBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12.5));
        make.top.equalTo(numTipLb.bottom).offset(FitPTScreen(9));
        make.size.equalTo(CGSizeMake(FitPTScreen(93), FitPTScreen(40)));
    }];
    
    _twoBtn = [UIButton hl_regularWithTitle:@"2000张" titleColor:@"#222222" font:14 image:@""];
    [_twoBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [_twoBtn setTitleColor:UIColorFromRGB(0xFD9E2F) forState:UIControlStateSelected];
    _twoBtn.backgroundColor = UIColor.whiteColor;
    _twoBtn.layer.cornerRadius = FitPTScreen(3);
    _twoBtn.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _twoBtn.layer.borderWidth = 0.5;
    _twoBtn.tag = 1001;
    [bagView addSubview:_twoBtn];
    [_twoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.oneBtn.right).offset(FitPTScreen(13));
        make.centerY.equalTo(self.oneBtn);
        make.size.equalTo(CGSizeMake(FitPTScreen(93), FitPTScreen(40)));
    }];
    [self.oneBtn addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoBtn addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _textField = [[UITextField alloc]init];
    _textField.backgroundColor = UIColor.whiteColor;
    _textField.layer.cornerRadius = FitPTScreen(3);
    _textField.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.placeholder = @"自定义";
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.textColor = UIColorFromRGB(0x222222);
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.tintColor = UIColorFromRGB(0xFD9E30);
    _textField.delegate = self;
    [bagView addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12.5));
        make.centerY.equalTo(self.oneBtn);
        make.size.equalTo(CGSizeMake(FitPTScreen(138), FitPTScreen(40)));
    }];
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIButton *productBtn = [[UIButton alloc] init];
    [self.view addSubview:productBtn];
    [productBtn setTitle:@"立即生成" forState:UIControlStateNormal];
    productBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [productBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [productBtn setBackgroundImage:[UIImage imageNamed:@"button_bag"] forState:UIControlStateNormal];
    [productBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(bagView.bottom).offset(FitPTScreen(40));
    }];
    [productBtn addTarget:self action:@selector(productClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tipLb = [[UILabel alloc]init];
    _tipLb.text = @"注意事项";
    _tipLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(17)];
    _tipLb.textColor = UIColorFromRGB(0x666666);
    [self.view addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(productBtn.bottom).offset(FitPTScreen(20));
    }];
    
    _contentLb = [[UILabel alloc]init];
    _contentLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _contentLb.textColor = UIColorFromRGB(0x666666);
    _contentLb.numberOfLines = 0;
    [self.view addSubview:_contentLb];
    [_contentLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(_tipLb.bottom).offset(FitPTScreen(10));
    }];
}

@end
