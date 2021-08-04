//
//  HLCardManageController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/4.
//

#import "HLCardManageController.h"
#import "HLCusCardTableCell.h"
#import "HLCustomerInfo.h"

@interface HLCardManageController () <UITableViewDelegate, UITableViewDataSource, HLCardManageHeaderDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *noDataView;//缺省图
@property(nonatomic, assign) NSInteger page;//列表页
@property(nonatomic, assign) NSInteger searchPage;//搜索页
@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, strong) NSMutableArray *searchSource;
@property(nonatomic, strong) NSMutableArray *oriDatasource;
@property(nonatomic, assign) BOOL listNodata;//列表再无数据
@property(nonatomic, copy) NSString *totalNum;//会员总数

@end

@implementation HLCardManageController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hl_setBackImage:@"back_oriange"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    _page = 1;
    _searchPage = 1;
    [self loadCardNum];
}

#pragma mark - Request
- (void)searchWithPhone:(NSString *)phone {
    NSDictionary *pargram = @{@"pageNo":@(_searchPage),
                              @"userIdBuss":[HLAccount shared].userIdBuss?:@"",
                              @"phone":phone?:@""
                             };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/CustomerMember.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleSearchData:result.data[@"actives"]];
            return;
        }
        if (self.searchPage > 1) self.searchPage--;
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        if (self.searchPage > 1) self.searchPage--;
    }];
}

- (void)handleSearchData:(NSArray *)datas {
    NSArray *list = [HLCustomerInfo mj_objectArrayWithKeyValuesArray:datas];
    if (_searchPage == 1) [self.searchSource removeAllObjects];
    [self.searchSource addObjectsFromArray:list];
    [self.tableView hideFooter:!self.searchSource.count];
    [self showNodataView:!self.searchSource.count search:YES];
    if (!list.count) [_tableView endNomorData];
    if (!_oriDatasource.count) {
        _oriDatasource = [self.datasource mutableCopy];
        [self.datasource removeAllObjects];
    }
    [self.datasource addObjectsFromArray:self.searchSource];
    [self.tableView reloadData];
    
}


//请求列表
- (void)loadListWithHud:(BOOL)hud {
    NSDictionary *pargram = @{@"pageNo":@(_page),
                              @"userIdBuss":[HLAccount shared].userIdBuss?:@""
                             };
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/CustomerMember.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handListDatas:result.data[@"actives"]];
            return;
        }
        if (self.page > 1) self.page--;
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        if (self.page > 1) self.page--;
    }];
}

- (void)handListDatas:(NSArray *)datas {
    NSArray *list = [HLCustomerInfo mj_objectArrayWithKeyValuesArray:datas];
    if (_page == 1) [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:list];
    [self.tableView hideFooter:!self.datasource.count];
    [self showNodataView:!self.datasource.count search:NO];
    if (!list.count) [_tableView endNomorData];
    _listNodata = !list.count;
    [self.tableView reloadData];
}
//会员统计
- (void)loadCardNum {
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/CustomerCount.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"userIdBuss":[HLAccount shared].userIdBuss?:@""};
    } onSuccess:^(id responseObject) {
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            self.totalNum = [NSString stringWithFormat:@"%@",result.data[@"sum"]];
            NSString *numStr = [NSString stringWithFormat:@"会员总数（%@）",result.data[@"sum"]];
            [self hl_setTitle:numStr];
            [self loadListWithHud:YES];
            return;
        }
        [self hl_setTitle:@"会员管理"];
    }onFailure:^(NSError *error) {
        [self hl_setTitle:@"会员管理"];
    }];
}
#pragma mark - Event
//导出
- (void)exportClick {
    [HLTools pushAppPageLink:@"HLExportViewController" params:@{@"num":_totalNum?:@"0"} needBack:NO];
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show search:(BOOL)search{
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(FitPTScreen(127), FitPTScreen(121), FitPTScreen(133), FitPTScreen(150))];
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_cus_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(10));
            make.centerX.equalTo(self.noDataView);
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = search?@"没有找到相关的信息":@"没有相关信息";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    
    _noDataView.hidden = !show;
}
#pragma mark - HLCardManageHeaderDelegate
- (void)manageHeader:(HLCardManageHeader *)header textEdit:(NSString *)text {
    if (!text.length) {
        [self.searchSource removeAllObjects];
        if (_oriDatasource.count) {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:_oriDatasource];
            [_oriDatasource removeAllObjects];
        }
        [self showNodataView:!self.datasource.count search:NO];
        [self.tableView hideFooter:!self.datasource.count];
        if (!_listNodata) [self.tableView resetFooter];
        [self.tableView reloadData];
    }
}

- (void)manageHeader:(HLCardManageHeader *)header search:(NSString *)text {
    if (!text.length) {
        HLShowHint(@"搜索内容不能为空", self.view);
        return;
    }
    [self.tableView endEditing:YES];
    self.searchPage = 1;
    [self searchWithPhone:text];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLCusCardTableCell *cell = (HLCusCardTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLCusCardTableCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = self.datasource[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HLCardManageHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLCardManageHeader"];
    header.delegate = self;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FitPTScreen(51);
}
#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.rowHeight = FitPTScreen(135);
    _tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    [_tableView registerClass:[HLCardManageHeader class] forHeaderFooterViewReuseIdentifier:@"HLCardManageHeader"];
    
//    footer
    [_tableView footerWithEndText:@"暂无更多数据" refreshingBlock:^{
        self.page += 1;
        [self loadListWithHud:NO];
    }];
    [_tableView hideFooter:YES];
//    导出
    UIButton *exportBtn = [UIButton hl_regularWithTitle:@"导出" titleColor:@"#FE9E30" font:13 image:@""];
    UIBarButtonItem *exportItem = [[UIBarButtonItem alloc]initWithCustomView:exportBtn];
    self.navigationItem.rightBarButtonItem = exportItem;
    [exportBtn addTarget:self action:@selector(exportClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)searchSource {
    if (!_searchSource) {
        _searchSource = [NSMutableArray array];
    }
    return _searchSource;
}
@end


//section header
@interface HLCardManageHeader ()
@property(nonatomic, strong) UITextField *textField;
@end

@implementation HLCardManageHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.contentView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(FitPTScreen(12), FitPTScreen(10),FitPTScreen(314), FitPTScreen(30))];
    searchView.backgroundColor = UIColor.whiteColor;
    searchView.layer.cornerRadius = FitPTScreen(2.5);
    [self addSubview:searchView];
    
    UIImageView *picImV = [[UIImageView alloc]init];
    picImV.image = [UIImage imageNamed:@"search_grey"];
    [searchView addSubview:picImV];
    [picImV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.centerY.equalTo(searchView);
    }];
    _textField = [[UITextField alloc]init];
    _textField.textColor = UIColorFromRGB(0x222222);
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    NSAttributedString *placeAttr = [[NSAttributedString alloc]initWithString:@"输入会员手机号" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xCDCDCD)}];
    _textField.attributedPlaceholder = placeAttr;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(picImV.right).offset(FitPTScreen(6));
        make.centerY.equalTo(picImV);
        make.size.equalTo(CGSizeMake(FitPTScreen(200), FitPTScreen(25)));
    }];
    
    UIButton *searchBtn = [UIButton hl_regularWithTitle:@"查询" titleColor:@"#555555" font:13 image:@""];
    [self.contentView addSubview:searchBtn];
    [searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(searchView);
    }];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [_textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)searchClick {
    if ([self.delegate respondsToSelector:@selector(manageHeader:search:)]) {
        [self.delegate manageHeader:self search:_textField.text];
    }
}

- (void)textFieldDidChanged:(UITextField *)sender {
    if ([self.delegate respondsToSelector:@selector(manageHeader:textEdit:)]) {
        [self.delegate manageHeader:self textEdit:sender.text];
    }
}
@end
