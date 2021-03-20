//
//  HLSettingViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/24.
//

#import "HLSettingViewController.h"
#import "HLSelectMDViewController.h"
//#import "HLMineRequest.h"
#import "HLStaffDetailTableViewCell.h"

@interface HLSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIButton *addBtn;
}
@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSArray *defaultItems;

//所选择的门店
@property(strong,nonatomic)HLStoreModel * selectMD;

@property (strong,nonatomic)NSMutableArray * dataSource;

//存储所有参数
@property (strong,nonatomic)NSMutableDictionary * pargram;

@end

@implementation HLSettingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatFootView];
    [self createUI];
}

/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"提交" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
}


-(void)createUI{
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [cancel setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[HLStaffDetailTableViewCell class] forCellReuseIdentifier:@"HLStaffDetailTableViewCell"];
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self,_tableView);
}

-(void)commit{
    [self requestUserInfo];
}

-(void)cancelClick:(UIButton *)sender{
    [self hl_goback];
}

#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * sections = self.dataSource[section];
    return sections.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitPTScreenH(45);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLStaffDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLStaffDetailTableViewCell" forIndexPath:indexPath];
    NSArray * sections = self.dataSource[indexPath.section];
    cell.model =sections[indexPath.row];
    cell.indexPath = indexPath;
    cell.pargram = self.pargram;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataSource.count-1) {
        return 0.01;
    }
    return FitPTScreen(10);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.dataSource.count-1) {
        return  nil;
    }
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(10))];
    footer.backgroundColor = UIColorFromRGB(0xF6F6F6);
    return footer;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //只有是管理员可以选择门店
    NSArray * datas = self.dataSource[indexPath.section];
    HLStaffDetailModel * model = datas[indexPath.row];
    if ([HLAccount shared].role == 1&&indexPath.section == 1) {
        [tableView endEditing:YES];
        HLSelectMDViewController *selectVC = [[HLSelectMDViewController alloc]init];
        selectVC.storeId = model.value;
        weakify(self);
         selectVC.selectMD = ^(HLStoreModel *storeModel) {
             model.showText = storeModel.nameText;
             model.value = storeModel.storeID;
             model.pargram = @{model.pargram.allKeys.firstObject:model.value};
             [weak_self.pargram addEntriesFromDictionary:model.pargram];
            //刷新第一个分组
             NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
             [weak_self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        };
        [self hl_pushToController:selectVC];
    }
}

#pragma request
-(void)requestUserInfo{
    NSDictionary * pargram = @{@"type":@"2"};
    [self.pargram addEntriesFromDictionary:pargram];
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/MessageSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        [self handleDataWithData:result.data];
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDataWithData:(id )data{
    HLAccount * account = [HLAccount shared];
    [account mj_setKeyValues:self.pargram];
    
    //存本地
    [HLAccount saveAcount];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadMineDataNotifi object:nil];
    [self hl_goback];
}

#pragma mark SET & GET
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        HLAccount * account = [HLAccount shared];
        
        HLStaffDetailModel *userName = [[HLStaffDetailModel alloc]initWithText:@"工号" holder:@"" type:HLDefaultType];
        userName.value = account.user_name;
        userName.showText = account.user_name;
        userName.pargram = @{@"user_name":userName.value};
        [self.pargram addEntriesFromDictionary:userName.pargram];
        
        HLStaffDetailModel *nameModel = [[HLStaffDetailModel alloc]initWithText:@"姓名" holder:@"请输入姓名" type:HLDefaultType];
        nameModel.input_num = 20;
        nameModel.canEdit = YES;
        nameModel.value = account.name;
        nameModel.showText = account.name;
        nameModel.pargram = @{@"name":nameModel.value};
        [self.pargram addEntriesFromDictionary:nameModel.pargram];
        
        //mobile
        HLStaffDetailModel *mobileModel = [[HLStaffDetailModel alloc]initWithText:@"联系电话" holder:@"请输入联系电话" type:HLDefaultType];
        mobileModel.canEdit = YES;
        mobileModel.value = account.mobile?:@"";
        mobileModel.showText = account.mobile;
        mobileModel.fieldType = HLTextFieldPhoneType;
        mobileModel.input_num = 11;
        mobileModel.pargram = @{@"mobile":mobileModel.value};
        [self.pargram addEntriesFromDictionary:mobileModel.pargram];
        
        HLStaffDetailModel *storeModel = [[HLStaffDetailModel alloc]initWithText:@"所属门店" holder:@"请选择所属门店" type:HLDefaultType];
        //管理员显示
        storeModel.showGoImg = account.role == 1;
        storeModel.value = account.store_id?:@"";
        storeModel.showText = account.store_name;
        storeModel.pargram = @{@"store_id":account.store_id};
        [self.pargram addEntriesFromDictionary:storeModel.pargram];
        
        HLStaffDetailModel *yyModel = [[HLStaffDetailModel alloc]initWithText:@"收款语音提示" holder:@"" type:HLSwitchType];
        yyModel.value = [NSString stringWithFormat:@"%d",account.is_yy];
        yyModel.pargram = @{@"is_yy":@(account.is_yy)};
        [self.pargram addEntriesFromDictionary:yyModel.pargram];
        
        [_dataSource addObject:@[userName,nameModel,mobileModel]];
        [_dataSource addObject:@[storeModel]];
        [_dataSource addObject:@[yyModel]];
    }
    return _dataSource;
}

-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}


@end
