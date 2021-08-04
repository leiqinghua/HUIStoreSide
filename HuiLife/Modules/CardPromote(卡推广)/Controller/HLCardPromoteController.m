//
//  HLCardPromoteController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/7.
// HUI卡推广

#import "HLCardPromoteController.h"
#import "HLCardPromoteViewCell.h"
#import "HLCardDiscountController.h"
#import "HLCardSelectTypeCell.h"
#import "HLSinglePickerView.h"
#import "HLMutablePickerController.h"
#import "HLDiscountSetController.h"

@interface HLCardPromoteController () <UITableViewDelegate, UITableViewDataSource, HLCardPromoteViewCellDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UILabel *descLb;

@property(nonatomic, strong) NSArray *datasource;

@property(nonatomic, strong) NSMutableArray *modelTypes;
@property(nonatomic, strong) NSMutableArray *discountTypes;

@property(nonatomic, assign) BOOL switchOn;
//一级分类id
@property(nonatomic, copy) NSString *class_id;
//二级分类id
@property(nonatomic, copy) NSString *sclass_id;

@property(nonatomic, copy) NSString *class_Name;

@end

@implementation HLCardPromoteController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

#pragma mark - request
- (void)loadData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HuiCardSpreadSetInfo.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    }onSuccess:^(id responseObject) {
        dispatch_main_async_safe(^{
            HLHideLoading(self.view);
        });
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleDataWithDict:result.data];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


- (void)handleDataWithDict:(NSDictionary *)dict {
    
    [self hl_setTitle:dict[@"title"] andTitleColor:UIColorFromRGB(0x333333)];
    
    [self initSubViews];
    
    self.datasource = [HLCardDiscount mj_objectArrayWithKeyValuesArray:dict[@"setContent"]];
    _descLb.attributedText = [self descAttrWithDesc:dict[@"tipsContent"]];
    
    _modelTypes = [NSMutableArray array];
    _discountTypes = [NSMutableArray array];
    
    _class_id = dict[@"bus_class_id"];
    _sclass_id = dict[@"bus_sclass_id"];
    
    NSString *typeStr = dict[@"bus_class_name"] ?: @"";
    NSString *subType = dict[@"bus_sclass_name"] ?: @"";
    
    if (subType.length) {
        typeStr = [NSString stringWithFormat:@"%@-%@",typeStr,subType];
    }
    
    // 如果都有值，则不能编辑了
    BOOL canEditType = YES;
    if (_class_id.integerValue > 0 && _sclass_id.integerValue > 0) {
        canEditType = NO;
    }
    
    BOOL nameEmpty = [typeStr isEqualToString:@""] || !typeStr ;
    
    HLCardPromoteType *cardPromote = [[HLCardPromoteType alloc]init];
    cardPromote.title = dict[@"title"];
    cardPromote.desc = @"永久免佣金推广";
    cardPromote.on = [dict[@"hui_open"] integerValue];
    
    HLCardPromoteType *storeType = [[HLCardPromoteType alloc]init];
    storeType.title = @"店铺类型";
    storeType.canEdit = canEditType;
    storeType.desc = nameEmpty?@"请选择店铺类型":typeStr;
    
    NSDictionary *discountDict = dict[@"setTakeAway"];
    HLCardPromoteType *discountType = [[HLCardPromoteType alloc]init];
    discountType.title = discountDict[@"title"];
    discountType.desc = [discountDict[@"is_open"] boolValue]?@"已开启":@"未开启";
    
    [_modelTypes addObject:cardPromote];
    [_modelTypes addObject:storeType];
    [_discountTypes addObject:discountType];
}

- (void)switchONWithOn:(NSInteger)on {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HuiCardSpreadOnOff.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"is_open":@(on)};
    }onSuccess:^(id responseObject) {
        dispatch_main_async_safe(^{
            HLHideLoading(self.view);
        });
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

//店铺类型
- (void)loadStoreTypesWithIndex:(NSIndexPath *)indexPath{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HuiCardSpreadBusClass.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    }onSuccess:^(id responseObject) {
        dispatch_main_async_safe(^{
            HLHideLoading(self.view);
        });
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleStoreTypes:result.data indexPath:indexPath];
            
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleStoreTypes:(NSArray *)datas indexPath:(NSIndexPath *)indexPath {
    NSArray *typeModes = [HLMutablePickerModel mj_objectArrayWithKeyValuesArray:datas];
    HLMutablePickerController *picker = [[HLMutablePickerController alloc]init];
    [picker configDataSource:typeModes bigId:_class_id subId:_sclass_id];
    weakify(self);
    HLCardPromoteType *storeType = self.modelTypes[indexPath.row];
    picker.pickerBlock = ^(NSString * _Nonnull bigName, NSString * _Nonnull subName, NSString * _Nonnull bigId, NSString * _Nonnull subId) {
        NSString *typeStr = [NSString stringWithFormat:@"%@-%@",bigName,subName];
        storeType.desc = typeStr;
        [weak_self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        weak_self.class_id = bigId;
        weak_self.sclass_id = subId;
        [weak_self updateStoreType:bigId subId:subId];
    };
    
    [self.navigationController presentViewController:picker animated:false completion:nil];
}

//店铺类型选择
- (void)updateStoreType:(NSString *)class_id subId:(NSString *)subId{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HuiCardSpreadBusClassAc.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"class_id":class_id,@"sub_class_id":subId};
    }onSuccess:^(id responseObject) {
        dispatch_main_async_safe(^{
            HLHideLoading(self.view);
        });
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}
#pragma mark - Method
- (NSAttributedString *)descAttrWithDesc:(NSString *)desc {
    desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = FitPTScreen(10);
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName:style
    };
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:desc attributes:attributes];
    return attr;
}


#pragma mark - HLCardPromoteViewCellDelegate

- (void)cardPromoteCell:(HLCardPromoteViewCell *)cell switchOn:(BOOL)on {
    [self switchONWithOn:on?1:2];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.modelTypes.count;
    if (section == 2) return 1;
    return self.datasource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        HLCardDiscountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLCardDiscountViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.datasource[indexPath.row];
        return cell;
    }
    
    if (indexPath.section == 2) {
        HLCardSelectTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLCardSelectTypeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.discountTypes[indexPath.row];
        return cell;
    }
    
    if (indexPath.row == 0) {
        HLCardPromoteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLCardPromoteViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.modelTypes[indexPath.row];
        return cell;
    }
    
    HLCardSelectTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLCardSelectTypeCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.modelTypes[indexPath.row];
    return cell;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footer = [[UIView alloc]init];
        footer.backgroundColor = UIColorFromRGB(0xF2F2F2);
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) return FitPTScreen(5);
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0)return FitPTScreen(74);
    return FitPTScreen(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        HLCardDiscount *model = self.datasource[indexPath.row];
        HLCardDiscountController *cardDisVC = [[HLCardDiscountController alloc]initWithType:model.type];
        cardDisVC.modifyDiscountBlock = ^(NSString * _Nonnull discount) {
            model.set = discount;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController presentViewController:cardDisVC animated:false completion:nil];
        return;
    }
    
    if (indexPath.section == 0) {
        HLCardPromoteType *storeType = self.modelTypes[indexPath.row];
        if ([storeType.title isEqualToString:@"店铺类型"] && storeType.canEdit) {
            [self loadStoreTypesWithIndex:indexPath];
        }
        return;
    }
    
    HLCardPromoteType *discountInfo = self.discountTypes[indexPath.row];
    HLDiscountSetController *discountVC = [[HLDiscountSetController alloc]init];
    discountVC.HLDiscountCallBack = ^(BOOL on) {
        discountInfo.desc = on?@"已开启":@"未开启";
        NSIndexSet *discountSet = [[NSIndexSet alloc]initWithIndex:indexPath.section];
        [tableView reloadSections:discountSet withRowAnimation:UITableViewRowAnimationNone];
    };
    [self hl_pushToController:discountVC];
}

#pragma mark - UIView
- (void)initSubViews {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH-Height_NavBar ) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = false;
    AdjustsScrollViewInsetNever(self, _tableView);
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[HLCardPromoteViewCell class] forCellReuseIdentifier:@"HLCardPromoteViewCell"];
    [_tableView registerClass:[HLCardDiscountViewCell class] forCellReuseIdentifier:@"HLCardDiscountViewCell"];
    [_tableView registerClass:[HLCardSelectTypeCell class] forCellReuseIdentifier:@"HLCardSelectTypeCell"];
    
    [self initBottomView];
}

- (void)initBottomView {
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(259))];
    _tableView.tableFooterView = bottomView;
    
    UIView *bagView = [[UIView alloc]init];
    bagView.backgroundColor = UIColor.whiteColor;
    [bottomView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-30));
        make.centerX.equalTo(bottomView);
        make.width.equalTo(FitPTScreen(358));
    }];
    
    UILabel *tipLb = [[UILabel alloc]init];
    tipLb.text = @"温馨提示：";
    tipLb.textAlignment = NSTextAlignmentCenter;
    tipLb.textColor = UIColorFromRGB(0x333333);
    tipLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [bottomView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bagView.left).offset(FitPTScreen(6));
        make.centerY.equalTo(bagView.top);
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor = UIColorFromRGB(0x888888);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _descLb.numberOfLines = 0;
    [bagView addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bagView).insets(UIEdgeInsetsMake(FitPTScreen(20), FitPTScreen(7), FitPTScreen(13), FitPTScreen(7)));
    }];
    
}

@end
