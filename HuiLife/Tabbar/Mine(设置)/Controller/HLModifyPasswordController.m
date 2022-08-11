//
//  HLModifyPasswordController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/24.
//

#import "HLModifyPasswordController.h"
#import "HLTextField.h"
#import "HLTextFieldCheckInputNumberTool.h"
#import "HLLoginController.h"

@interface HLModifyPasswordController ()
@property(strong,nonatomic)NSArray *fieldItems;

@property(strong,nonatomic)NSMutableArray<HLTextField*> *textFields;

@property(strong,nonatomic)HLTextFieldCheckInputNumberTool * tool;

@end

@implementation HLModifyPasswordController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"修改登录密码"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tool = [[HLTextFieldCheckInputNumberTool alloc]init];
    _tool.MAX_STARWORDS_LENGTH = 20;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [cancel setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBar;
    [self createTextField];
    [self createCommitBtn];
}

//点击取消谈框
-(void)cancelClick:(UIButton *)sender{
    [self hl_goback];
}

-(void)createTextField{
    for (int i=0; i<self.fieldItems.count; i++) {
        HLTextField * field = [[HLTextField alloc]initWithImage:self.fieldItems[i][0] placeHolder:self.fieldItems[i][1] funImgNormal:self.fieldItems[i][2] select:self.fieldItems[i][3]];
        field.textField.secureTextEntry = YES;
        field.textField.textColor = UIColorFromRGB(0x999999);
        field.textField.font = [UIFont systemFontOfSize:FitPTScreen(13)];
        [field.textField addTarget:_tool action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:field];
        [self.textFields addObject:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(FitPTScreen(30));
            make.centerX.equalTo(self.view).offset(FitPTScreen(-23));
            make.width.equalTo(FitPTScreen(281));
            make.height.equalTo(FitPTScreenH(30));
            make.top.equalTo(self.view).offset(FitPTScreenH(133)+i*FitPTScreenH(40+21));
        }];
    }
}

-(void)createCommitBtn{
    UIButton *saveButton = [[UIButton alloc] init];
    [self.view addSubview:saveButton];
    [saveButton setTitle:@"提交" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.textFields.lastObject.mas_bottom).offset(FitPTScreen(94));
        make.width.equalTo(FitPTScreen(281));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(commitRequest) forControlEvents:UIControlEventTouchUpInside];
}

-(void)commitRequest{
    for (HLTextField * textField in self.textFields) {
        if ([textField.textField.text isEqualToString:@""]) {
            [HLTools showWithText:[NSString stringWithFormat:@"请输入%@",textField.textField.placeholder]];
            return;
        }else if (![NSString hl_isSafePassword:textField.textField.text]) {
            [HLTools showWithText:@"请输入6-20字母数字或字符"];
            return;
        }
    }
    [self requestModifyPassword];
    
}
-(NSArray *)fieldItems{
    if (!_model) {
    _fieldItems =
  @[
  @[@"",@"请输入原密码",@"",@""],
  @[@"",@"请输入新密码",@"",@""],
  @[@"",@"请确认新密码",@"",@""]
  ];
    }else{
        _fieldItems =@[@[@"",@"请输入新密码",@"",@""],@[@"",@"请确认新密码",@"",@""]];
    }
    return _fieldItems;
}

-(NSMutableArray<HLTextField *> *)textFields{
    if (!_textFields) {
        _textFields = [[NSMutableArray alloc]init];
    }
    return _textFields;
}

#pragma Request
-(void)requestModifyPassword{
    NSDictionary * pargram = @{
                               @"type":@"3",
                               @"opass":self.textFields.firstObject.textField.text?:@"",
                               @"npass": _model?self.textFields.firstObject.textField.text:self.textFields[1].textField.text,
                               @"mpass":self.textFields.lastObject.textField.text?:@"",
                               @"oid":_model?_model.staffID:[HLAccount shared].userid,
                               };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/MessageSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
           [HLTools showWithText:@"修改成功"];
           [HLNotifyCenter postNotificationName:NOTIFY_LOGIN_STATE object:false];
           return;
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

@end
