//
//  HLMessageViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/9/12.
//

#import "HLMessageViewController.h"
#import "HLMessageHeaderView.h"
#import "HLMessageTableViewCell.h"
#import "HLMessageDetailController.h"
#import "AppDelegate.h"
#import "UITabBar+HLBadge.h"
#import "HLEmptyDataView.h"
#import <JPUSHService.h>

@interface HLMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) NSInteger page;

@property(strong,nonatomic)UITableView * tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation HLMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"消息"];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:Is_have_message]) {
        [self reload:nil];
    }
}

-(void)hl_resetNetworkForAction{
    if (!self.dataSource.count) {
        _page = 1;
        [self loadDataWithPage:_page loading:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload:) name:HLReloadMessagePageNotifi object:nil];
    [self hideBadge];
    
    // 第一次拉去数据
    _page = 1;
    [self loadDataWithPage:_page loading:YES];
}



#pragma mark - HLReloadMessagePageNotifi
-(void)reload:(NSNotification *)sender{
    [self hideBadge];
    // 这里重置page
    _page = 1;
    [self loadDataWithPage:_page loading:YES];
}

- (void)loadDataWithPage:(NSInteger)page loading:(BOOL)loading{
    if (page == 1) {
        [self.dataSource removeAllObjects];
    }
    if (loading) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/MessageList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"page":@(_page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self hl_hideNetFail];
           [self handleResultData:result];
            return;
        }
        if (_page > 1) _page --;
        [self hl_showNetFail:self.view.bounds callBack:^{
            [self loadDataWithPage:self.page loading:YES];
        }];
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        if (_page > 1) _page --;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hl_showNetFail:self.view.bounds callBack:^{
            [self loadDataWithPage:self.page loading:YES];
        }];
    }];
    
}

- (void)handleResultData:(XMResult *)result{

    if ([result.data count] == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    
    for (NSDictionary *dict in result.data) {
        // 检查之前是否存在
        NSDictionary *existDict = [self checkMonthExist:dict[@"month"]];
        if(existDict){
            NSMutableArray *mArr = existDict[@"info"];
            [mArr addObjectsFromArray:[HLMessageListModel mj_objectArrayWithKeyValuesArray:dict[@"info"]]];
        }else{
            NSArray *info = dict[@"info"];
            NSDictionary *dataDict = @{@"info":[HLMessageListModel mj_objectArrayWithKeyValuesArray:info],@"month":dict[@"month"]};
            [self.dataSource addObject:dataDict];
        }
    }
    if (self.dataSource.count == 0) {
        [HLEmptyDataView emptyViewWithFrame:self.tableView.bounds superView:self.tableView type:@"0" balock:^{
            
        }];
    }else{
        [self.tableView removeEmptyView];
    }
    [self.tableView reloadData];
}

- (NSDictionary *)checkMonthExist:(NSString *)checkMonth{
    if (!self.dataSource.count) {
        return nil;
    }
    
    __block NSDictionary *result = nil;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *month = obj[@"month"];
        if ([month isEqualToString:checkMonth]) {
            result = obj;
            *stop = YES;
        }
    }];
    return result;
}

-(void)hideBadge{
    AppDelegate * delegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
    [delegate.mainTabBarVC.tabBar hideBadgeOnItemIndex:3];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:Is_have_message];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
}
#pragma mark - UI
-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, ScreenW, ScreenH-Height_NavBar) style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 45;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_tableView registerClass:[HLMessageTableViewCell class] forCellReuseIdentifier:@"HLMessageTableViewCell"];
    [_tableView registerClass:[HLMessageHeaderView class] forHeaderFooterViewReuseIdentifier:@"HLMessageHeaderView"];
    AdjustsScrollViewInsetNever(self,_tableView);
    
    __weak typeof(self) weakSelf = self;
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf loadDataWithPage:weakSelf.page loading:false];
    }];
    self.tableView.mj_footer = footer;
    footer.hidden = YES;
    
    MJRefreshHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadDataWithPage:weakSelf.page loading:false];
    }];
    self.tableView.mj_header = header;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataSource[section][@"info"];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLMessageTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = self.dataSource[indexPath.section][@"info"];
    cell.listModel = array[indexPath.row];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HLMessageHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLMessageHeaderView"];
    headerView.time = self.dataSource[section][@"month"];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitPTScreen(45);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLMessageDetailController * msgDetailVC = [[HLMessageDetailController alloc]init];
    if(indexPath.section > self.dataSource.count - 1){
        return;
    }
    NSArray *array = self.dataSource[indexPath.section][@"info"];
    msgDetailVC.listModel = array[indexPath.row];
    [self hl_pushToController:msgDetailVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
