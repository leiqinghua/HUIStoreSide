//
//  HLDiscountSetController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import "HLDiscountSetController.h"
#import "HLSpecialTableHead.h"
#import "HLDiscountSetTableCell.h"
#import "HLDiscountMainInfo.h"

#define bottomViewH FitPTScreen(130)

@interface HLDiscountSetController ()<UITableViewDelegate, UITableViewDataSource, HLSpecialTableHeadDelegate, HLDiscountSetTableCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) HLSpecialTableHead *tableHeader;
@property(nonatomic, strong) HLDiscountMainInfo *mainInfo;
@property(nonatomic, strong) NSMutableArray *datasource;
@end

@implementation HLDiscountSetController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"外卖折扣设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultData];
}

#pragma mark - request
- (void)loadDefaultData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/TakeAwayDiscountSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
        request.httpMethod = kXMHTTPMethodPOST;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        [self initSubView];
        if (result.code == 200){
            [self handleDefaultData:result.data];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDefaultData:(NSDictionary *)dict {
    _mainInfo = [HLDiscountMainInfo mj_objectWithKeyValues:dict];
    _tableHeader.title = _mainInfo.open_title;
    _tableHeader.subTitle = _mainInfo.open_label;
    _tableHeader.on = _mainInfo.is_open;
    if (_mainInfo.discount_set.count) {
        [self.datasource removeAllObjects];
    }
    [self.datasource addObjectsFromArray:_mainInfo.discount_set];
    HLDiscountInfo *info = self.datasource.firstObject;
    info.add = YES;
    
    [self.tableView reloadData];
}

//保存
- (void)saveDataWithPargram:(NSString *)pargram {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/TakeAwayDiscountSetAc.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"is_discount":@(_mainInfo.is_open),@"item_discount":pargram};
        request.httpMethod = kXMHTTPMethodPOST;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        [self initSubView];
        if (result.code == 200){
            if (self.HLDiscountCallBack) {
                self.HLDiscountCallBack(_mainInfo.is_open);
            }
            [HLTools showWithText:@"保存成功"];
            [self hl_goback];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - Event
//保存
- (void)saveClick {
    NSMutableArray *jsons = [NSMutableArray array];
    for (HLDiscountInfo *info in self.datasource) {
        if (![info check]) {
            [HLTools showWithText:info.toasStr];
            return;
        }
        if (info.canSave) {
            [jsons addObject:info.pargrams];
        }
    }
    
    if (_mainInfo.is_open && !jsons.count) {
        [HLTools showWithText:@"最少设置一个"];
        return;
    }
    
    [self saveDataWithPargram:[jsons mj_JSONString]];
}

#pragma mark - Method
- (HLDiscountInfo *)createDiscountInfo {
    HLDiscountInfo *info = [[HLDiscountInfo alloc]init];
    info.title = @"订单满";
    info.unit = @"折";
    info.label = @"元则享受";
    info.discount = [NSString stringWithFormat:@"%ld",_mainInfo.limit_num];
    return info;
}

#pragma mark - HLSpecialTableHeadDelegate
- (void)tableHead:(HLSpecialTableHead *)tableHead open:(BOOL)open {
    _mainInfo.is_open = open;
}

#pragma mark - HLDiscountSetTableCellDelegate
- (void)discountCell:(HLDiscountSetTableCell *)cell add:(BOOL)add {
    if (add) {
        if (self.datasource.count >= 10) {
            [HLTools showWithText:@"最多可添加10个"];
            return;
        }
        HLDiscountInfo *info = [self createDiscountInfo];
        [self.datasource addObject:info];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datasource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        HLDiscountInfo *info = cell.info;
        NSInteger index = [self.datasource indexOfObject:info];
        [self.datasource removeObject:info];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLDiscountSetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLDiscountSetTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.limitNum = _mainInfo.limit_num;
    cell.info = self.datasource[indexPath.row];
    return cell;
}
#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH -Height_NavBar - bottomViewH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = FitPTScreen(60);
    _tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, _tableView);
    [self.view addSubview:_tableView];
    
    _tableHeader = [[HLSpecialTableHead alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(74))];
    _tableHeader.title = @"是否开启外卖折扣";
    _tableHeader.subTitle = @"让HUI卡会员享受不同折扣";
    _tableHeader.delegate = self;
    self.tableView.tableHeaderView = _tableHeader;
    
    [_tableView registerClass:[HLDiscountSetTableCell class] forCellReuseIdentifier:@"HLDiscountSetTableCell"];
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), ScreenW, bottomViewH)];
    [self.view addSubview:bottomView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [bottomView addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"button_bag"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(30));
    }];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        HLDiscountInfo *info = [self createDiscountInfo];
        info.add = YES;
        [_datasource addObject:info];
    }
    return _datasource;
}
@end
