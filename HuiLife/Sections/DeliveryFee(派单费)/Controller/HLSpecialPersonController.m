//
//  HLSpecialPersonController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/19.
//

#import "HLSpecialPersonController.h"
#import "HLSpecialTableHead.h"
#import "HLSpecialPeron.h"
#import "HLSpecialPerTableCell.h"

#define bottomViewH FitPTScreen(130)

@interface HLSpecialPersonController () <UITableViewDelegate, UITableViewDataSource, HLSpecialPerTableCellDelegate, HLSpecialTableHeadDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) HLSpecialTableHead *tableHeader;
@property(nonatomic, strong) HLSpecialMainInfo *mainInfo;
@property(nonatomic, strong) NSMutableArray *datasource;
@end

@implementation HLSpecialPersonController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"专送员"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultData];
}

#pragma mark - request
- (void)loadDefaultData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/DistributorSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
        request.httpMethod = kXMHTTPMethodPOST;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        [self initSubView];
        if (result.code == 200)[self handDefaultData:result.data];
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handDefaultData:(NSDictionary *)dict {
    _mainInfo = [HLSpecialMainInfo mj_objectWithKeyValues:dict];
    if (_mainInfo.mobile_info.count) {
        [self.datasource removeAllObjects];
    }
    [self.datasource addObjectsFromArray:_mainInfo.mobile_info];
    HLSpecialPeron *person = self.datasource.firstObject;
    person.add = YES;
    _tableHeader.title = _mainInfo.open_title;
    _tableHeader.subTitle = _mainInfo.open_label;
    _tableHeader.on = _mainInfo.is_open;
    [self.tableView reloadData];
}

//校验 手机号
- (void)checkPhoneNum:(NSString *)phoneNum callBack:(void(^)(XMResult *))callBack{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/DistributorCk.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"mobile":phoneNum};
        request.httpMethod = kXMHTTPMethodPOST;
        request.hideError = YES;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200){
            callBack(result);
            return;;
        }
        callBack(nil);
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        callBack(nil);
    }];
}

- (void)savePhoneNums:(NSString *)numbers {
    HLLoading(self.view);
       [XMCenter sendRequest:^(XMRequest *request) {
           request.api = @"/MerchantSideA/DistributorSetAc.php";
           request.serverType = HLServerTypeNormal;
           request.parameters = @{@"is_open":@(_mainInfo.is_open),@"mobile_str":numbers};
           request.httpMethod = kXMHTTPMethodPOST;
           request.hideError = YES;
       }onSuccess:^(id responseObject) {
           HLHideLoading(self.view);
           XMResult *result = (XMResult *)responseObject;
           if (result.code == 200){
               [HLTools showWithText:@"保存成功"];
               [self hl_goback];
               return;
           }
       }onFailure:^(NSError *error) {
           HLHideLoading(self.view);
       }];
}

#pragma mark - Event
//保存
- (void)saveClick {
    NSMutableArray *numbers = [NSMutableArray array];
    for (HLSpecialPeron *person in self.datasource) {
        if (!person.is_authenticate) {
            [HLTools showWithText:@"请输入有效的手机号"];
            return;
        }
        [numbers addObject:person.mobile];
    }
    //    拼接
    NSString *numStr = [numbers componentsJoinedByString:@","];
    HLLog(@"numStr = %@",numStr);
    [self savePhoneNums:numStr];
}

#pragma mark - Method
- (HLSpecialPeron *)creatPerson {
    HLSpecialPeron *person = [[HLSpecialPeron alloc]init];
    person.tipStr = @"请输入手机号";
    return person;
}

#pragma mark - HLSpecialPerTableCellDelegate
- (void)perCell:(HLSpecialPerTableCell *)perCell add:(BOOL)add {
    if (add) {
        if (self.datasource.count >= 20) {
            [HLTools showWithText:@"最多可添加20个"];
            return;
        }
        [self.datasource addObject:[self creatPerson]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datasource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        HLSpecialPeron *person = perCell.specialPer;
        NSInteger index = [self.datasource indexOfObject:person];
        [self.datasource removeObject:person];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)perCell:(HLSpecialPerTableCell *)perCell phoneNum:(NSString *)phoneNum showNum:(nonnull NSString *)showNum{
    HLLog(@"phoneNum = %@",phoneNum);
    HLSpecialPeron *person = perCell.specialPer;
    NSInteger index = [self.datasource indexOfObject:perCell.specialPer];
    if (!showNum.length) {
         person.is_authenticate = NO;
         person.tipStr = @"请输入手机号";
         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    person.mobile = phoneNum;
    person.mobileText = showNum;
    
    weakify(self);
    [self checkPhoneNum:phoneNum?:@"" callBack:^(XMResult* result) {
        if (result.code == 200) {
            person.authenticate_name = result.data[@"name"];
            person.is_authenticate = YES;
            [weak_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        person.is_authenticate = NO;
        person.tipStr = result.msg?:@"手机号无效";
        [weak_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - HLSpecialTableHeadDelegate
- (void)tableHead:(HLSpecialTableHead *)tableHead open:(BOOL)open {
    _mainInfo.is_open = open;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLSpecialPerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLSpecialPerTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.specialPer = self.datasource[indexPath.row];
    return cell;
}

#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH -Height_NavBar - bottomViewH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = FitPTScreen(55);
    _tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, _tableView);
    [self.view addSubview:_tableView];
    
    _tableHeader = [[HLSpecialTableHead alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(74))];
    _tableHeader.delegate = self;
    self.tableView.tableHeaderView = _tableHeader;
    
    [_tableView registerClass:[HLSpecialPerTableCell class] forCellReuseIdentifier:@"HLSpecialPerTableCell"];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), ScreenW, bottomViewH)];
    [self.view addSubview:bottomView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [bottomView addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"button_bag"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(30));
    }];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        HLSpecialPeron *addPerson = [self creatPerson];
        addPerson.add = YES;
        [_datasource addObject:addPerson];
    }
    return _datasource;
}
@end
