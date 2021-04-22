//
//  HLNewRegisterController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/27.
//

#import "HLNewRegisterController.h"
#import "HLInfoModel.h"
#import "HLRegisterViewCell.h"
#import "HLSuccessView.h"
#import "HLAreaSelectView.h"
#import "HLCityJsonManager.h"

@interface HLNewRegisterController ()<UITableViewDelegate,UITableViewDataSource,HLRegisterViewCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSArray * datasource;

@property(nonatomic,strong)NSMutableDictionary * pargram;

@property(nonatomic,strong)HLInfoModel * phoneInfo;

@property(nonatomic,strong)HLInfoModel * city;

//注册协议url
@property(nonatomic,copy)NSString * protocolUrl;

/// 缓存的地区数据
@property (nonatomic, copy) NSArray *cacheAreaArr;

@end

@implementation HLNewRegisterController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"商户注册"];
}


-(void)registerClick{
    
    for (HLInfoModel * model in self.datasource) {
        if (model.needCheckParams && ![model checkParamsIsOk]) {
            HLShowHint(model.errorHint, self.view);
            return;
        }
        if (model.key.length) {
            [self.pargram setObject:model.text forKey:model.key];
        }
        
        if (model.pargram.count) {
            [self.pargram addEntriesFromDictionary:model.pargram];
        }
    }
    HLLog(@"pargram = %@",self.pargram);
    
    [self registerRequest];
}

//协议
- (void)protocolClick {
//   url
    HLBaseWebviewController *protocolVC = [[HLBaseWebviewController alloc]init];
    protocolVC.loadUrl = self.protocolUrl;
    [protocolVC resetWebViewFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    [protocolVC setWebViewTitle:@"注册协议"];
    [protocolVC setProgressFrame:CGRectMake(0, Height_NavBar, ScreenW, 0)];
    [self hl_pushToController:protocolVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self creatFootView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 135)];
    _tableView.tableHeaderView = headerView;
    
    UIImageView * logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo"]];
    [headerView addSubview:logoView];
    [logoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(123));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    
    [[HLLocationManager shared] startLocationWithCallBack:^(BMKLocation *location) {
        if (location) {
            CLLocation *clLocation = location.location;
            NSDictionary *params = @{
                                     @"province":location.rgcData.province?:@"",
                                     @"city":location.rgcData.city?:@"",
                                     @"district":location.rgcData.district?:@"",
                                     @"street":location.rgcData.street?:@"",
                                     @"streetNumber":location.rgcData.streetNumber?:@"",
                                     @"cityCode":location.rgcData.cityCode?:@"",
                                     @"adCode":location.rgcData.adCode?:@"",
                                     @"latitude":@(clLocation.coordinate.latitude),
                                     @"longitude":@(clLocation.coordinate.longitude),
                                     @"type":@"1"
                                     };
            [self loadCityDataWithLocationParams:params];
        }
    }];
    
}


/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"立即注册" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *protocolBtn = [[UIButton alloc]init];
    [protocolBtn setImage:[UIImage imageNamed:@"single_ring_normal"] forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [protocolBtn setAttributedTitle:[self protocolAttr] forState:UIControlStateNormal];
    [footView addSubview:protocolBtn];
    [protocolBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(saveButton);
        make.top.equalTo(saveButton.bottom).offset(-10);
    }];
    [protocolBtn addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
    
}


- (NSAttributedString *)protocolAttr {
    NSString *text = @"  注册即表示您已阅读并同意《商+号注册协议》";
    NSRange range = [text rangeOfString:@"《商+号注册协议》"];
    NSMutableAttributedString *muttr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xC2C2C2)}];
    [muttr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFFAA2F)} range:range];
    return muttr;
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLRegisterViewCell * cell = [HLRegisterViewCell dequeueReusableCell:tableView];
    cell.infoModel = self.datasource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLInfoModel * model = self.datasource[indexPath.row];
    return model.cellHight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView endEditing:YES];
    HLInfoModel * model = self.datasource[indexPath.row];
    if ([model.leftText isEqualToString:@"商户城市"]) {
        [HLCityJsonManager loadAreaDataWithController:self callBack:^(NSArray *cityData) {
            [HLAreaSelectView showCurrentSelectArea:@"" areas:cityData type:1 callBack:^(NSString *province, NSString *city, NSString *area, NSString *proId, NSString *cityId, NSString *areaId) {
                model.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,area];
                model.pargram = @{@"country_code":areaId};
                [self.tableView reloadData];
            }];
        }];
    }
}

#pragma mark - HLRegisterViewCellDelegate
-(void)yzmClickWithInfo:(HLInfoModel *)info sender:(UIButton *)sender{
    if (!self.phoneInfo.text.length) {
        HLShowHint(@"请输入手机号", self.view);
        return;
    }
    [self yzmRequestWithButton:sender];
}


/// 加载地区的数据
- (void)loadAreaDataWithCallBack:(void(^)(NSArray *areaArr))callBack{
    if (self.cacheAreaArr.count) {
        callBack(self.cacheAreaArr);
        return;
    }
}


-(void)timeOutWithButton:(UIButton *)sender{
    //60秒倒计时
    __block int timeout = 60;
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    //触发时间间隔1s，误差0s
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    weakify(self);
    dispatch_source_set_event_handler(timer, ^{
        //2.对timeout进行判断时间是停止倒计时，还是修改button的title
        if (timeout < 1) {
            //关闭定时器
            dispatch_source_cancel(timer);
            //在主线程中对button进行修改操作
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                sender.enabled = YES;
            });
        }else {
            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.enabled = false;
                [sender setTitle:[NSString stringWithFormat:@"%ds后重发",timeout] forState:UIControlStateNormal];
            });
        }
        timeout --;
    });
    
    dispatch_resume(timer);
}

-(void)yzmRequestWithButton:(UIButton *)sender{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/ShortMessageBusi.php";
        request.serverType = HLServerTypeNormal;
        request.parameters =@{@"messageType":@"4",@"mobile":self.phoneInfo.text};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self timeOutWithButton:sender];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)registerRequest{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/BusinessReg.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [HLSuccessView registerSuccessWithCompletion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


-(void)loadCityDataWithLocationParams:(NSDictionary *)params{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/cityGps.php";
        request.serverType = HLServerTypeNormal;
        request.hideError = YES;
        request.parameters = params;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            NSDictionary * dict = result.data;
            if (dict.count) {
                if(dict[@"areaId"]){
                    self.city.text = [NSString stringWithFormat:@"%@-%@-%@",dict[@"province"],dict[@"city"],dict[@"area"]];
                    self.city.pargram = @{@"country_code":dict[@"areaId"]?:@""};
                }
                self.protocolUrl = dict[@"url"];
                [self.tableView reloadData];
            }
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - SET&GET

-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}

-(NSArray *)datasource{
    if (!_datasource) {
        HLInfoModel * name = [[HLInfoModel alloc]init];
        name.leftPic = @"store_oriange";
        name.leftText = @"商户名称";
        name.placeHolder = @"请输入商户名称";
        name.key = @"company";
        name.errorHint = @"请输入商户名称";
        name.needCheckParams = YES;
        
        HLInfoModel * city = [[HLInfoModel alloc]init];
        city.leftPic = @"store_locate";
        city.leftText = @"商户城市";
        city.placeHolder = @"请选择商户所在城市";
        city.canInput = false;
        city.showArrow = YES;
        city.errorHint = @"请选择商户所在城市";
        city.needCheckParams = YES;
        _city = city;
        
        HLInfoModel * phone = [[HLInfoModel alloc]init];
        phone.leftPic = @"store_phone";
        phone.leftText = @"手机号";
        phone.placeHolder = @"请输入手机号";
        phone.keyboardType = UIKeyboardTypePhonePad;
        phone.phone = YES;
        phone.cellHight = FitPTScreen(77);
        phone.key = @"mobile";
        _phoneInfo = phone;
        phone.errorHint = @"请输入手机号";
        phone.needCheckParams = YES;
        
        HLInfoModel * yzm = [[HLInfoModel alloc]init];
        yzm.leftPic = @"yzm";
        yzm.leftText = @"验证码";
        yzm.placeHolder = @"请输入手机验证码";
        yzm.type = HLInfoModelYZM;
        yzm.keyboardType = UIKeyboardTypePhonePad;
        yzm.errorHint = @"请输入手机验证码";
        yzm.needCheckParams = YES;
        yzm.key = @"verifi_code";
        
        HLInfoModel * pass = [[HLInfoModel alloc]init];
        pass.leftPic = @"user_password";
        pass.leftText = @"账户密码";
        pass.type = HLInfoCollegePassword;
        pass.placeHolder = @"请输入账户密码";
        pass.key = @"passwd";
        pass.errorHint = @"请输入账户密码";
        pass.needCheckParams = YES;
        pass.entry = YES;
        
        HLInfoModel * modifyPass = [[HLInfoModel alloc]init];
        modifyPass.leftPic = @"user_password";
        modifyPass.leftText = @"验证账户密码";
        modifyPass.type = HLInfoCollegePassword;
        modifyPass.placeHolder = @"请再次输入账户密码";
        modifyPass.errorHint = @"请再次输入账户密码";
        modifyPass.needCheckParams = YES;
        modifyPass.entry = YES;
        _datasource = @[name,city,phone,yzm,pass,modifyPass];
    }
    return _datasource;
}

@end
