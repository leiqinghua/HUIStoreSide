//
//  HLDeliveryFeeSetController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import "HLDeliveryFeeSetController.h"
#import "HLDistanceInputTableCell.h"
#import "HLFeeSectionHeader.h"
#import "HLFeeSectionFooter.h"
#import "HLFeeOrderJLTableCell.h"
#import "HLFeeTimeJLTableCell.h"
#import "HLFeeMainInfo.h"
#import "HLDeliveryWayInfo.h"
#import "HLDeliveryWayTableCell.h"
#import "HLCustomAlert.h"
#import "HLFeeTableViewHeader.h"

#define bottomViewH FitPTScreen(206)
@interface HLDeliveryFeeSetController () <UITableViewDelegate, UITableViewDataSource, HLFeeSectionHeaderDelegate, HLDeliveryWayTableCellDelegate, HLFeeTableViewHeaderDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) HLFeeMainInfo *mainInfo;
//保留最初数据
@property(nonatomic, strong) NSDictionary *oriMainInfo;
//配送方式
@property(nonatomic, strong) NSMutableArray *deliveryWays;
@property(nonatomic, strong) HLFeeHeaderInfo *deliveryHeader;
@property(nonatomic, assign) BOOL deliveryOpen;

@property (nonatomic, strong) HLFeeTableViewHeader *tableHeader;

@end

@implementation HLDeliveryFeeSetController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"派单费设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBarView];
    [self loadDefaultData];
}

#pragma mark - request

// 请求默认数据
- (void)loadDefaultData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/DispatchFeeSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
        request.httpMethod = kXMHTTPMethodPOST;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self configDatas:result.data];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

// 配置数据
- (void)configDatas:(NSDictionary *)dict {
    self.mainInfo = [HLFeeMainInfo mj_objectWithKeyValues:dict];
    self.oriMainInfo = dict;
    
    _deliveryOpen = self.mainInfo.is_third_party;
    
    [_tableHeader configSwitchOn:self.mainInfo.self_state];
    self.deliveryHeader.on = self.mainInfo.third_state;
    
    NSDictionary *deliverDict = dict[@"eleRole"];
    NSArray *deliverArr = deliverDict[@"eleRoles"];
    // 蜂鸟
    HLDeliveryWayInfo *fnInfo = [[HLDeliveryWayInfo alloc]init];
    fnInfo.enable = YES;
    fnInfo.on = self.mainInfo.is_third_party;
    fnInfo.pic = @"fnPic";
    fnInfo.name = @"蜂鸟配送";
    fnInfo.detail = @"开启配送服务，则同意平台定义规则";
    fnInfo.order = @"NO.1";
    fnInfo.startPrice = [NSString stringWithFormat:@"%@",deliverDict[@"startPrice"]];
    fnInfo.rule = [NSString stringWithFormat:@"蜂鸟平台配送规则（%@元起送）",fnInfo.startPrice];
    fnInfo.eleRoles = [HLDeliveryRule mj_objectArrayWithKeyValuesArray:deliverArr];
    [self.deliveryWays addObject:fnInfo];
    // 美团
    HLDeliveryWayInfo *mtInfo = [[HLDeliveryWayInfo alloc]init];
    mtInfo.pic = @"mtPic";
    mtInfo.name = @"美团配送";
    mtInfo.detail = @"开启配送服务，则同意平台定义规则";
    mtInfo.order = @"NO.2";
    mtInfo.startPrice = [NSString stringWithFormat:@"%@",deliverDict[@"startPrice"]];
    mtInfo.rule = [NSString stringWithFormat:@"美团平台配送规则（%@元起送）",mtInfo.startPrice];
    [self.deliveryWays addObject:mtInfo];
    // 达达
    HLDeliveryWayInfo *ddInfo = [[HLDeliveryWayInfo alloc]init];
    ddInfo.pic = @"ddPic";
    ddInfo.name = @"达达配送";
    ddInfo.detail = @"开启配送服务，则同意平台定义规则";
    ddInfo.order = @"NO.2";
    ddInfo.startPrice = [NSString stringWithFormat:@"%@",deliverDict[@"startPrice"]];
    ddInfo.rule = [NSString stringWithFormat:@"达达平台配送规则（%@元起送）",ddInfo.startPrice];
    [self.deliveryWays addObject:ddInfo];
    
    [self.tableView reloadData];
}

// 保存
- (void)saveDataWithPargram:(NSDictionary *)pargram {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/DispatchFeeSetAc.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
        request.httpMethod = kXMHTTPMethodPOST;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [HLTools showWithText:@"保存成功"];
            [self hl_goback];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

// 蜂鸟配送开关
- (void)deliveryWayUpdate:(HLDeliveryWayInfo *)info on:(BOOL)on{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/ClientSide/UnionCard/EleStorePush.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"name":info.name,@"state":@(on),@"did":@(info.Id)};
        request.httpMethod = kXMHTTPMethodPOST;
        request.hideError = YES;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            info.on = on;
            _deliveryOpen = on;
            [self.tableView reloadData];
            return;
        }
        NSString *message = result.code == 1000?@"审核中":@"审核失败";
        [HLCustomAlert showNormalStyleTitle:message message:result.msg buttonTitles:@[@"知道了"] buttonColors:@[UIColorFromRGB(0xFD9E2F)] callBack:^(NSInteger index) {
                    
        }];
        
        
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - Event

//保存
- (void)saveClick {
    NSMutableDictionary *pargram = [NSMutableDictionary dictionary];
    for (HLFeeHeaderInfo *headerInfo in self.mainInfo.datasource) {
        if (headerInfo.mainKey.length) {
            [pargram setObject:headerInfo.value forKey:headerInfo.mainKey];
        }
        
        if (headerInfo.footerInfo) {
            [pargram setObject:headerInfo.footerInfo.distance_amount forKey:headerInfo.footerInfo.distanceKey];
        }
        
        for (HLFeeBaseInfo *baseInfo in headerInfo.datasource) {
            
            if (![baseInfo check]) {
                [HLTools showWithText:baseInfo.toastStr];
                return;
            }
            
            if (baseInfo.pargrams.count) {
                [pargram addEntriesFromDictionary:baseInfo.pargrams];
            }
            
            if (baseInfo.distanceKey.length) {
                [pargram setObject:baseInfo.value?:@"" forKey:baseInfo.distanceKey];
            }
        }
    }
    [pargram setObject:@(_deliveryOpen) forKey:@"is_third_party"];
    [pargram setObject:@(_mainInfo.self_state) forKey:@"self_state"];
    [pargram setObject:@(_deliveryHeader.on) forKey:@"third_state"];
    HLLog(@"pargram = %@",pargram);
    [self saveDataWithPargram:pargram];
}

//重置
- (void)resetClick {
    _mainInfo = [HLFeeMainInfo mj_objectWithKeyValues:_oriMainInfo];
    [_tableHeader configSwitchOn:self.mainInfo.self_state];
    _deliveryHeader.on = self.mainInfo.third_state;
    [self.tableView reloadData];
}

//专送员
- (void)rightItemClick {
    [HLTools pushAppPageLink:@"HLSpecialPersonController" params:@{} needBack:NO];
}

// 更改三个开关

#pragma mark - HLFeeTableViewHeaderDelegate

- (void)feeTableHeader:(HLFeeTableViewHeader *)header switchChanged:(BOOL)switchOn{
    _mainInfo.self_state = switchOn;
    // 获取到家配送服务和三方配送服务
    HLFeeHeaderInfo *dispatchInfo = self.mainInfo.datasource.firstObject;
    dispatchInfo.on = !switchOn;
    _mainInfo.is_dispatch = !switchOn;
    dispatchInfo.value = @(dispatchInfo.on);

    _deliveryHeader.on = !switchOn;
    _mainInfo.third_state = !switchOn;
    
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:dispatchInfo.index];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    
    set = [[NSIndexSet alloc] initWithIndex:_deliveryHeader.index];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - HLDeliveryWayTableCellDelegate
- (void)deliveryCell:(HLDeliveryWayTableCell *)cell deliveryInfo:(HLDeliveryWayInfo *)info {
    [self.tableView reloadData];
}

- (void)deliveryCell:(HLDeliveryWayTableCell *)cell on:(BOOL)on {
    [self deliveryWayUpdate:cell.deliveryInfo on:on];
}

#pragma mark - HLFeeSectionHeaderDelegate
- (void)header:(HLFeeSectionHeader *)header headerInfo:(HLFeeHeaderInfo *)headerInfo {
    if (headerInfo.index == 0) {
        _mainInfo.is_dispatch = headerInfo.on;
        [self changeSwitchState];
    } else if (headerInfo.index == 3) {
        _mainInfo.is_third_party = headerInfo.on;
        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:headerInfo.index];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    } else if (headerInfo.index == 4){
        _mainInfo.third_state = headerInfo.on;
        [self changeSwitchState];
    }
}

- (void)changeSwitchState{
    HLFeeHeaderInfo *dispatchInfo = self.mainInfo.datasource.firstObject;
    if (dispatchInfo.on || _deliveryHeader.on) {
        // 只要有一个开的，顶部就关闭
        [_tableHeader configSwitchOn:NO];
        _mainInfo.self_state = NO;
    }
    
    if (!dispatchInfo.on && !_deliveryHeader.on) {
        // 如果都关了，就开
        [_tableHeader configSwitchOn:YES];
        _mainInfo.self_state = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _mainInfo.datasource.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _mainInfo.datasource.count) {
        return self.deliveryWays.count;
    }
    HLFeeHeaderInfo *info = _mainInfo.datasource[section];
    if (info.hideSection) {
        if (!_mainInfo.is_third_party_open) return 0;
        return info.on?info.datasource.count:0;
    }
    return info.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _mainInfo.datasource.count) {
        HLDeliveryWayTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLDeliveryWayTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.deliveryInfo = self.deliveryWays[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    HLFeeHeaderInfo *info = _mainInfo.datasource[indexPath.section];
    HLFeeBaseInfoType type = info.datasource[indexPath.row].type;
    switch (type) {
        case HLFeeBaseInfoTypeNormal:
        {
            HLDistanceInputTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLDistanceInputTableCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseInfo = info.datasource[indexPath.row];
            cell.canEdit = info.canEdit;
            return cell;
        }break;
        case HLFeeBaseInfoTypeOrder:
        {
            HLFeeOrderJLTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLFeeOrderJLTableCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.orderInfo = info.datasource[indexPath.row];
            cell.orders = info.datasource;
            return cell;
        }break;
        case HLFeeBaseInfoTypeTime:
        {
            HLFeeTimeJLTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLFeeTimeJLTableCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titles = _mainInfo.consume_time_set;
            cell.timeInfo = info.datasource[indexPath.row];
            cell.HLFeeTimeSelectBack = ^{
                [tableView endEditing:YES];
            };
            return cell;
        }break;
        default:
            return [UITableViewCell new];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.mainInfo.datasource.count) {
        HLDeliveryWayInfo *info = self.deliveryWays[indexPath.row];
        return info.cellHight;
    }
    return FitPTScreen(50);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HLFeeSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLFeeSectionHeader"];
    header.delegate = self;
    if (section == _mainInfo.datasource.count) {
        header.headerInfo = self.deliveryHeader;
        return header;
    }
    HLFeeHeaderInfo *headerInfo = self.mainInfo.datasource[section];
    if (headerInfo.hideSection && !_mainInfo.is_third_party_open) return nil;
    header.headerInfo = headerInfo;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _mainInfo.datasource.count) return nil;
    HLFeeHeaderInfo *headerInfo = self.mainInfo.datasource[section];
    HLFeeSectionFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLFeeSectionFooter"];
    footer.baseInfo = headerInfo.footerInfo;
    footer.canEdit = headerInfo.canEdit;
    if (headerInfo.hideSection) { //需要控制
        if (headerInfo.on && _mainInfo.is_third_party_open) { //创建footer
            return footer;
        }
        return nil;
    } else {
        if (headerInfo.footerInfo) { //创建footer
            return footer;
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == _mainInfo.datasource.count) return FitPTScreen(50);
    HLFeeHeaderInfo *headerInfo = self.mainInfo.datasource[section];
    if (headerInfo.hideSection && !_mainInfo.is_third_party_open) {
        return 0.001;
    }
    return headerInfo?FitPTScreen(50):0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _mainInfo.datasource.count) return 0.01;
    HLFeeHeaderInfo *headerInfo = self.mainInfo.datasource[section];
    if (headerInfo.hideSection) { //需要控制
        if (headerInfo.on && _mainInfo.is_third_party_open) { //创建footer
            return FitPTScreen(60);
        }
        return 0.001;
    } else {
        if (headerInfo.footerInfo) { //创建footer
            return FitPTScreen(60);
        }
        return 0.001;
    }
}

#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH -Height_NavBar) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever(self, _tableView);
    
    [_tableView registerClass:[HLDistanceInputTableCell class] forCellReuseIdentifier:@"HLDistanceInputTableCell"];
    [_tableView registerClass:[HLFeeOrderJLTableCell class] forCellReuseIdentifier:@"HLFeeOrderJLTableCell"];
    [_tableView registerClass:[HLFeeTimeJLTableCell class] forCellReuseIdentifier:@"HLFeeTimeJLTableCell"];
    [_tableView registerClass:[HLDeliveryWayTableCell class] forCellReuseIdentifier:@"HLDeliveryWayTableCell"];
    
    [_tableView registerClass:[HLFeeSectionHeader class] forHeaderFooterViewReuseIdentifier:@"HLFeeSectionHeader"];
    [_tableView registerClass:[HLFeeSectionFooter class] forHeaderFooterViewReuseIdentifier:@"HLFeeSectionFooter"];
    
    [self.view addSubview:_tableView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), ScreenW, bottomViewH)];
    bottomView.backgroundColor = UIColor.whiteColor;
    _tableView.tableFooterView = bottomView;
    
    _tableHeader = [[HLFeeTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(70))];
    _tableHeader.backgroundColor = UIColor.whiteColor;
    _tableHeader.delegate = self;
    _tableView.tableHeaderView = _tableHeader;
    
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
        make.width.equalTo(FitPTScreen(271));
        make.height.equalTo(FitPTScreen(53));
    }];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *resetButton = [[UIButton alloc] init];
    [bottomView addSubview:resetButton];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    resetButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [resetButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    resetButton.backgroundColor = UIColor.whiteColor;
    resetButton.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    resetButton.layer.shadowOffset = CGSizeMake(0,4);
    resetButton.layer.shadowOpacity = 0.2;
    resetButton.layer.shadowRadius = FitPTScreen(15);
    resetButton.layer.borderWidth = 0.5;
    resetButton.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    resetButton.layer.cornerRadius = FitPTScreen(10);
    [resetButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(FitPTScreen(-65));
        make.width.equalTo(FitPTScreen(261));
        make.height.equalTo(FitPTScreen(42));
    }];
    [resetButton addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initNavBarView {
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(20))];
    [rightBtn setTitle:@"专送员" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (NSMutableArray *)deliveryWays {
    if (!_deliveryWays) {
        _deliveryWays = [NSMutableArray array];
    }
    return _deliveryWays;
}

- (HLFeeHeaderInfo *)deliveryHeader {
    if (!_deliveryHeader) {
        _deliveryHeader = [[HLFeeHeaderInfo alloc]init];
        _deliveryHeader.hideTipV = YES;
        _deliveryHeader.title = @"第三方配送服务";
        _deliveryHeader.subTitle = @"选择派单团队自由定义";
        _deliveryHeader.hideSwitch = NO;
        _deliveryHeader.index = 4;
        _deliveryHeader.mainKey = @"third_state";
    }
    return _deliveryHeader;
}

@end
