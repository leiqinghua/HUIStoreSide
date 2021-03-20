//
//  HLVoucherBankQueryController.m
//  HuiLife
//
//  Created by 王策 on 2019/9/2.
//

#import "HLVoucherBankQueryController.h"

#import "HLAreaSelectView.h"
#import "HLDownSelectView.h"
#import "HLImageSinglePickerController.h"
#import "HLRightImageViewCell.h"
#import "HLRightInputViewCell.h"
#import "HLSelectArea.h"
#import "HLSinglePickerView.h"
#import "HLTimeSingleSelectView.h"
#import "HLVoucherAddRangeCell.h"
#import "HLVoucherAddTwoImageCell.h"
#import "HLVoucherBankSelectCell.h"
#import "HLVoucherMarketAddHead.h"
#import "HLVoucherQueryInfo.h"
#import "HLVoucherMarketEditInfo.h"
#import "HLVoucherSearchView.h"

@interface HLVoucherBankQueryController () <UITableViewDelegate, UITableViewDataSource,HLVoucherSearchViewDelegate>

@property (nonatomic, assign) NSInteger page;
/// 是否需要显示sectionHeader
@property (nonatomic, assign) BOOL needShowSectionHeader;

@property (nonatomic, strong) UITableView *tableView;

// 控制选择的info
@property (nonatomic, copy) NSArray *section0Arr;
@property (nonatomic, strong) NSMutableArray *section1Arr;

/// 此时数据提供
@property (nonatomic, strong) HLVoucherQueryInfo *queryInfo;
@property (nonatomic, strong) HLVoucherSearchView *searchView;

@end

@implementation HLVoucherBankQueryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"查询开户行";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.queryInfo) {
        /// 加载数据
        [self loadPageData];
    }
}

/// J加载页面数据
- (void)loadPageData{
    self.tableView.hidden = YES;
    // 开始拉取数据
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Linkbank/LinkBank";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            self.queryInfo = [HLVoucherQueryInfo mj_objectWithKeyValues:result.data];
            self.tableView.hidden = NO;
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - HLVoucherSearchViewDelegate

/// 点击搜索
- (void)searchBtnClickWithSearchView:(HLVoucherSearchView *)searchView{
    [self.view endEditing:YES];
    [self resetPageAndLoadData];
}

#pragma mark - UITableViewsection0Arr

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.section0Arr.count : self.section1Arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
        cell.baseInfo = self.section0Arr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showBottomLine = YES;
        return cell;
    } else {
        HLVoucherBankSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLVoucherBankSelectCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bankInfo = self.section1Arr[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : (!self.needShowSectionHeader ? 0.01 : FitPTScreen(70));
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 0 ? FitPTScreen(67) : 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1) return nil;
    return self.searchView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return nil;
    if (!self.needShowSectionHeader) return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(70))];
    view.backgroundColor = UIColor.whiteColor;
    
    UILabel *centerLab = [[UILabel alloc] init];
    centerLab.text = @"开户行查询结果";
    centerLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    centerLab.textColor = UIColorFromRGB(0x333333);
    [view addSubview:centerLab];
    [centerLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    [view addSubview:leftLine];
    leftLine.backgroundColor = SeparatorColor;
    [leftLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(centerLab);
        make.right.equalTo(centerLab.left).offset(FitPTScreen(-12));
        make.height.equalTo(0.6);
        make.width.equalTo(FitPTScreen(49));
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    [view addSubview:rightLine];
    rightLine.backgroundColor = SeparatorColor;
    [rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(centerLab);
        make.left.equalTo(centerLab.right).offset(FitPTScreen(12));
        make.height.equalTo(0.6);
        make.width.equalTo(FitPTScreen(49));
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? FitPTScreen(54) : FitPTScreen(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 选择银行返回上一级
    if (indexPath.section == 1) {
        
        HLVoucherBankInfo *bankInfo = self.section1Arr[indexPath.row];
        
        [self.section1Arr enumerateObjectsUsingBlock:^(HLVoucherBankInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.select = obj == bankInfo;
        }];
        [self.tableView reloadData];
        
        if (self.selectBlock) {
            self.selectBlock(bankInfo.bank_name, bankInfo.inst_out_code);
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    // 选择省
    if (indexPath.section == 0) {
        
        // 选择银行
        if (indexPath.row == 0) {
            HLRightInputTypeInfo *bankInfo = self.section0Arr[indexPath.row];
            [HLSinglePickerView showCurrentTitle:bankInfo.text titles:self.queryInfo.bankTitleArr pickerBlock:^(NSInteger index) {
                HLVoucherQueryBankInfo *querybankInfo = self.queryInfo.bank_list[index];
                bankInfo.mParams = @{bankInfo.saveKey : querybankInfo.bank_id};
                bankInfo.text = querybankInfo.bank_name;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//                [self.searchView clearSearchWord];
                [self resetPageAndLoadData];
            }];
            return;
        }
        
        // 选择省
        if (indexPath.row == 1) {
            HLRightInputTypeInfo *provinceInfo = self.section0Arr[indexPath.row];
            [HLSinglePickerView showCurrentTitle:provinceInfo.text titles:self.queryInfo.provinceTitleArr pickerBlock:^(NSInteger index) {
                HLVoucherQueryProvinceInfo *queryProvinceInfo = self.queryInfo.city_list[index];
                // 更新参数
                provinceInfo.text = queryProvinceInfo.area_name;
                // 重置市的数据 && 删除区的数据
                [self reloadCityArr:index];
                
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                
                // 重新拉取数据
//                [self.searchView clearSearchWord];
                [self resetPageAndLoadData];
            }];
            return;
        }
        
        // 选择市
        if(indexPath.row == 2){
            
            if (self.queryInfo.cityArr.count == 0) {
                HLShowHint(@"请选择省", self.view);
                return;
            }
            
            HLRightInputTypeInfo *cityInfo = self.section0Arr[indexPath.row];
            [HLSinglePickerView showCurrentTitle:cityInfo.text titles:self.queryInfo.cityTitleArr pickerBlock:^(NSInteger index) {
                HLVoucherQueryCityInfo *queryCityInfo = self.queryInfo.cityArr[index];
                cityInfo.text = queryCityInfo.area_name;
                cityInfo.mParams = @{cityInfo.saveKey:queryCityInfo.bank_city_code};
                // 重置区的数据
                [self reloadAreaArr:index];
                [self.tableView reloadData];
//                [self.searchView clearSearchWord];
                [self resetPageAndLoadData];
            }];
            return;
        }
        
        // 选择区
        if (indexPath.row == 3) {
            if (self.queryInfo.areaArr.count == 0) {
                if (self.queryInfo.hasAreaData) {
                    HLShowHint(@"请选择市", self.view);
                    return;
                }else{
                    HLShowHint(@"该城市下暂无区县", self.view);
                    return;
                }
            }
            HLRightInputTypeInfo *areaInfo = self.section0Arr[indexPath.row];
            [HLSinglePickerView showCurrentTitle:areaInfo.text titles:self.queryInfo.areaTitleArr pickerBlock:^(NSInteger index) {
                HLVoucherQueryAreaInfo *queryAreaInfo = self.queryInfo.areaArr[index];
                areaInfo.text = queryAreaInfo.area_name;
                areaInfo.mParams = @{areaInfo.saveKey:queryAreaInfo.bank_city_code};
                [self.tableView reloadData];
//                [self.searchView clearSearchWord];
                [self resetPageAndLoadData];
            }];
            return;
        }
    }
}

/// page 重置为1 重新拉取数据
- (void)resetPageAndLoadData{
    // 控制搜索按钮是否可以交互
    [self configSearchBtnState];
    
    self.page = 1;
    [self prepareLoadData];
}

/// 判断是否需要拉取数据
- (void)prepareLoadData{
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    HLRightInputTypeInfo *bankInfo = self.section0Arr[0];
    HLRightInputTypeInfo *provinceInfo = self.section0Arr[1];
    HLRightInputTypeInfo *cityInfo = self.section0Arr[2];
    HLRightInputTypeInfo *areaInfo = self.section0Arr[3];

    if (!bankInfo.text.length || !provinceInfo.text.length || !cityInfo.text.length) {
        [self.tableView endRefresh];
        return;
    }
    
    [mParams setValuesForKeysWithDictionary:bankInfo.mParams];
    [mParams setValuesForKeysWithDictionary:cityInfo.mParams];
    // 如果选了区域，并且区域中选的bank_city_code对应的数据也有，再请求
    if (areaInfo.text.length && [areaInfo.mParams[@"bank_city_code"] integerValue]) {
        [mParams setValuesForKeysWithDictionary:areaInfo.mParams];
    }
    [mParams setObject:@(self.page) forKey:@"page"];
    
    [mParams setObject:[self.searchView searchWord] forKey:@"keywords"];
    
    // 开始拉取数据
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Linkbank/getlBNumList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = mParams;
    } onSuccess:^(id responseObject) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        
        if(result.code == 200){
            // 处理数据
            [self handleRequestBankData:result.data[@"items"]];
        }else{
            self.page > 1 ? 1 : --self.page;
        }
    } onFailure:^(NSError *error) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        self.page > 1 ? 1 : --self.page;
    }];
}

/// 处理返回的银行数据
- (void)handleRequestBankData:(NSArray *)array{
    
    self.needShowSectionHeader = YES;
    
    NSArray *models = [HLVoucherBankInfo mj_objectArrayWithKeyValuesArray:array];
    
    // 如果是第一页
    if (self.page == 1) {
        [self.section1Arr removeAllObjects];
    }
    
    if (models.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.section1Arr addObjectsFromArray:models];
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = self.section1Arr.count == 0;
}

// 如果省市区都选中，则搜索按钮可点击
- (void)configSearchBtnState{
    HLRightInputTypeInfo *bankInfo = self.section0Arr[0];
    HLRightInputTypeInfo *provinceInfo = self.section0Arr[1];
    HLRightInputTypeInfo *cityInfo = self.section0Arr[2];

    BOOL enable = NO;
    if (bankInfo.text.length && provinceInfo.text.length && cityInfo.text.length) {
        enable = YES;
    }
    [_searchView configSearchBtnEnabled:enable];
}

/// 重置市的数据
- (void)reloadCityArr:(NSInteger)index{
    // 更新市的数据 和 区的数据
    [self.queryInfo resetCityArrAndClearAreaArrWithIndex:index];
    
    // 清空展示数据
    HLRightInputTypeInfo *cityInfo = self.section0Arr[2];
    cityInfo.text = @"";
    cityInfo.mParams = nil;
    
    HLRightInputTypeInfo *areaInfo = self.section0Arr[3];
    areaInfo.text = @"";
    areaInfo.mParams = nil;

    [self.section1Arr removeAllObjects];
    self.needShowSectionHeader = NO;
    self.tableView.mj_footer.hidden = self.section1Arr.count == 0;
    [self.tableView reloadData];
}

/// 重置区的数据
- (void)reloadAreaArr:(NSInteger)index{
    // 更新区的数据
    [self.queryInfo resetAreaArrWithIndex:index];
    
    HLRightInputTypeInfo *areaInfo = self.section0Arr[3];
    areaInfo.text = @"";
    areaInfo.mParams = nil;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLVoucherBankSelectCell class] forCellReuseIdentifier:@"HLVoucherBankSelectCell"];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        
        weakify(self);
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weak_self resetPageAndLoadData];
        }];
        mj_header.lastUpdatedTimeLabel.hidden = YES;
        
        _tableView.mj_header = mj_header;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.page++;
            [weak_self prepareLoadData];
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

-(NSMutableArray *)section1Arr{
    if (!_section1Arr) {
        _section1Arr = [NSMutableArray array];
    }
    return _section1Arr;
}

- (NSArray *)section0Arr {
    if (!_section0Arr) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        HLRightInputTypeInfo *bankInfo = [[HLRightInputTypeInfo alloc] init];
        bankInfo.leftTip = @"*所属银行";
        bankInfo.placeHoder = @"请选择银行类型";
        bankInfo.needCheckParams = YES;
        bankInfo.canInput = NO;
        bankInfo.saveKey = @"bank_id";
        bankInfo.errorHint = @"请选择银行类型";
        bankInfo.showRightArrow = YES;
        [mArr addObject:bankInfo];
        
        HLRightInputTypeInfo *provinceInfo = [[HLRightInputTypeInfo alloc] init];
        provinceInfo.leftTip = @"*所在省";
        provinceInfo.placeHoder = @"请选择所在省";
        provinceInfo.needCheckParams = YES;
        provinceInfo.canInput = NO;
        provinceInfo.showRightArrow = YES;
        [mArr addObject:provinceInfo];
        
        HLRightInputTypeInfo *cityInfo = [[HLRightInputTypeInfo alloc] init];
        cityInfo.leftTip = @"*所在市";
        cityInfo.placeHoder = @"请选择所在市";
        cityInfo.needCheckParams = YES;
        cityInfo.canInput = NO;
        cityInfo.saveKey = @"bank_city_code";
        cityInfo.errorHint = @"请选择所在市";
        cityInfo.showRightArrow = YES;
        [mArr addObject:cityInfo];
        
        HLRightInputTypeInfo *areaInfo = [[HLRightInputTypeInfo alloc] init];
        areaInfo.leftTip = @"所在区县";
        areaInfo.placeHoder = @"请选择所在区／县";
        areaInfo.needCheckParams = YES;
        areaInfo.canInput = NO;
        areaInfo.saveKey = @"bank_city_code";
        areaInfo.errorHint = @"请选择所在区／县";
        areaInfo.showRightArrow = YES;
        [mArr addObject:areaInfo];
        
        _section0Arr = [mArr copy];
    }
    return _section0Arr;
}

-(HLVoucherSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[HLVoucherSearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(67))];
        _searchView.delegate = self;
        [_searchView configSearchBtnEnabled:NO];
    }
    return _searchView;
}

@end
