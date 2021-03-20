//
//  HLOPtionDescController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/10/16.
//

#import "HLOPtionDescController.h"
#import "HLOptionDescTableCell.h"
#import "HLPlayManager.h"

@interface HLOPtionDescController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) NSInteger page;

@property(nonatomic, strong) NSMutableArray *datasource;

@property(nonatomic, assign) BOOL loaded;

@end

@implementation HLOPtionDescController

- (void)viewWillAppear:(BOOL)animated {
    
}

#pragma mark - publicMethod
- (void)resetFrame {
    self.tableView.frame = self.view.frame;
}

- (void)loadOptionDesList {
    if (_loaded) return;
    _page = 1;
    [self loadDataWithLoading:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = FitPTScreen(108);
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.showsVerticalScrollIndicator = false;
        AdjustsScrollViewInsetNever(self, _tableView);
        [_tableView registerClass:[HLOptionDescTableCell class] forCellReuseIdentifier:@"HLOptionDescTableCell"];
        
        [_tableView headerNormalRefreshingBlock:^{
            self.page = 1;
            [self loadDataWithLoading:false];
        }];
        
        [_tableView footerWithEndText:@"没有更多数据" refreshingBlock:^{
            self.page ++;
            [self loadDataWithLoading:false];
        }];
        
        [_tableView hideFooter:YES];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLOptionDescTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLOptionDescTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HLOptionModel *model = self.datasource[indexPath.row];
    if (!model.address.length) {
        HLShowHint(@"视频有误，请联系客服", self.view);
        return;
    }
    HLPlayManager *playManager = [[HLPlayManager alloc] initWithVideoUrl:model.address preImgUrl:@""];
    playManager.centerTitle = model.title;
    [self.navigationController pushViewController:playManager animated:YES];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

#pragma mark -
- (void)loadDataWithLoading:(BOOL)loading {
    if (loading) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/shopplus/Customerservice/ps";
        request.serverType = HLServerTypeStoreService;
        request.parameters =@{@"page" : @(self.page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleDataWithDict:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
    }];
}

- (void)handleDataWithDict:(NSDictionary *)dict {
    NSArray * list = dict[@"items"];
    if (self.page == 1) {
        [self.datasource removeAllObjects];
    }
    NSArray * datas = [HLOptionModel mj_objectArrayWithKeyValuesArray:list];
    [self.datasource addObjectsFromArray:datas];
    
    if (list.count == 0) { [self.tableView endNomorData]; }
    
    if (self.datasource.count) {
        [self.tableView hideFooter:false];
        self.loaded = YES;
    }
    
    [self.tableView reloadData];
}
@end
