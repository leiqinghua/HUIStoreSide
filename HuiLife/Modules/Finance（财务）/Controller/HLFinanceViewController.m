//
//  HLFinanceViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import "HLFinanceViewController.h"
#import "HLFinanceHeaderView.h"
#import "HLFinanceTableViewCell.h"
#import "HLEntryViewController.h"
#import "HLBillViewController.h"
#import "HLFinanceModel.h"
#import "HLWithdrawView.h"
#import "HLWithDrawalMainController.h"

@interface HLFinanceViewController ()<UITableViewDelegate,UITableViewDataSource,HLFinanceHeaderViewDelegate>{
    UIView * _naviView;
}

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSMutableArray * dataSource;

@property(assign,nonatomic)BOOL hiddenStatusBar;

@property(assign,nonatomic)NSInteger page;
//记录第一个组数据是第几页
@property(assign,nonatomic)NSInteger firstPage;
//是不是下拉
@property(assign,nonatomic)BOOL isPull;
//header 不悬浮
@property(assign,nonatomic)BOOL isDown;

/// 0 使用之前的提现 1 使用新的提现
@property (nonatomic, assign) NSInteger flag;
//1 点提现跳转页面，0 提示错误信息
@property (nonatomic, assign) NSInteger is_tixian_ac;
//要提示的错误信息
@property (nonatomic, assign) NSString * is_tixian_ac_msg;

@end

@implementation HLFinanceViewController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setTransparentNavtion];
    [self hl_setTitle:@"财务" andTitleColor:[UIColor whiteColor]];
    [self hl_interactivePopGestureRecognizerUseable];
    [self hl_setBackImage:@"back_white"];
}
 
//控制状态栏是否出现
-(BOOL)prefersStatusBarHidden{
    return _hiddenStatusBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self initNavi];
    _page = 1;
    [self loadDataWithLoading:YES result:nil];
}

-(void)initNavi{
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, Height_NavBar)];
    _naviView.backgroundColor = [UIColorFromRGB(0xFF8D26) colorWithAlphaComponent:0];
    [self.view addSubview:_naviView];
}

- (void)initSubView {
    self.view.backgroundColor = UIColor.whiteColor;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = FitPTScreen(75);
    AdjustsScrollViewInsetNever(self,_tableView);
    
    [_tableView registerClass:[HLFinanceTableViewCell class] forCellReuseIdentifier:@"HLFinanceTableViewCell"];
    HLFinanceHeaderView *headerView = [[HLFinanceHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreenH(370))];
    headerView.delegate = self;
    _tableView.tableHeaderView = headerView;
    [HLNotifyCenter addObserver:self selector:@selector(changeStatuBar:) name:HLStatuBarHidenNotifi object:nil];
    //添加header
    [_tableView headerNormalRefreshingBlock:^{
        self.isPull = YES;
        self.firstPage = self.firstPage >1?self.firstPage-1:1;
        self.page = self.firstPage;
        [self loadDataWithLoading:false result:nil];
    }];
    //添加footer
    [_tableView footerWithEndText:@"没有更多数据" refreshingBlock:^{
        self.isPull = NO;
        self.page ++;
        [self loadDataWithLoading:false result:nil];
    }];
    [HLEmptyDataView emptyViewWithFrame:CGRectMake(0, FitPTScreenH(250), ScreenW, ScreenH-FitPTScreenH(250)) superView:_tableView type:@"0" balock:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLFinanceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLFinanceTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBillViewController * bill = [[HLBillViewController alloc]init];
    HLFinanceModel * model = self.dataSource[indexPath.row];
    bill.date = model.month;
    bill.isEntried = model.isEntried;
    [self hl_pushToController:bill];
}

- (void)changeStatuBar:(NSNotification *)sender{
    if ([sender.object isEqual:@0]) {
        _hiddenStatusBar = NO;
    }else{
        _hiddenStatusBar = YES;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - HLFinanceHeaderViewDelegate
-(void)clickFinanceButton:(HLFinanceButton *)sender{
    if (sender.tag == 1) {//已结算
        HLEntryViewController *entry = [[HLEntryViewController alloc]init];
        [self hl_pushToController:entry];
        return;
    }
    if (sender.tag == 2) {//待结算
        HLBillViewController *bill = [[HLBillViewController alloc]init];
        bill.date = @"今天";
        [self hl_pushToController:bill];
    }
}

//提现
- (void)hlFinanceWithMoney:(NSString *)money{
    if (self.flag == 0) {
        [HLWithdrawView withDrawWithMoeny:money selectIndex:0 callBack:^(NSInteger selectIndex) {
            [self withdrawWithMoney:money];
        }];
        return;
    }
    
    if (self.is_tixian_ac) {
        HLWithDrawalMainController * withDrawalVC = [[HLWithDrawalMainController alloc] init];
        [self hl_pushToController:withDrawalVC];
        return;
    }
    
    HLShowHint(self.is_tixian_ac_msg, self.view);
    
}

-(void)selectDateWithDate:(NSString *)date{
    [self loadSelectData:date];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setNaviBarBackground];
}

-(void)setNaviBarBackground{
    CGFloat offset = self.tableView.contentOffset.y;
    UIColor * color = [UIColor hl_StringToColor:@"#FF8604"];
    if (offset<0) {
        _naviView.backgroundColor = [color colorWithAlphaComponent:0];
        CGFloat alpha = 1+offset/Height_NavBar;
        [self hl_setTitle:@"财务" andTitleColor:[UIColor.whiteColor colorWithAlphaComponent:alpha]];
    }else{
        CGFloat alpha=1-((Height_NavBar-offset)/Height_NavBar);
        _naviView.backgroundColor = [color colorWithAlphaComponent:alpha];
        [self hl_setTitle:@"财务" andTitleColor:[UIColor.whiteColor colorWithAlphaComponent:1]];
    }
    CGFloat up_hight = FitPTScreen(330) - Height_NavBar;
    HLFinanceHeaderView *headerView = (HLFinanceHeaderView *)self.tableView.tableHeaderView;
    if (offset >=up_hight && !headerView.isUp && !_isDown) {
        [headerView changeFrameWithUp:YES superView:self.view];
    }else if (offset<up_hight && headerView.isUp){
        [headerView changeFrameWithUp:NO superView:self.view];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - request
//提现
-(void)withdrawWithMoney:(NSString *)money{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/MerchantWithdrawals.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"money":money};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [HLTools showWithText:@"提现成功"];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


-(void)loadDataWithLoading:(BOOL)loading result:(void(^)(id))completion{
    if (loading)HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/MerchantWith.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"page":@(_page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        [self handleError:result.code error:nil];
        if(result.code == 200){
            if(completion) completion(result.data);
            [self handleDataWithModel:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
    }];
    
    
}

-(void)handleDataWithModel:(id)data{
    NSArray * datas = data;
    if (datas.count == 0) {
        return;
    }
    NSDictionary * dict = datas.firstObject;
    HLFinanceHeaderView *headerView = (HLFinanceHeaderView *)[self.tableView tableHeaderView];
    headerView.info = dict;
    
    self.flag = [dict[@"flag"] integerValue];
    self.is_tixian_ac = [dict[@"is_tixian_ac"] integerValue];
    self.is_tixian_ac_msg = dict[@"is_tixian_ac"];
    
    if (_isPull) {
        [self.dataSource removeAllObjects];
    }
    NSArray * models = [HLFinanceModel mj_objectArrayWithKeyValuesArray:dict[@"info"]];
    [self.dataSource addObjectsFromArray:models];
    [self.tableView reloadData];
    if (models.count == 0) {
        [self.tableView endNomorData];
    }
    if (self.dataSource.count > 0) {
        [self.tableView removeEmptyView];
    }
}

- (void)loadSelectData:(NSString *)date{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/MerchantWith.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"date":date,@"type":@"2"};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleSelectData:result.data date:date];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)handleSelectData:(NSArray*)datas date:(NSString *)date{
 
    NSDictionary * data = datas.firstObject;
    
    if ([data[@"page"] integerValue] == 0) {
        _page = 1;
    }else{
        _page = [data[@"page"] integerValue];
    }
    _firstPage = _page;
    
    [self loadMutablePageDataWithDate:date];
    
}
//加载多页数据
-(void)loadMutablePageDataWithDate:(NSString *)date{
    dispatch_group_t group = dispatch_group_create();
    NSArray __block * first;
    dispatch_group_enter(group);
    [self loadDataWithLoading:YES result:^(id data) {
        first = [self datasWithBaseModel:data];
        dispatch_group_leave(group);
    }];
    
    NSArray __block * second;
    dispatch_group_enter(group);
    self.page +=1;
    [self loadDataWithLoading:YES result:^(id data) {
//        NSLog(@"第二个数据加载完毕");
        second = [self datasWithBaseModel:data];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:first];
        [self.dataSource addObjectsFromArray:second];
        [self.tableView reloadData];
        [self scrollAtIndexPathWithArray:self.dataSource date:date];
    });
}

//滚动到指定位置
-(void)scrollAtIndexPathWithArray:(NSArray *)arr date:(NSString *)date{

    __block NSInteger index = -1;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HLFinanceModel * model = (HLFinanceModel *)obj;
        if ([model.month isEqualToString:date]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != -1) {
        if (self.dataSource.count > 4) {
            self.tableView.contentInset = UIEdgeInsetsMake(Height_NavBar + FitPTScreenH(40), 0, 0, 0);
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        [HLTools showWithText:@"该日无订单信息"];
    }
}

-(NSArray *)datasWithBaseModel:(id)data{
    NSArray * datas = data;
    if (datas.count == 0) {
        return @[];
    }
    NSDictionary * dict = datas.firstObject;
    NSArray * models = [HLFinanceModel mj_objectArrayWithKeyValuesArray:dict[@"info"]];
    return models;
}

-(void)handleError:(NSInteger)code error:(NSString *)error{
    if (code == 200) {
        return;
    }
    if (self.isPull) {
        self.firstPage = self.firstPage > 1?self.firstPage +1:1;
    }else{
        self.page = self.page > 1?self.page -1:1;
    }
}

-(void)dealloc{
    [HLNotifyCenter removeObserver:self];
}

@end
