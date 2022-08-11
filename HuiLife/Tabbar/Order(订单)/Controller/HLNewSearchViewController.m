//
//  HLNewSearchViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/24.
//

#import "HLNewSearchViewController.h"
#import "HLBLEManager.h"
#import "HLPrinterSettingAlertView.h"
#import "HLRefundViewController.h"
#import "HLBaseOrderLayout.h"
#import "HLOrderBaseTableCell.h"
#import "HLOrderLayoutManager.h"
#import "HLOrderOpetionHelper.h"
#import "HLNavigateViewController.h"
#import "HLOrderQrcodeView.h"

@interface HLNewSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, HLOrderOpetionDelegate>

@property(strong,nonatomic)UITextField *searchBar;

@property(strong,nonatomic)UITableView * tableView;

@property (strong,nonatomic)UIView *titleView;

@property (strong,nonatomic)NSMutableArray * dataSource;

@property(copy,nonatomic)NSString *searchText;

@end

@implementation HLNewSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _titleView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    _titleView.hidden = YES;
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)initSubView{
    self.view.backgroundColor = [UIColor whiteColor];
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(FitPTScreen(47), FitPTScreenH(30), FitPTScreen(253), FitPTScreen(29))];
    _titleView.center = self.navigationController.navigationBar.center;
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.cornerRadius = 3;
     [self.navigationController.view addSubview:_titleView];
    
    _searchBar = [[UITextField alloc]init];
    _searchBar.placeholder = @"订单号";
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0,FitPTScreen(245), FitPTScreen(29));
    
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    _searchBar.layer.cornerRadius  = 3.0f;
    _searchBar.layer.borderColor   = [UIColor clearColor].CGColor;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchBar.textColor = [UIColor blackColor];
    _searchBar.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    _searchBar.tintColor = [UIColor hl_StringToColor:@"#FF8D26"];
    _searchBar.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    [_searchBar addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    [self.navigationItem.titleView sizeToFit];
    [_titleView addSubview:_searchBar];
   
      UIView * imgBgV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, FitPTScreen(29))];
      _searchBar.leftViewMode = UITextFieldViewModeAlways;
      _searchBar.leftView = imgBgV;
    
    UIImageView * searchImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    searchImgV.contentMode = UIViewContentModeScaleAspectFit;
    searchImgV.image = [UIImage imageNamed:@"search_grey"];
    searchImgV.center = CGPointMake(CGRectGetMaxX(imgBgV.bounds)/2, CGRectGetMaxY(imgBgV.bounds)/2);
    [imgBgV addSubview:searchImgV];

    
    [self initTableView];
}

-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    /** 以下三行，防止刷新时 cell 抖动*/
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.backgroundColor = UIColorFromRGB(0xf6f7f6);
    AdjustsScrollViewInsetNever(self, _tableView);
    [self.view addSubview:_tableView];
}


#pragma mark -UISearchBarDelegate
- (void)textFieldEditing:(UITextField *)sender{
   if (![sender.text hl_isAvailable]) {
       [self.dataSource removeAllObjects];
       [self.tableView reloadData];
       [self.tableView removeEmptyView];
   }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    _searchText = textField.text;
    [self loadSearchOrderData];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseOrderLayout *layout = self.dataSource[indexPath.row];
    HLOrderBaseTableCell *cell = (HLOrderBaseTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:layout.orderModel.identifier indexPath:indexPath];
    cell.orderLayout = layout;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseOrderLayout *layout = self.dataSource[indexPath.row];
    return layout.totalHight;
}

#pragma mark - 搜索
- (void)loadSearchOrderData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/OrderListNew.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id":_searchText};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleDataWithData:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDataWithData:(NSArray*)datas {
    
    NSDictionary * dataDict = datas.firstObject;
    [self.dataSource removeAllObjects];
    NSArray * info = dataDict[@"info"];
    for (int i=0; i<info.count; i++) {
       HLBaseOrderLayout *scanLayout = [HLOrderLayoutManager orderLayoutWithDict:info[i] tableView:_tableView];
       [self.dataSource addObject:scanLayout];
    }
    
    if (self.dataSource.count > 0) {
        [self.tableView removeEmptyView];
    }
    
    if (self.dataSource.count == 0 ) {
        [HLEmptyDataView emptyViewWithFrame:self.tableView.bounds superView:self.tableView type:@"1" balock:^{
            
        }];
    }
    
    [self.tableView reloadData];
}

#pragma mark - HLOrderOpetionDelegate
- (void)hl_reloadOrderViewCellHightWithLayout:(HLBaseOrderLayout *)layout {
    NSInteger index = [self.dataSource indexOfObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)hl_goToNavigatePageWithLayout:(HLBaseOrderLayout *)layout {
    HLNavigateViewController *navigate = [[HLNavigateViewController alloc] init];
    HLScanOrderModel *model = (HLScanOrderModel *)layout.orderModel;
    navigate.address = model.address;
    UIViewController *vc = [self fatherController];
    if (vc) {
        [vc hl_pushToController:navigate];
    }
}

//处理服务器返回的按钮 的事件
- (void)hl_functionWithName:(NSString *)name orderLayout:(HLBaseOrderLayout *)layout {
    HLBaseOrderModel *orderModel = layout.orderModel;
    if ([orderModel isKindOfClass:[HLScanOrderModel class]]) {
        HLScanOrderModel *scanModel = (HLScanOrderModel *)orderModel;
        if (scanModel.dispatchType == 0 && scanModel.dispatch_mobile.length) {
            [HLTools callPhone:scanModel.dispatch_mobile];
            return;
        }
       
        //        展示二维码
        if (scanModel.dispatchType == 1 && scanModel.qr_code.length) {
            [HLOrderQrcodeView showWithQrcode:scanModel.qr_code];
        }
    }
}

- (void)hl_functionWithTypeIndex:(NSInteger)index orderLayout:(HLBaseOrderLayout *)layout {
    HLLog(@"index = %ld",index);
    switch (index) {
        case 1://配送
        {
            [HLOrderOpetionHelper hl_deliverdWithModel:layout.orderModel completion:^{
                [HLTools showWithText:@"配送成功"];
                [HLNotifyCenter postNotificationName:HLNewOrderReloadDataNotifi object:nil];
                [self hl_goback];
            }];
            
        }break;
        case 5://送达
        {
            [HLOrderOpetionHelper hl_arrivedWithModel:layout.orderModel completion:^{
                [HLTools showWithText:@"送达成功"];
                [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"0",@"1",@"2"]];
                [self hl_goback];
            }];
            
        }break;
        case 4://自提
        {
            [HLOrderOpetionHelper hl_MentionWithModel:layout.orderModel completion:^{
                [HLTools showWithText:@"自提成功"];
                [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"0",@"1",@"2"]];
            }];
            
        }break;
            
        case 2://打印
        {
            [HLOrderOpetionHelper hl_wifiListWithModel:layout.orderModel completion:^(NSArray * _Nonnull printers) {
                [HLPrinterSettingAlertView showWithTitle:@"打印机" type:HLPrinterViewStyleDefault dataSource:printers selects:^(BOOL blueTooth, NSArray * _Nonnull selects) {
                    [[HLBLEManager shared]printeDataWithOrderId:layout.orderModel.order_id blueTooth:blueTooth wifiSn:[self printerSnWithSelects:selects] type:1 success:^{
                        
                    }];
                }];
            }];
            
        }break;
        case 3://退款
        {
            HLScanOrderModel *model = (HLScanOrderModel *)layout.orderModel;
            if (model.refund == 1) {
                [HLTools showWithText:model.refund_txt];
                return;
            }
            HLRefundViewController *refundVC = [[HLRefundViewController alloc] init];
            refundVC.orderid = model.order_id;
            [self hl_pushToController:refundVC];
        }break;
        default:
            break;
    }
}

//选择的WiFi打印机
- (NSString *)printerSnWithSelects:(NSArray *)selects{
    NSMutableArray * arr = [NSMutableArray array];
    for (HLPrinterItemModel *model in selects) {
        if (!model.isBluetooth) {
            [arr addObject:model.Id];
        }
    }
    return [arr mj_JSONString];
}

#pragma mark -SET&GET
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     [self.searchBar resignFirstResponder];
}

@end
