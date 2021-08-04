//
//  HLBillViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import "HLBillViewController.h"
#import "HLBillTableViewCell.h"
#import "HLBillHeaderView.h"
#import "HLBillModel.h"

@interface HLBillViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView* tableView;

@property(strong,nonatomic)NSMutableArray *dataSource;

@end

@implementation HLBillViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"账单"];
    [self hl_interactivePopGestureRecognizerUseable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self initSubView];
    [self loadWillEntryData];
}

-(void)initSubView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = FitPTScreen(72);
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self,_tableView);
    
    
    HLBillHeaderView * headerView = [[HLBillHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, _isEntried?FitPTScreen(107):FitPTScreen(138)) type: _isEntried?1:0];
    headerView.date = _date;
    _tableView.tableHeaderView = headerView;
    
    [_tableView registerClass:[HLBillTableViewCell class] forCellReuseIdentifier:@"HLBillTableViewCell"];
    
    [HLEmptyDataView emptyViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-Height_NavBar) superView:_tableView type:@"0" balock:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBillTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLBillTableViewCell" forIndexPath:indexPath];
    
    HLBillModel * model = self.dataSource[indexPath.row];
    model.hideLine = indexPath.row == self.dataSource.count-1;
//    model.topCorner = indexPath.row == 0;
//    model.bottomCorner =indexPath.row == self.dataSource.count-1;
    cell.billModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)loadWillEntryData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/MerchantWithlist.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"date":_date?:@""};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleDataWithModel:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
    }];
}

-(void)handleDataWithModel:(NSArray *)datas{
    if (datas.count == 0) {
        return;
    }
    NSDictionary * dict = datas.firstObject;
    HLBillHeaderView * headerView = (HLBillHeaderView *)self.tableView.tableHeaderView;
    headerView.info = dict;
    
    NSArray * models = [HLBillModel mj_objectArrayWithKeyValuesArray:dict[@"info"]];
    [self.dataSource addObjectsFromArray:models];
    [self.tableView reloadData];
    if (self.dataSource.count>0) {
        [self.tableView removeEmptyView];
    }
    
}

@end
