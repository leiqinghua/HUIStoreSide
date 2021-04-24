//
//  HLVideoProductListController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/23.
//

#import "HLVideoProductListController.h"
#import "HLVideoProductModel.h"
#import "HLVideoProductViewCell.h"

@interface HLVideoProductListController () <UITableViewDelegate,UITableViewDataSource,HLVideoProductViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger page;       // page， 默认为1
@property (nonatomic, assign) NSInteger pageSize;   // 默认为10

@end

@implementation HLVideoProductListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _pageSize = 10;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    AdjustsScrollViewInsetNever(self, self.tableView);
        
    /// 加载数据
    [self reloadListData];
}

#pragma mark - Private Method

// 重新加载页面数据，page置为 1
- (void)reloadListData{
    self.page = 1;
    [self loadListData:YES];
}

// 加载数据
- (void)loadListData:(BOOL)hud{
    if (hud) {
        HLLoading(self.view);
    }
    NSDictionary *params = @{@"pageNo":@(_page),@"type":@(_type),@"mode":@"1"};
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/push/productList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = params;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *models = [HLVideoProductModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
            [self handleBuyGoodsModels:models];
        }else{
            if (self.page == 1) {
                weakify(self);
                [self hl_showNetFail:self.view.bounds callBack:^{
                    [weak_self reloadListData];
                }];
            }
            self.page > 1 ? 1 : --self.page;
        }
    } onFailure:^(NSError * _Nullable error) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if (self.page == 1) {
            weakify(self);
            [self hl_showNetFail:self.view.bounds callBack:^{
                [weak_self reloadListData];
            }];
        }
        self.page > 1 ? 1 : --self.page;
    }];
}

/// 处理数据
- (void)handleBuyGoodsModels:(NSArray *)models{
    
    [self.tableView.mj_header endRefreshing];
    
    // 如果是第一页
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (models.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.dataSource addObjectsFromArray:models];
    [self.tableView reloadData];
    
    self.tableView.mj_footer.hidden = self.dataSource.count == 0;
}

#pragma mark - HLVideoProductViewCellDelegate

- (void)productViewCell:(HLVideoProductViewCell *)cell selectProductModel:(HLVideoProductModel *)model{
    if (self.productSelectBlock) {
        self.productSelectBlock(model, self.type);
    }
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLVideoProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLVideoProductViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.pro_id = self.pro_id;
    cell.showOrinalPrice = self.type == 1;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - Getter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColorFromRGB(0xEDEDED);
        _tableView.rowHeight = FitPTScreen(121);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLVideoProductViewCell class] forCellReuseIdentifier:@"HLVideoProductViewCell"];
        weakify(self);
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.page = 1;
            [weak_self loadListData:NO];
        }];
        mj_header.lastUpdatedTimeLabel.hidden = YES;
        
        _tableView.mj_header = mj_header;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.page++;
            [weak_self loadListData:NO];
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

