//
//  HLAddYGViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/20.
//

#import "HLAddYGViewController.h"
#import "HLModifyPasswordController.h"
#import "HLSelectMDViewController.h"
#import "HLStaffDetailModel.h"
#import "HLStaffDetailTableViewCell.h"

@interface HLAddYGViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIButton *addBtn;
}

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSDictionary * defaultInfo;
//数据源
@property (strong,nonatomic)NSMutableArray * dataSource;

@property (strong,nonatomic)HLStaffDefaultModel * defaultModel;

@property (strong,nonatomic)NSMutableDictionary * pargram;

@end

@implementation HLAddYGViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:_isAdd?@"添加员工":@"员工详情"];
    [self hl_hideBack:YES];
    self.navigationItem.hidesBackButton = YES;
    addBtn.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    addBtn.hidden = YES;
}

#pragma mark - SET && GET
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}

//处理请求回的默认值
- (void)dealDatasWithModel:(id)datas{
    NSDictionary * data =((NSArray *)datas).firstObject;
    _defaultModel = [HLStaffDefaultModel mj_objectWithKeyValues:data];
    
    HLStaffDetailModel *adminModel = [[HLStaffDetailModel alloc]initWithText:@"工号" holder:@"工号" type:HLDefaultType];
    adminModel.canEdit = _isAdd;
    adminModel.showGoImg = false;
    adminModel.value = _defaultModel.user_name;
    adminModel.showText = _defaultModel.user_name;
    adminModel.input_num = 10;
    adminModel.pargram = @{@"user_name":adminModel.value};
    [self.pargram addEntriesFromDictionary:adminModel.pargram];
    
    HLStaffDetailModel *nameModel = [[HLStaffDetailModel alloc]initWithText:@"姓名" holder:@"姓名" type:HLDefaultType];
    nameModel.canEdit = YES;
    nameModel.showGoImg = false;
    nameModel.value = _defaultModel.name;
    nameModel.showText = _defaultModel.name;
    nameModel.input_num = 20;
    nameModel.pargram = @{@"name":nameModel.value};
    [self.pargram addEntriesFromDictionary:nameModel.pargram];
    
    HLStaffDetailModel *phoneModel = [[HLStaffDetailModel alloc]initWithText:@"联系电话" holder:@"请输入员工联系电话" type:HLDefaultType];
    phoneModel.canEdit = YES;
    phoneModel.showGoImg = false;
    phoneModel.value = _defaultModel.mobile;
    phoneModel.showText = _defaultModel.mobile;
    phoneModel.fieldType = HLTextFieldPhoneType;
    phoneModel.input_num = 11;
    phoneModel.pargram = @{@"mobile":phoneModel.value};
    [self.pargram addEntriesFromDictionary:phoneModel.pargram];
    
    
    HLStaffDetailModel *passModel = [[HLStaffDetailModel alloc]initWithText:@"登录密码" holder:_isAdd?@"请输入登录密码":@"修改登录密码" type:HLDefaultType];
    passModel.canEdit = _isAdd;
    passModel.showGoImg = !_isAdd;
    passModel.value = @"";
    passModel.showText = _isAdd?@"":@"修改登录密码";
    passModel.input_num = 20;
    if (_isAdd) {
        passModel.fieldType = HLTextFieldPassType;
        passModel.pargram = @{@"password":passModel.value};
        [self.pargram addEntriesFromDictionary:passModel.pargram];
    }
    
    HLStaffDetailModel *storeModel = [[HLStaffDetailModel alloc]initWithText:@"所属门店" holder:@"请选择所属门店" type:HLDefaultType];
    storeModel.canEdit = NO;
    storeModel.showGoImg = YES;
    storeModel.value = _defaultModel.store_id;
    storeModel.showText = _defaultModel.store_name;
    storeModel.pargram = @{@"store_id":storeModel.value};
    [self.pargram addEntriesFromDictionary:storeModel.pargram];
    
    //管理员下才设置
    HLStaffDetailModel *dzModel = [[HLStaffDetailModel alloc]initWithText:@"设为店长" holder:@"" type:HLSwitchType];
    dzModel.canEdit = NO;
    dzModel.showGoImg = NO;
    dzModel.value = _defaultModel.is_dianzhang;
    dzModel.pargram = @{@"is_dianzhang":dzModel.value};
    [self.pargram addEntriesFromDictionary:dzModel.pargram];
    
    NSArray *firstSection = @[adminModel,nameModel,phoneModel,passModel];
    NSArray * secondSection;
    if ([HLAccount shared].admin) {
        secondSection = @[storeModel,dzModel];
    }else{
        secondSection = @[storeModel];
    }
    [self.dataSource addObject:firstSection];
    [self.dataSource addObject:secondSection];
    [self.tableView reloadData];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [self createUI];
    if (!_isAdd) {//如果是详情
        [self requestDeatilWithType:@"3"];
    }else{
        [self requestDeatilWithType:@"1"];
    }
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, ScreenW, ScreenH-Height_NavBar -FitPTScreenH(44)) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
     AdjustsScrollViewInsetNever(self,_tableView);
    
    [_tableView registerClass:[HLStaffDetailTableViewCell class] forCellReuseIdentifier:@"HLStaffDetailTableViewCell"];
    
    addBtn = [[UIButton alloc]init];
    [addBtn setTitle:_isAdd?@"添加":@"提交" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    addBtn.backgroundColor = UIColorFromRGB(0xFF8604);
    addBtn.titleLabel.font=[UIFont systemFontOfSize:FitPTScreenH(15)];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addYG) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(FitPTScreenH(44) + Height_Bottom_Margn);
    }];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBar;
}

-(void)addYG{
    
    if (!_isAdd) {//详情
        [self modifyUserInfoWithType:@"4"];
    }else{
        [self modifyUserInfoWithType:@"2"];
    }
}

-(void)cancelClick:(UIButton *)sender{
    [self.tableView endEditing:YES];
    [self hl_goback];
}
#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * datas = self.dataSource[section];
    return datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLStaffDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLStaffDetailTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    cell.pargram = self.pargram;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return FitPTScreenH(10);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreenH(10))];
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitPTScreenH(45);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //只有是管理员可以选择门店
    [self.tableView endEditing:YES];
    if ([HLAccount shared].admin && indexPath.section == 1 && indexPath.row == 0) {
        MJWeakSelf;
        HLSelectMDViewController * selectVC = [[HLSelectMDViewController alloc]init];
        HLStaffDetailModel * model = self.dataSource[indexPath.section][indexPath.row];
        selectVC.storeId = model.value;
        selectVC.selectMD = ^(HLStoreModel * storeModel) {
            model.showText = storeModel.name;
            model.value = storeModel.storeID;
            model.pargram = [NSDictionary dictionaryWithObject:model.value forKey:model.pargram.allKeys.firstObject];
            [weakSelf.pargram addEntriesFromDictionary:model.pargram];
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self hl_pushToController:selectVC];
        return;
    }
    if (!_isAdd && indexPath.section == 0 && indexPath.row == 3){//详情页面,要跳转到修改登录密码
        HLModifyPasswordController * modifyVC = [[HLModifyPasswordController alloc]init];
        modifyVC.model = _staffModel;
        [self hl_pushToController:modifyVC];
    }
}

#pragma Request

//3-获取默认值 进入详情的默认值
-(void)requestDeatilWithType:(NSString *)type{
    NSDictionary * pargram = @{
                               @"type":type,
                               @"oid":_staffModel?_staffModel.staffID:@""
                               };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StaffEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self dealDatasWithModel:result.data];
            return;
        }
        [self hl_goback];
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
    
}

//修改信息
-(void)modifyUserInfoWithType:(NSString *)type{
    
    NSDictionary * pargram = @{
                               @"type":type,
                               @"oid":_staffModel?_staffModel.staffID:@"",
                               };
    [self.pargram addEntriesFromDictionary:pargram];
    
    NSString * pass = self.pargram[@"password"];
    if ([pass hl_isAvailable] && pass.length < 6) {
        [HLTools showWithText:@"密码不能小于6位数"];
        return;
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StaffEdit.php" ;
        request.serverType = HLServerTypeNormal;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;        
        if(result.code == 200){
            [self hl_goback];
            [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadStaffDataNotifi object:nil];
            [HLTools showWithText:self.isAdd?@"添加成功":@"修改成功"];
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView * touchView = touch.view;
    if (![touchView isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return YES;
    }
    return NO;
}
@end
