//
//  HLForgetAdminNumController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/17.
//

#import "HLForgetAdminNumController.h"
#import "HLTextField.h"

@interface HLForgetAdminNumController (){
    dispatch_source_t _timer;
    
}
@property(strong,nonatomic)NSArray *fieldItems;

@property(strong,nonatomic)NSMutableArray<HLTextField*> *textFields;

@property(strong,nonatomic)UIButton * commit;

@property(strong,nonatomic)UITextField *textField;

@property(strong,nonatomic)UIButton * yzmBtn ;
@end

@implementation HLForgetAdminNumController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setTitle:@"找回管理员账号"];
    [self hl_interactivePopGestureRecognizerUseable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTextField];
    [self createCommitBtn];
}

-(void)createTextField{
    for (int i=0; i<self.fieldItems.count; i++) {
        HLTextField * field = [[HLTextField alloc]initWithImage:self.fieldItems[i][0] placeHolder:self.fieldItems[i][1] funImgNormal:self.fieldItems[i][2] select:self.fieldItems[i][3]];
        field.isPassword = i == self.fieldItems.count - 1;
        [self.view addSubview:field];
        [self.textFields addObject:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(FitPTScreen(46));
            make.width.equalTo(FitPTScreen(285));
            make.height.equalTo(FitPTScreenH(30));
            make.top.equalTo(self.view).offset(FitPTScreenH(128+i*(30+30)));
        }];
    }
    UIImageView * titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yanzhengma"]];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(FitPTScreen(46));
        make.top.equalTo(self.textFields[1].mas_bottom).offset(FitPTScreenH(30));
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.placeholder = @"短信验证码";
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_right).offset(FitPTScreen(15));
        make.centerY.equalTo(titleView);
        make.width.equalTo(FitPTScreen(165));
        make.height.equalTo(FitPTScreen(30));
    }];
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField);
        make.bottom.equalTo(self.textField);
        make.height.equalTo(FitPTScreen(0.5));
        make.width.equalTo(FitPTScreen(165));
    }];

    _yzmBtn = [[UIButton alloc]init];
    [_yzmBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_yzmBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
    [_yzmBtn.layer setBorderWidth:1];
    [_yzmBtn.layer setBorderColor:UIColorFromRGB(0xFF8D26).CGColor];
    _yzmBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(10)];
    _yzmBtn.layer.cornerRadius = FitPTScreenH(3);
    [self.view addSubview:_yzmBtn];
    [_yzmBtn addTarget:self action:@selector(yanzhengma:) forControlEvents:UIControlEventTouchUpInside] ;
    [_yzmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.textField.mas_right).offset(FitPTScreen(16));
        make.centerY.equalTo(self.textField);
        make.height.equalTo(FitPTScreenH(25));
        make.width.equalTo(FitPTScreen(70));
    }];
    
    [self.textFields[2] updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(FitPTScreenH(128+3*(30+30)));
    }];
}

-(void)createCommitBtn{
    _commit = [[UIButton alloc]init];
    [_commit setTitle:@"提交" forState:UIControlStateNormal];
    _commit.backgroundColor = UIColorFromRGB(0xFF8D26);
    [_commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commit.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
    _commit.layer.cornerRadius = 6;
    [self.view addSubview:_commit];
    [_commit addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    [_commit makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(FitPTScreen(283));
        make.height.equalTo(FitPTScreenH(40));
        make.top.equalTo(self.textFields.lastObject.mas_bottom).offset(FitPTScreenH(50));
    }];
    
}

-(void)commitClick:(UIButton *)sender{
    for (int i = 0; i<self.textFields.count-1; i++) {
        if (![self.textFields[i].textField.text hl_isAvailable]) {
            [HLTools showWithText:[NSString stringWithFormat:@"请输入%@",self.textFields[i].textField.placeholder]];
             return;
        }
        if (i==1&&[self.textFields[1].textField.text hl_isAvailable] && ![self.textFields[1].textField.text isPhoneNum]) {
            [HLTools showWithText:[NSString stringWithFormat:@"请输入正确的%@",self.textFields[1].textField.placeholder]];
            return;
        }
    }
    if (![_textField.text hl_isAvailable]) {
        [HLTools showWithText:@"请获取验证码"];
        return;
    }
    if (![self.textFields.lastObject.textField.text hl_isAvailable]) {
        [HLTools showWithText:[NSString stringWithFormat:@"请输入%@",self.textFields.lastObject.textField.placeholder]];
        return;
    }
    weakify(self);
    [self requestDataWithType:@"1" success:^(id data) {
        dispatch_source_cancel(self->_timer);
        [weak_self hl_goback];
    } fail:nil];
}

-(void)yanzhengma:(UIButton *)sender{
    if (![self.textFields.firstObject.textField.text hl_isAvailable]) {
        [HLTools showWithText:[NSString stringWithFormat:@"请输入%@",self.textFields.firstObject.textField.placeholder]];
        return;
    }if (![self.textFields[1].textField.text hl_isAvailable]) {
        [HLTools showWithText:[NSString stringWithFormat:@"请输入%@",self.textFields[1].textField.placeholder]];
        return;
    }if ([self.textFields[1].textField.text hl_isAvailable] && ![self.textFields[1].textField.text isPhoneNum]) {
        [HLTools showWithText:[NSString stringWithFormat:@"请输入正确的%@",self.textFields[1].textField.placeholder]];
        return;
    }
    [self.view endEditing:YES];
    weakify(self);
    [self requestDataWithType:@"2" success:^(id data) {
       [weak_self.textField becomeFirstResponder];
       [weak_self yanzhengmaliu:sender];
    } fail:nil];
}

- (void)yanzhengmaliu:(UIButton *)sender{
    sender.enabled = NO;
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                sender.enabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:[NSString stringWithFormat:@"重新发送%@",strTime] forState:UIControlStateDisabled];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(NSArray *)fieldItems{
    if (!_fieldItems) {
        _fieldItems =@[@[@"user_number",@"总账号",@"",@""],@[@"forget_iphone",@"注册手机号",@"",@""],@[@"user_password",@"重置密码",@"user_password_isshow",@"user_password_show"]];
    }
    return _fieldItems;
}
-(NSMutableArray<HLTextField *> *)textFields{
    if (!_textFields) {
        _textFields = [[NSMutableArray alloc]init];
    }
    return _textFields;
}

#pragma mark - Request
//type=2:获取验证码  1：提交并修改密码
-(void)requestDataWithType:(NSString *)type success:(void(^)(id ))success fail:(void(^)(id))fail{
    NSDictionary * pargram = @{
                               @"username":self.textFields.firstObject.textField.text,
                               @"mobile":self.textFields[1].textField.text,
                               @"type":type,
                               @"code":_textField.text,
                               @"password":self.textFields.lastObject.textField.text
                               };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/FindPassword.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            if (success) success(result.data);
            [HLTools showWithText:type.integerValue == 2?@"获取验证码成功":@"重置密码成功"];
            return ;
        }
        if (fail) fail(result.data);
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
