//
//  HLLoginController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/16.
//

#import "HLLoginController.h"
#import "HLTextField.h"
#import "HLForgetAdminNumController.h"
#import "HLHowFindPassController.h"
#import "HLTextFieldCheckInputNumberTool.h"
#import "JPUSHService.h"
#import "HLApiChangeController.h"
#import "HLNewRegisterController.h"
#import "HLGuideMask.h"
#import "HLImagePickerController.h"

@interface HLLoginController (){
    
    HLTextFieldCheckInputNumberTool * tool;
    NSInteger seq;
}

@property(strong,nonatomic)UIImageView * logoview;
//当前选择的模块
@property(assign,nonatomic)NSInteger currentIndex;
//
@property(strong,nonatomic)UIImageView * switchView;
//
@property(strong,nonatomic)UIButton * adminBtn;

@property(strong,nonatomic)UIButton * YGBtn;

@property(strong,nonatomic)NSArray *fieldItems;

@property(strong,nonatomic)NSMutableArray<HLTextField*> *textFields;

@property(strong,nonatomic)UIButton * loginBtn;
//找回账号
@property(strong,nonatomic)UILabel * forgetNum;

@property(strong,nonatomic)UIImageView * forgetImg;

//1--管理员登录，2员工店长登录
@property(assign,nonatomic)NSInteger type;
@end

@implementation HLLoginController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self createTextField];
    [self createLoginBtn];
#if DEBUG
    [self initChangeApiBtn];
#endif
}

-(void)createUI{
    
    _logoview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo"]];
    [self.view addSubview:_logoview];
    [_logoview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(124));
        make.height.equalTo(FitPTScreen(78));
        make.width.equalTo(FitPTScreen(158));
        make.top.equalTo(self.view.mas_top).offset(FitPTScreenH(95));
    }];
    
    _switchView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"switch_bagview"]];
    _switchView.userInteractionEnabled = YES;
    [self.view addSubview:_switchView];
    [_switchView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoview.mas_bottom).offset(FitPTScreenH(38));
        make.width.equalTo(FitPTScreen(153));
        make.height.equalTo(FitPTScreen(43));
    }];
    
    _adminBtn = [[UIButton alloc]init];
    _adminBtn.tag = 0;
    _currentIndex = 0;
    _type = 1;
    [_adminBtn setTitle:@"管理员" forState:UIControlStateNormal];
    [_adminBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateSelected];
    [_adminBtn setBackgroundImage:[UIImage imageNamed:@"switch_bag"] forState:UIControlStateSelected];
    //select
    [_adminBtn setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
    [_adminBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    _adminBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    
    _adminBtn.selected = YES;
    [_switchView addSubview:_adminBtn];
    
    [_adminBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.switchView);
        make.width.equalTo(FitPTScreen(73));
    }];
    [_adminBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _YGBtn = [[UIButton alloc]init];
    _YGBtn.tag = 1;
    [_YGBtn setTitle:@"员工" forState:UIControlStateNormal];
    [_YGBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_YGBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    [_YGBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateSelected];
    [_YGBtn setBackgroundImage:[UIImage imageNamed:@"switch_bag"] forState:UIControlStateSelected];
    _YGBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    
    
    [_switchView addSubview:_YGBtn];
    [_YGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.height.equalTo(self.switchView);
        make.width.equalTo(FitPTScreen(73));
    }];
    [_YGBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    self.automaticallyAdjustsScrollViewInsets = false;
}

-(void)initChangeApiBtn{
    UIButton * changeBtn = [[UIButton alloc]init];
    [changeBtn setTitle:@"切换网络" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor hl_StringToColor:@"#FF8D26"] forState:UIControlStateNormal];
    changeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:changeBtn];
    [changeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.top.equalTo(FitPTScreen(40));
        make.height.equalTo(FitPTScreenH(40));
        make.width.equalTo(FitPTScreen(80));
    }];
    
    [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeBtnClick{
    HLApiChangeController *apiChange = [[HLApiChangeController alloc] init];
    [self.navigationController pushViewController:apiChange animated:YES];
}

-(NSArray *)fieldItems{
    if (!_fieldItems) {
        if (_currentIndex == 0) {
            _fieldItems =@[@[@"user_number",@"账户／手机号",@"",@""],@[@"user_password",@"密码",@"user_password_isshow",@"user_password_show"]];
        }else{
            _fieldItems =@[@[@"user_number",@"总账号",@"",@""],@[@"user_gonghao",@"工号",@"arrow_down_grey_light",@""],@[@"user_password",@"密码",@"user_password_isshow",@"user_password_show"]];
        }
    }
    return _fieldItems;
}

-(NSMutableArray<HLTextField *> *)textFields{
    if (!_textFields) {
        _textFields = [[NSMutableArray alloc]init];
    }
    return _textFields;
}

-(void)switchClick:(UIButton *)sender{
    _currentIndex =sender.tag;
    _type = _currentIndex +1;
    _adminBtn.selected= _adminBtn.tag == sender.tag;
    _YGBtn.selected= _YGBtn.tag == sender.tag;
    //一边遍历数组一边修改数组会导致崩溃
    for (HLTextField * field in self.textFields) {
        [field removeFromSuperview];
    }
    [self.textFields removeAllObjects];
    _fieldItems = nil;
    [_loginBtn removeFromSuperview];
    [_forgetNum removeFromSuperview];
    [_forgetImg removeFromSuperview];
    [self createTextField];
    [self createLoginBtn];
}

-(void)createTextField{
    tool = [[HLTextFieldCheckInputNumberTool alloc]init];
    for (int i=0; i<self.fieldItems.count; i++) {
        HLTextField * field = [[HLTextField alloc] initWithImage:self.fieldItems[i][0] placeHolder:self.fieldItems[i][1] funImgNormal:self.fieldItems[i][2] select:self.fieldItems[i][3]];
        field.isPassword = i== self.fieldItems.count-1;
        if (i == 0) {
            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        [self.view addSubview:field];
        [self.textFields addObject:field];
        if (i==self.fieldItems.count - 1) {
            tool.MAX_STARWORDS_LENGTH = 20;
            [field.textField addTarget:tool action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        }
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(FitPTScreen(285));
            make.height.equalTo(FitPTScreenH(30));
            make.top.equalTo(self.switchView.mas_bottom).offset(FitPTScreenH(30+i*(30+21)));
        }];
    }
}

-(void)createLoginBtn{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(150), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    _loginBtn = [[UIButton alloc] init];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.backgroundColor = UIColor.whiteColor;
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_bg"] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_bg"] forState:UIControlStateSelected];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    
    _forgetNum = [[UILabel alloc]init];
    _forgetNum.text = @"找回管理员账号";
    _forgetNum.textColor = UIColorFromRGB(0xFF9F23);
    _forgetNum.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _forgetNum.userInteractionEnabled = YES;
    [self.view addSubview:_forgetNum];
    [_forgetNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textFields.lastObject.mas_bottom).offset(FitPTScreen(10));
        make.left.equalTo(self.view).offset(FitPTScreen(239));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_forgetNum addGestureRecognizer:tap];
    
    _forgetImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ask_red"]];
    _forgetImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    [_forgetImg addGestureRecognizer:tapImg];
    [self.view addSubview:_forgetImg];
    [_forgetImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forgetNum.mas_right).offset(FitPTScreen(5));
        make.centerY.equalTo(self.forgetNum);
    }];
    
    if(isPad) {return;}
    UILabel * registerLb = [[UILabel alloc]init];
    registerLb.text = @"还没有账户 立即注册";
    registerLb.textAlignment = NSTextAlignmentCenter;
    registerLb.textColor = UIColorFromRGB(0xFF9F23);
    registerLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    registerLb.userInteractionEnabled = YES;
    [footView addSubview:registerLb];
    [registerLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.bottom);
        make.centerX.equalTo(self.loginBtn);
        make.height.equalTo(FitPTScreen(20));
    }];
    UITapGestureRecognizer *registerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerBtnClick)];
    [registerLb addGestureRecognizer:registerTap];
    
    UIImageView * arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_oriange"]];
    [footView addSubview:arrow];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerLb.right).offset(FitPTScreen(5));
        make.centerY.equalTo(registerLb);
    }];
}

- (void)registerBtnClick{
    HLNewRegisterController *registerVC = [[HLNewRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)login:(UIButton *)sender{
    for (int i = 0; i<self.textFields.count; i++) {
        HLTextField * textField = self.textFields[i];
        if ([textField.textField.text isEqualToString:@""]) {
            [HLTools showWithText:[NSString stringWithFormat:@"请输入%@",textField.textField.placeholder]];
            return;
        }
    }
    if (self.textFields.lastObject.textField.text.length < 6) {
        [HLTools showWithText:@"密码6-20位"];
        return;
    }
    
    [self loginRequest];
}

//登录请求
-(void)loginRequest{
    NSDictionary * pargram =@{
                              @"userName":[self.textFields[0] configeText],
                              @"passWord":[self.textFields.lastObject configeText],
                              @"workNum":_type==1?@"":[self.textFields[1] configeText],
                              @"type":@(_type)
                              };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/MerchantSideSetting.php";
        request.serverType = HLServerTypeNormal;
        request.parameters =pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSDictionary * dict =((NSArray *)result.data).firstObject;
            
            HLAccount *account = [HLAccount shared];
            [account mj_setKeyValues:dict];
            [HLAccount saveAcount];
            //设置推送标签
            [self configJPushTags];
            //登录
            [HLNotifyCenter postNotificationName:NOTIFY_LOGIN_STATE object:@(YES)];
            
            // 清空引导图存储的信息
            [HLGuideMask cleanStep1ShowFlag];
            [HLGuideMask cleanStep2ShowFlag];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


- (void)configJPushTags {
    HLAccount *account = [HLAccount shared];
    NSMutableArray * tags = [NSMutableArray arrayWithArray:account.push_store_id];
    [tags addObject:account.lmpt_userid];
    NSMutableSet * tagsSet = [[NSMutableSet alloc] init];
    [tagsSet addObjectsFromArray:tags];
    [JPUSHService setTags:tagsSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        HLLog(@"iTags = %@",iTags);
    } seq:[self seq]];
}

- (NSInteger)seq {
    return ++ seq;
}

- (void)tap:(UITapGestureRecognizer *)sender{
    HLForgetAdminNumController * forgetVc = [[HLForgetAdminNumController alloc]init];
    [self hl_pushToController:forgetVc];
}

- (void)tapImg:(UITapGestureRecognizer *)sender{
    HLHowFindPassController * findVc = [[HLHowFindPassController alloc]init];
    [self hl_pushToController:findVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
