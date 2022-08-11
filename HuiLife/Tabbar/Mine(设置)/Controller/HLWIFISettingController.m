//
//  HLWIFISettingController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/26.
//

#import "HLWIFISettingController.h"
#import "HLAddPrinterViewController.h"
#import "HLNextAddPrinterController.h"
#import "HLWithNotImgAlertView.h"

#import "HLRightInputViewCell.h"
#import "WHActionSheet.h"

@interface HLWIFISettingController ()<UITableViewDelegate,UITableViewDataSource,WHActionSheetDelegate>

@property(strong,nonatomic)UITableView * tableView;

@property(nonatomic,strong)NSArray * datasource;

@property (strong,nonatomic)HLRightInputTypeInfo * nameInfo;

@end

@implementation HLWIFISettingController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setTitle:@"设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0.01;
    _tableView.sectionHeaderHeight = 0.01;
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
}


#pragma mark - WHActionSheetDelegate

-(void)actionSheet:(WHActionSheet *)actionSheet clickButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //发请求断开连接
        [self loadDataWithType:6];
    }
}

- (void)actionSheetCancle:(WHActionSheet *)actionSheet{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * datas = self.datasource[section];
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * datas = self.datasource[indexPath.section];
    HLRightInputTypeInfo * info = datas[indexPath.row];
    HLRightInputViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.baseInfo = info;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * datas = self.datasource[indexPath.section];
    HLRightInputTypeInfo * info = datas[indexPath.row];
    return info.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * datas = self.datasource[indexPath.section];
    HLRightInputTypeInfo * info = datas[indexPath.row];
    if ([info.leftTip isEqualToString:@"打印机设置"]) {
        [self goToPrinteSetPage];
        return;
    }
    
    if ([info.leftTip isEqualToString:@"打印机内容设置"]) {
        [self printerContentSetPage];
        return;
    }
    
    if ([info.leftTip isEqualToString:@"重命名"]) {
        [self showReNameView];
        return;
    }
    
    if ([info.leftTip isEqualToString:@"断开连接"]) {
        [self showAlertView];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 0?FitPTScreen(15):0.01;
}

//打印机设置页面
- (void)goToPrinteSetPage{
    HLAddPrinterViewController * add = [[HLAddPrinterViewController alloc]init];
    add.printerInfo = _printerInfo;
    add.storeID = _storeID;
    weakify(self);
    add.save = ^(NSString * _Nonnull printerName) {
        weak_self.nameInfo.leftTip = printerName;
        [weak_self.tableView reloadData];
    };
    [self hl_pushToController:add];
}

//打印机内容设置
- (void)printerContentSetPage{
    HLNextAddPrinterController * content = [[HLNextAddPrinterController alloc]init];
    content.printerInfo = _printerInfo;
    content.storeID = _storeID;
    weakify(self);
    content.callBack = ^(BOOL isOpen) {
        weak_self.nameInfo.text = isOpen?@"已连接":@"未连接";
        [weak_self.tableView reloadData];
    };
    [self hl_pushToController:content];
}

-(void)showReNameView{
    weakify(self);
    HLWithNotImgAlertView * alert = [[HLWithNotImgAlertView alloc]initWithTitle:@"重命名" text:self.nameInfo.leftTip  placeHolder:@"请输入打印机名称" hight:FitPTScreen(180) concern:^(NSString *text) {
        if (![text hl_isAvailable]) {
            [HLTools showWithText:@"内容不能为空"];
            return ;
        }
        weak_self.nameInfo.leftTip = text;
        [weak_self.tableView reloadData];
        [weak_self loadDataWithType:5];
    } cancel:^{

    }];
    [KEY_WINDOW addSubview:alert];
    
}

-(void)showAlertView{
    WHActionSheet *actionSheet = [[WHActionSheet alloc] initWithTitle:@"" sheetTitles:@[@"断开连接"] cancleBtnTitle:@"取消" sheetStyle:(WHActionSheetDefault) delegate:self];
    actionSheet.isCorner = NO;
    actionSheet.subtitlebgColor = [UIColor whiteColor];
    actionSheet.subtitleColor = UIColorFromRGB(0xFF8604);
    actionSheet.canclebgColor = [UIColor whiteColor];
    actionSheet.cancleHeight = FitPTScreen(45);
    actionSheet.sheetHeight = FitPTScreen(45);
    actionSheet.cancelFont = [UIFont systemFontOfSize:FitPTScreen(14)];
    actionSheet.subtitleFont = [UIFont systemFontOfSize:FitPTScreen(14)];
    [actionSheet show];
}

#pragma mark - Request
-(void)loadDataWithType:(NSInteger)type{
    HLAccount * account = [HLAccount shared];
    NSDictionary * pargram = @{
                               @"store_id":account.store_id,
                               @"type":@(type),
                               @"pid":_printerInfo[@"id"],
                               @"is_print":_printerInfo[@"is_print"],
                               @"printer_name":self.nameInfo.leftTip?:@""
                               };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/PrinterEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
           [self handleDataWithDict:result.data type:type];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
    
    
}

//6 断开连接  ，5 重命名
-(void)handleDataWithDict:(NSDictionary *)dict type:(NSInteger)type{
    [[NSNotificationCenter defaultCenter]postNotificationName:HLAddPrinterSuccessNotifi object:nil];
    if (type == 6) {
        [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadMineDataNotifi object:nil];
        [self hl_goback];
        return;
    }
    [self.tableView reloadData];
}


-(NSArray *)datasource{
    if (!_datasource) {
        HLRightInputTypeInfo * nameInfo = [[HLRightInputTypeInfo alloc]init];
        nameInfo.leftTip = _printerInfo[@"printer_name"];
        nameInfo.text = [_printerInfo[@"is_print"] integerValue] == 1?@"已连接":@"未连接";
        nameInfo.enabled = false;
        nameInfo.cellHeight = FitPTScreen(50);
        _nameInfo = nameInfo;
        
        HLRightInputTypeInfo * printInfo = [[HLRightInputTypeInfo alloc]init];
        printInfo.leftTip = @"打印机设置";
        printInfo.enabled = false;
        printInfo.cellHeight = FitPTScreen(50);
        printInfo.showRightArrow = YES;
        
        HLRightInputTypeInfo * contentInfo = [[HLRightInputTypeInfo alloc]init];
        contentInfo.leftTip = @"打印机内容设置";
        contentInfo.enabled = false;
        contentInfo.cellHeight = FitPTScreen(50);
        contentInfo.showRightArrow = YES;
        
        HLRightInputTypeInfo * reNameInfo = [[HLRightInputTypeInfo alloc]init];
        reNameInfo.leftTip = @"重命名";
        reNameInfo.enabled = false;
        reNameInfo.cellHeight = FitPTScreen(50);
        
        HLRightInputTypeInfo * offInfo = [[HLRightInputTypeInfo alloc]init];
        offInfo.leftTip = @"断开连接";
        offInfo.enabled = false;
        offInfo.cellHeight = FitPTScreen(50);
        offInfo.leftTipColor = UIColorFromRGB(0xFF8604);
        
        NSArray * first = @[nameInfo,printInfo,contentInfo];
        NSArray * second = @[reNameInfo,offInfo];
        _datasource = @[first,second];
        
    }
    return _datasource;
}

@end
