//
//  HLAddPrinterViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/23.
//

#import "HLAddPrinterViewController.h"
#import "HLNextAddPrinterController.h"
#import "HLPrinterSettingAlertView.h"

#import "HLRightInputViewCell.h"

@interface HLAddPrinterViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

//上一次选择的品牌
@property (assign,nonatomic)NSInteger lastSelectIndex;

@property (strong,nonatomic)UITableView * tableView;

@property (strong,nonatomic)NSMutableArray * dataSource;
//品牌
@property (strong,nonatomic)NSMutableArray * brands;
//参数
@property (strong,nonatomic)NSMutableDictionary * pargram;

@end

@implementation HLAddPrinterViewController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setTitle:_isAdd?@"添加打印机":@"打印机设置"];
}


#pragma mark - Method
-(void)next{
    if (!_isAdd) {
        [self checkEdit];
        return;
    }
    [self checkAdd];
}

- (void)checkAdd{
    [self.pargram removeAllObjects];
    for (NSArray * infos in self.dataSource) {
        for (HLRightInputTypeInfo *info in infos) {
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            [self.pargram setValue:info.text forKey:info.saveKey];
        }
    }
    [self checkData];
    HLLog(@"mParams = %@",self.pargram);
}

- (void)checkEdit {
    [self.pargram removeAllObjects];
    for (NSArray * infos in self.dataSource) {
        for (HLRightInputTypeInfo *info in infos) {
            // 默认的右边输入
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            [self.pargram setValue:info.text forKey:info.saveKey];
        }
    }
    [self loadDataWithType:2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = UIColor.whiteColor;
    [self creatFootView];
    [self initSubViews];
    
    if (!_isAdd) {
        [self loadDataWithType:1];
    }
}


/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initSubViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118)) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionFooterHeight = 0.1;
    _tableView.sectionHeaderHeight = 0.1;
    _tableView.tableFooterView = [UIView new];
    
    [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
    
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self,_tableView);

}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * sections = self.dataSource[section];
    return sections.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * datas = self.dataSource[indexPath.section];
    HLRightInputTypeInfo * info = datas[indexPath.row];
    HLRightInputViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.baseInfo = info;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }
    return FitPTScreen(15);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * datas = self.dataSource[indexPath.section];
    HLRightInputTypeInfo * info = datas[indexPath.row];
    return info.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.tableView endEditing:YES];
        [self showAlertWithIndex:indexPath];
    }
}

-(void)showAlertWithIndex:(NSIndexPath *)indexPath{
    //id分别对应2,3
    NSArray * datas = self.dataSource[indexPath.section];
    HLRightInputTypeInfo * info = datas[indexPath.row];
    
    [HLPrinterSettingAlertView showWithTitle:@"选择打印机品牌" type:HLPrinterViewStyleDefault dataSource:self.brands defaultIndex:_lastSelectIndex callBack:^(NSInteger clickIndex, NSInteger selectIndex) {
        if (clickIndex == 1) {
            self.lastSelectIndex = selectIndex;
            HLPrinterItemModel * selectmodel = self.brands[selectIndex];
            info.text = selectmodel.title;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Request
-(void)loadDataWithType:(NSInteger)type{
    NSDictionary * pargram = @{
                               @"type":@(type),
                               @"store_id":_storeID?:@"",
                               @"pid":_printerInfo[@"id"],
                               };
    if (type == 2) {
       [self.pargram addEntriesFromDictionary:pargram];
    }

    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/PrinterEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = type == 1?pargram:self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray * datas = result.data;
            [self handleDataWithType:type dict:datas.firstObject];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDataWithType:(NSInteger)type dict:(NSDictionary *)dict {
    if (type == 2) {
        //刷新打印机设置
        [[NSNotificationCenter defaultCenter]postNotificationName:HLAddPrinterSuccessNotifi object:nil];
        if (_save) {
            _save(self.pargram[@"printer_name"]);
        }
        [HLTools showWithText:@"修改成功"];
        [self hl_goback];
        return;
    }
    
    _lastSelectIndex = [dict[@"print_brand"] integerValue] ;
    
    HLRightInputTypeInfo * brandInfo = [[HLRightInputTypeInfo alloc]init];
    brandInfo.leftTip = @"打印机品牌";
    brandInfo.text = [dict[@"print_brand"] integerValue] == 0?@"芯烨":@"飞鹅";;
    brandInfo.canInput = false;
    brandInfo.showRightArrow = YES;
    brandInfo.cellHeight = FitPTScreen(50);
    brandInfo.saveKey = @"print_brand";
    
    HLRightInputTypeInfo * nameInfo = [[HLRightInputTypeInfo alloc]init];
    nameInfo.leftTip = @"打印机名称";
    nameInfo.canInput = YES;
    nameInfo.placeHoder = @"最多支持20个汉字";
    nameInfo.text = dict[@"printer_name"]?:@"";
    nameInfo.cellHeight = FitPTScreen(50);
    nameInfo.saveKey = @"printer_name";
    nameInfo.needCheckParams = YES;
    nameInfo.errorHint = @"请输入打印机名称";
    
    HLRightInputTypeInfo * NumInfo = [[HLRightInputTypeInfo alloc]init];
    NumInfo.leftTip = @"打印机编号";
    NumInfo.canInput = YES;
    NumInfo.placeHoder = @"请在打印机底部查看终端号";
    NumInfo.text = dict[@"printer_sn"]?:@"";
    NumInfo.cellHeight = FitPTScreen(50);
    NumInfo.saveKey = @"printer_sn";
    NumInfo.keyBoardType = UIKeyboardTypeNumberPad;
    NumInfo.needCheckParams = YES;
    NumInfo.errorHint = @"请输入打印机编号";
    
    HLRightInputTypeInfo * keyInfo = [[HLRightInputTypeInfo alloc]init];
    keyInfo.leftTip = @"KEY值";
    keyInfo.canInput = YES;
    keyInfo.placeHoder = @"请在打印机底部查看密钥";
    keyInfo.text = dict[@"printer_key"]?:@"";
    keyInfo.cellHeight = FitPTScreen(50);
    keyInfo.saveKey = @"printer_key";
    keyInfo.needCheckParams = YES;
    keyInfo.errorHint = @"请输入打印机KEY值";
    

    [self.dataSource addObject:@[brandInfo]];
    [self.dataSource addObject:@[nameInfo,NumInfo,keyInfo]];
    [self.pargram setValuesForKeysWithDictionary:dict];
    [self.tableView reloadData];
}

#pragma mark - next
//提交到下一步的时候 交给服务端检查打印机是否添加重复
-(void)checkData{
    NSDictionary * pargram = @{
                               @"type":@"2",
                               @"store_id":_storeID?:@""
                               };
    NSMutableDictionary * pargramMutCopy = pargram.mutableCopy;
    [pargramMutCopy addEntriesFromDictionary:self.pargram];
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/PrinterAdd.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargramMutCopy;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleCheckData];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
    
}

-(void)handleCheckData{
    HLNextAddPrinterController * next = [[HLNextAddPrinterController alloc]init];
    next.pargram = self.pargram;
    next.isAdd = YES;
    next.storeID = _storeID;
    [self hl_pushToController:next];
}


#pragma mark - SET&GET

-(NSMutableArray *)brands{
    if (!_brands) {
        HLPrinterItemModel * model1 = [[HLPrinterItemModel alloc]init];
        model1.title = @"芯烨";
        
        HLPrinterItemModel * model2 = [[HLPrinterItemModel alloc]init];
        model2.title = @"飞鹅";
        _brands = [NSMutableArray arrayWithArray:@[model1,model2]];
    }
    return _brands;
}

-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}



-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        if (!_isAdd) {
            return _dataSource;
        }
        HLRightInputTypeInfo * brandInfo = [[HLRightInputTypeInfo alloc]init];
        brandInfo.leftTip = @"打印机品牌";
        brandInfo.text = @"芯烨";
        brandInfo.canInput = false;
        brandInfo.showRightArrow = YES;
        brandInfo.cellHeight = FitPTScreen(50);
        brandInfo.saveKey = @"print_brand";

        HLRightInputTypeInfo * nameInfo = [[HLRightInputTypeInfo alloc]init];
        nameInfo.leftTip = @"打印机名称";
        nameInfo.placeHoder = @"最多支持20个汉字";
        nameInfo.canInput = YES;
        nameInfo.cellHeight = FitPTScreen(50);
        nameInfo.saveKey = @"printer_name";
        nameInfo.needCheckParams = YES;
        nameInfo.errorHint = @"请输入打印机名称";
        
        HLRightInputTypeInfo * numInfo = [[HLRightInputTypeInfo alloc]init];
        numInfo.leftTip = @"打印机编号";
        numInfo.placeHoder = @"请在打印机底部查看终端号";
        numInfo.canInput = YES;
        numInfo.cellHeight = FitPTScreen(50);
        numInfo.keyBoardType = UIKeyboardTypeNumberPad;
        numInfo.saveKey = @"printer_sn";
        numInfo.needCheckParams = YES;
        numInfo.errorHint = @"请输入打印机编号";
        
        HLRightInputTypeInfo * keyInfo = [[HLRightInputTypeInfo alloc]init];
        keyInfo.leftTip = @"KEY值";
        keyInfo.canInput = YES;
        keyInfo.cellHeight = FitPTScreen(50);
        keyInfo.saveKey = @"printer_key";
        keyInfo.needCheckParams = YES;
        keyInfo.errorHint = @"请输入打印机KEY值";
        keyInfo.placeHoder = @"请在打印机底部查看密钥";
        
        NSArray * first = @[brandInfo];
        NSArray * second = @[nameInfo,numInfo,keyInfo];
        [_dataSource addObject:first];;
        [_dataSource addObject:second];
    }
    return _dataSource;
}


@end
