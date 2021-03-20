//
//  HLSendOrderMoneyController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderMoneyController.h"
#import "HLRightInputViewCell.h"
#import "HLSendOrderMoneyInputCell.h"
#import "HLSendOrderMoneyInfo.h"

@interface HLSendOrderMoneyController () <UITableViewDelegate,UITableViewDataSource,HLSendOrderMoneyInputCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HLSendOrderMoneyInfo *mainInfo;

@property (nonatomic, strong) UILabel *tipLab;

@end

@implementation HLSendOrderMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"配送费设置";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"保存"];
    
    [self loadPageData];
}

/// 保存信息
- (void)saveButtonClick{
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    [mParams setValue:self.mainInfo.sendId?:@"" forKey:@"sendId"];
    [mParams setValue:self.type forKey:@"type"];
    
    for (HLBaseTypeInfo *info in self.mainInfo.section0Arr) {
        // 默认的右边输入
        if(info.type == HLInputCellTypeDefault){
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            // 参数验证通过，先判断 mParams ，再去设置text
            if(info.mParams.count > 0){
                [mParams setValuesForKeysWithDictionary:info.mParams];
            }else{
                // 这里保存的分
                double money = info.text.doubleValue * 100;
                [mParams setValue:@((NSInteger)money) forKey:info.saveKey];
            }
            continue;
        }
    }
    
    NSMutableArray *moneyArr = [NSMutableArray array];
    for (HLSendOrderMoneyInputInfo *info in self.mainInfo.section1Arr) {
        if (info.endMoneyText.length == 0 || info.startMoneyText.length == 0 || info.sendMoneyText.length == 0) {
            HLShowHint(@"请完善配送费信息", self.view);
            return;
        }
        [moneyArr addObject:@{
                              @"start":@((NSInteger)(info.startMoneyText.doubleValue * 100)),
                              @"end":@((NSInteger)(info.endMoneyText.doubleValue * 100)),
                              @"money":@((NSInteger)(info.sendMoneyText.doubleValue * 100))
                              }];
    }
    [mParams setValue:[moneyArr mj_JSONString] forKey:@"moneys"];
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/SendMoneySet.php";
        request.parameters = mParams;
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            HLShowText(@"保存成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 加载数据
- (void)loadPageData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/SendMoney.php";
        request.parameters = @{@"type":self.type};
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            _mainInfo = [HLSendOrderMoneyInfo mj_objectWithKeyValues:[XMResult dataDict:responseObject]];
            [self.tableView reloadData];
            _tipLab.text = _mainInfo.tips;
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 添加一个新的配送费输入
- (void)addButtonClick{
    HLSendOrderMoneyInputInfo *info = [[HLSendOrderMoneyInputInfo alloc] init];
    [self.mainInfo.section1Arr addObject:info];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.mainInfo.section1Arr.count - 1 inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    // 滚动到这个
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(150), ScreenW, FitPTScreen(150))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(150));
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-10));
        make.centerX.equalTo(footView);
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [footView addSubview:tipLab];
    tipLab.text = @"设置不同的消费金额，收取不同的配送费";
    tipLab.textColor = UIColorFromRGB(0xFF6E6E);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView);
        make.bottom.equalTo(saveButton.top);
    }];
    _tipLab = tipLab;
    
    UIButton *addButton = [[UIButton alloc] init];
    [footView addSubview:addButton];
    [addButton setBackgroundImage:[UIImage imageNamed:@"sendOrder_add_bottom"] forState:UIControlStateNormal];
    [addButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(tipLab.top).offset(FitPTScreen(-18));
        make.width.equalTo(FitPTScreen(93));
        make.height.equalTo(FitPTScreen(32));
    }];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - HLSendOrderMoneyInputCellDelegate

/// 删除
-(void)inputCell:(HLSendOrderMoneyInputCell *)cell deleteInputInfo:(HLSendOrderMoneyInputInfo *)inputInfo{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.mainInfo.section1Arr removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

#pragma mark - UITableViewsection0Arr

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? self.mainInfo.section0Arr.count : self.mainInfo.section1Arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HLBaseTypeInfo *info = self.mainInfo.section0Arr[indexPath.row];
        HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
        cell.baseInfo = info;
        cell.showBottomLine = indexPath.row != self.mainInfo.section0Arr.count - 1;
        return cell;
    }else{
        HLSendOrderMoneyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLSendOrderMoneyInputCell" forIndexPath:indexPath];
        cell.inputInfo = self.mainInfo.section1Arr[indexPath.row];
        cell.index = indexPath.row;
        cell.delegate = self;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? FitPTScreen(53) : FitPTScreen(103);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitPTScreen(54);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(54))];
    view.backgroundColor = UIColorFromRGB(0xF9F9F9);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [view addSubview:imageView];
    imageView.image = [UIImage imageNamed:section == 0 ? @"sendOrder_peisong" : @"sendOrder_qisong"];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.centerY.equalTo(view);
        make.width.equalTo(FitPTScreen(14));
        make.height.equalTo(FitPTScreen(12));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    label.text = section == 0 ? @"起送费" : @"配送费";
    label.textColor = UIColorFromRGB(0x555555);
    label.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(FitPTScreen(34));
    }];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor redColor];
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(15))];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLSendOrderMoneyInputCell class] forCellReuseIdentifier:@"HLSendOrderMoneyInputCell"];
    }
    return _tableView;
}



@end
