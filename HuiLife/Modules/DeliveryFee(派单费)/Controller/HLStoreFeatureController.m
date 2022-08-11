//
//  HLStoreFeatureController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
// 本店特色

#import "HLStoreFeatureController.h"
#import "HLSpecialTableHead.h"
#import "HLFeatureTableCell.h"
#import "HLFeatureMainInfo.h"
#define bottomViewH FitPTScreen(130)

@interface HLStoreFeatureController () <UITableViewDelegate, UITableViewDataSource, HLSpecialTableHeadDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) HLSpecialTableHead *tableHeader;
@property(nonatomic, strong) HLFeatureMainInfo *mainInfo;

@end

@implementation HLStoreFeatureController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"本店特色"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultDataWithPargram:nil];
}

#pragma mark - request
- (void)loadDefaultDataWithPargram:(NSDictionary *)pargram {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/SpecialLabelSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram?:@{};
        request.httpMethod = kXMHTTPMethodPOST;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        [self initSubView];
        if (result.code == 200) {
            if (!pargram) {
                self.mainInfo = [HLFeatureMainInfo mj_objectWithKeyValues:result.data];
                self.tableHeader.on = self.mainInfo.is_open;
                [self.tableView reloadData];
                return;
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
    NSMutableDictionary *pargram = [NSMutableDictionary dictionary];
    [pargram setObject:@(_mainInfo.is_open) forKey:@"is_open"];
    BOOL empty = NO;
    for (HLFeatureInfo *info in _mainInfo.datasource) {
        if (info.value.length) {
            empty = YES;
        }
        [pargram setObject:info.value forKey:info.key];
    }
    
    if (!empty) {
        [HLTools showWithText:@"请至少设置一个特色标签"];
        return;
    }
    
    [self loadDefaultDataWithPargram:pargram];
}

#pragma mark - HLSpecialTableHeadDelegate
- (void)tableHead:(HLSpecialTableHead *)tableHead open:(BOOL)open {
    _mainInfo.is_open = open;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mainInfo.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLFeatureTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLFeatureTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = _mainInfo.datasource[indexPath.row];
    return cell;
}
#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH -Height_NavBar - bottomViewH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = FitPTScreen(55);
    _tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, _tableView);
    [self.view addSubview:_tableView];
    
    _tableHeader = [[HLSpecialTableHead alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(74))];
    _tableHeader.title = @"是否开启特色标签";
    _tableHeader.hideLine = YES;
    _tableHeader.delegate = self;
    self.tableView.tableHeaderView = _tableHeader;
    
    [_tableView registerClass:[HLFeatureTableCell class] forCellReuseIdentifier:@"HLFeatureTableCell"];
    
    
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


@end
