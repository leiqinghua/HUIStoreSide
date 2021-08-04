//
//  HLSendOrderCodeAddController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderCodeAddController.h"
#import "HLSendOrderCodeInputCell.h"
#import "MMScanViewController.h"
#import "HLSendOrderCodeInfo.h"

@interface HLSendOrderCodeAddController () <UITableViewDelegate,UITableViewDataSource,HLSendOrderCodeInputCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HLSendOrderCodeAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"生成点单牌";
    [self.view addSubview:self.tableView];
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self initTableHead];
    [self initTableFoot];
    [self creatFootViewWithButtonTitle:@"保存"];
    
    /// 判断是否是编辑
    if (self.tableId) {
        [self loadCodeData];
    }
}

/// 加载数据
- (void)loadCodeData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/TableNumberInfo.php";
        request.parameters = @{@"type":self.type,@"tableId":self.tableId};
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([(XMResult *)responseObject code] == 200) {
            HLSendOrderCodeInfo *codeInfo = [HLSendOrderCodeInfo mj_objectWithKeyValues:[XMResult dataDict:responseObject]];
            _textField.text = codeInfo.tableNo;
            if (codeInfo.cardNo1.length > 0 && ![codeInfo.cardNo1 isEqualToString:@"0"]) {
                HLSendOrderCodeInputInfo *inputInfo = [[HLSendOrderCodeInputInfo alloc] init];
                inputInfo.number = codeInfo.cardNo1;
                [self.dataSource addObject:inputInfo];
            }
            if (codeInfo.cardNo2.length > 0 && ![codeInfo.cardNo2 isEqualToString:@"0"]) {
                HLSendOrderCodeInputInfo *inputInfo = [[HLSendOrderCodeInputInfo alloc] init];
                inputInfo.number = codeInfo.cardNo2;
                [self.dataSource addObject:inputInfo];
            }
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 保存按钮
- (void)saveButtonClick{
    // 判断
    NSString *tableNo = _textField.text;
    if (tableNo.length == 0) {
        HLShowHint(@"请输入桌号", self.view);
        return;
    }
    
    BOOL hasData = NO;
    for (HLSendOrderCodeInputInfo *info in self.dataSource) {
        if (info.number.length > 0) {
            hasData = YES;
            break;
        }
    }
    if (!hasData) {
        HLShowHint(@"请绑定买单牌", self.view);
        return;
    }
    
    NSString *number1 = @"";
    NSString *number2 = @"";
    if (self.dataSource.count == 1) {
        HLSendOrderCodeInputInfo *inputInfo = self.dataSource.firstObject;
        number1 = inputInfo.number;
    }
    if (self.dataSource.count == 2) {
        HLSendOrderCodeInputInfo *inputInfo = self.dataSource.firstObject;
        HLSendOrderCodeInputInfo *inputInfo2 = self.dataSource.lastObject;
        number1 = inputInfo.number;
        number2 = inputInfo2.number;
    }
    
    NSDictionary *params = @{
                             @"tableId":self.tableId?:@"0",
                             @"tableNo":tableNo,
                             @"number1":number1,
                             @"number2":number2,
                             @"type":self.type
                             };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/TableNumberInfoSet.php";
        request.parameters = params;
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            HLShowHint(@"绑定成功", self.view);
            // 告诉外面
            if (self.addBlock) {
                self.addBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 扫一扫按钮
- (void)scanBtnClick{
    
    // 判断
    if (self.dataSource.count == 2) {
        HLShowHint(@"绑定点餐牌，最多可绑定两个", self.view);
        return;
    }
    
    weakify(self);
    MMScanViewController *scan = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
        [weak_self bindCodeWithCodeNum:result];
    }];
    [self.navigationController pushViewController:scan animated:YES];
}

/// 判断此时是否存在相同的牌号
- (BOOL)checkIsExsitNumber:(NSString *)number{
    __block BOOL isExsit = NO;
    [self.dataSource enumerateObjectsUsingBlock:^(HLSendOrderCodeInputInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.number isEqualToString:number]) {
            isExsit = YES;
            *stop = YES;
        }
    }];
    return isExsit;
}

/// 绑定
- (void)bindCodeWithCodeNum:(NSString *)codeNum{
    HLLoading(self.view);
    MMScanViewController *topScanVC = (MMScanViewController *)self.navigationController.topViewController;
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/Scan.php";
        request.parameters = @{@"url":codeNum};
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([(XMResult *)responseObject code] == 200) {
            // 判断如果此时已经扫描了这个，就不要再添加了
            NSString *number = [HLTools safeStringObject:[XMResult dataDict:responseObject][@"number"]];
            if ([self checkIsExsitNumber:number]) {
                HLShowText(@"该点单牌已经存在，请重试");
                [topScanVC restartScan];
                return;
            }
            
            [self.navigationController popToViewController:self animated:YES];
            HLSendOrderCodeInputInfo *inputInfo = [[HLSendOrderCodeInputInfo alloc] init];
            inputInfo.number = number;
            [self.dataSource addObject:inputInfo];
            [self.tableView reloadData];
        }else{
            [topScanVC restartScan];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 创建底部按钮
- (void)initTableFoot{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(110))];
    
    UIButton *scanBtn = [[UIButton alloc] init];
    [footView addSubview:scanBtn];
    [scanBtn setTitle:@"+ 扫一扫" forState:UIControlStateNormal];
    [scanBtn setTitleColor:UIColorFromRGB(0xFF8E16) forState:UIControlStateNormal];
    scanBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    scanBtn.layer.borderWidth = 0.7;
    scanBtn.layer.borderColor = UIColorFromRGB(0xFF8604).CGColor;
    scanBtn.layer.cornerRadius = FitPTScreen(3);
    scanBtn.layer.masksToBounds = YES;
    [scanBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView);
        make.top.equalTo(FitPTScreen(53));
        make.width.equalTo(FitPTScreen(88));
        make.height.equalTo(FitPTScreen(32));
    }];
    [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    [footView addSubview:label];
    label.text = @"绑定点餐牌，最多可绑定两个";
    label.textColor = UIColorFromRGB(0xFF6E6E);
    label.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanBtn.bottom).offset(FitPTScreen(7));
        make.centerX.equalTo(footView);
    }];
    
    self.tableView.tableFooterView = footView;
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

/// 创建头部输入view
- (void)initTableHead{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(50))];
    
    UILabel *label = [[UILabel alloc] init];
    [headView addSubview:label];
    label.text = @"桌号";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(17));
        make.centerY.equalTo(headView);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入桌牌号";
    textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    textField.textColor = UIColorFromRGB(0x333333);
    textField.textAlignment = NSTextAlignmentRight;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [headView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-14));
        make.left.equalTo(FitPTScreen(70));
        make.top.bottom.equalTo(0);
    }];
    _textField = textField;
    
    UIView *bottomLine = [[UIView alloc] init];
    [headView addSubview:bottomLine];
    bottomLine.backgroundColor = UIColorFromRGB(0xECECEC);
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(0);
        make.height.equalTo(0.5);
        make.bottom.equalTo(0);
    }];
    
    self.tableView.tableHeaderView = headView;
}

#pragma mark - HLSendOrderCodeInputCellDelegate

/// 删除
- (void)deleteBtnClickWithInputCell:(HLSendOrderCodeInputCell *)cell{
    [self.dataSource removeObject:cell.inputInfo];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLSendOrderCodeInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLSendOrderCodeInputCell" forIndexPath:indexPath];
    cell.inputInfo = self.dataSource[indexPath.row];
    cell.index = indexPath.row;
    if (self.dataSource.count > 0) {
        [cell configBottomLine:indexPath.row == self.dataSource.count - 1];
    }
    cell.delegate = self;
    return cell;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = FitPTScreen(50);
        [_tableView registerClass:[HLSendOrderCodeInputCell class] forCellReuseIdentifier:@"HLSendOrderCodeInputCell"];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
