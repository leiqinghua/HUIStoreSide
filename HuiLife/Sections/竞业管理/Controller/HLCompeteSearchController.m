//
//  HLCompeteSearchController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/13.
//

#import "HLCompeteSearchController.h"
#import "HLCompeteBaseTableCell.h"
#import "HLCompeteStoreInfo.h"

@interface HLCompeteSearchController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *datasource;

@property(strong,nonatomic)UITextField *searchBar;

@property (strong,nonatomic)UIView *titleView;

@property(nonatomic, strong) UIView *noDataView;

@end

@implementation HLCompeteSearchController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _titleView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    _titleView.hidden = YES;
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

#pragma mark - Request
- (void)searchWithText:(NSString *)text {
    HLLoading(self.view);
    HLAccount *account = [HLAccount shared];
    NSDictionary *pargram = @{
        @"latitude":account.latitude?:@"",
        @"longitude": account.longitude?:@"",
        @"location" : account.locateJSON,
        @"keywords":text?:@""
    };
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreForbidList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray *stores = [HLCompeteStoreInfo mj_objectArrayWithKeyValuesArray:result.data[@"stores"]];
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:stores];
            [self showNodataView:!self.datasource.count];
            [self.tableView reloadData];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

//更新
- (void)updateWithStoreInfo:(HLCompeteStoreInfo *)storeInfo{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreForbidEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"store_id":storeInfo.store_id,@"action":storeInfo.state==1?@(1):@(2)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            storeInfo.state = 1-storeInfo.state;
            if (storeInfo.state == 1) { //要上架
                //通知上架页面 增加 对应店铺
                [HLNotifyCenter postNotificationName:@"KupdateCompeteUpNotifi" object:storeInfo];
                //通知下架页面 删除 对应店铺
                [HLNotifyCenter postNotificationName:@"KupReloadDataNotifi" object:storeInfo];
            } else {
                //通知上架页面 删除 对应店铺
                [HLNotifyCenter postNotificationName:@"KdownReloadDataNotifi" object:storeInfo];
                //通知下架页面 增加 对应店铺
                [HLNotifyCenter postNotificationName:@"KcompeteDownReloadNotifi" object:storeInfo];
            }
            [self.datasource removeObject:storeInfo];
            [self.tableView reloadData];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show{
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.backgroundColor = UIColor.whiteColor;
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_search_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(228));
            make.centerX.equalTo(self.noDataView);
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"没有找到相关的信息";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    _noDataView.hidden = !show;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLCompeteBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLCompeteBaseTableCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.storeInfo = self.datasource[indexPath.row];
    weakify(self);
    cell.upDownCallBack = ^(HLCompeteStoreInfo * _Nonnull storeInfo) {
        [weak_self updateWithStoreInfo:storeInfo];
    };
    return cell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchWithText:textField.text];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.datasource removeAllObjects];
    [self.tableView reloadData];
    return YES;
}

- (void)textFieldEditing:(UITextField *)textField {
    if (!textField.text.length) {
        [self.datasource removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - UIView
- (void)initSubView {
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = FitPTScreen(137);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[HLCompeteBaseTableCell class] forCellReuseIdentifier:@"HLCompeteBaseTableCell"];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(FitPTScreen(47), FitPTScreenH(30), FitPTScreen(253), FitPTScreen(29))];
    _titleView.center = self.navigationController.navigationBar.center;
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.cornerRadius = 3;
     [self.navigationController.view addSubview:_titleView];
    
    _searchBar = [[UITextField alloc]init];
    _searchBar.placeholder = @"请输入店铺名称";
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0,FitPTScreen(245), FitPTScreen(29));
    
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    _searchBar.layer.cornerRadius  = 3.0f;
    _searchBar.layer.borderColor   = [UIColor clearColor].CGColor;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchBar.textColor = [UIColor blackColor];
    _searchBar.font = [UIFont systemFontOfSize:FitPTScreen(12)];
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
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
@end
