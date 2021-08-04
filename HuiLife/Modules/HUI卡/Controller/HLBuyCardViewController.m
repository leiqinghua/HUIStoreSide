//
//  HLBuyCardViewController.m
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import "HLBuyCardViewController.h"
#import "HLBuyCardListViewCell.h"
#import "HLBuyCardPackageViewCell.h"
#import "HLBuyCardBottomBuyView.h"

/* 注意：根据下标取model，dataSource改变，这里也需要改变 */
#define kPackageModel ([self hasClassName] ? self.dataSource[3] : self.dataSource[2])   // 购买数量
#define kNumModel ([self hasClassName] ? self.dataSource[4] : self.dataSource[3])       // 购买数量
#define kGiveNumModel ([self hasClassName] ? self.dataSource[5] : self.dataSource[4])   // 赠送数量
#define kMoneyModel ([self hasClassName] ? self.dataSource[6] : self.dataSource[5])     // 服务费

@interface HLBuyCardViewController () <UITableViewDataSource,UITableViewDelegate,HLBuyCardPackageViewCellDelegate,HLBuyCardBottomBuyViewDelegate,HLBuyCardListViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HLBuyCardBottomBuyView *buyView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) HLBuyCardVCModel *vcModel; // 数据model

@end

@implementation HLBuyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家购卡";
    [self loadData];
}

- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreCard.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            self.vcModel = [HLBuyCardVCModel mj_objectWithKeyValues:result.data];
            [self creatSubViews];
            [self createTableDataSource];
            [self.tableView reloadData];
        }else{
            weakify(self)
            [self hl_showNetFail:self.view.frame callBack:^{
                [weak_self loadData];
            }];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        weakify(self)
        [self hl_showNetFail:self.view.frame callBack:^{
            [weak_self loadData];
        }];
    }];
}

#pragma mark - Private Methods

/// 构建视图
- (void)creatSubViews{
    
    self.buyView = [[HLBuyCardBottomBuyView alloc] init];
    [self.view addSubview:self.buyView];
    self.buyView.delegate = self;
    [self.buyView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(FitPTScreen(55) + Height_Bottom_Margn);
    }];
    
    self.view.backgroundColor = [UIColor hl_StringToColor:@"#F8F8F8"];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(self.buyView.top);
    }];
}

// 计算金额
- (void)calucateTotalMoney{
    // 获取购买张数
    NSInteger buyNum = [kNumModel inputValue].integerValue;
//    NSInteger multiple = self.vcModel.card.multiple.integerValue;
    
    // 如果不能整除&&选择的是自定义，则直接显示为0
//    if (buyNum % multiple != 0 && [kPackageModel selectItem].isCustom) {
//        [self.buyView configMoney:0];
//        return;
//    }
    
    // 获取单价
    double price = self.vcModel.card.price.doubleValue;
    // 获取服务费
    double charge = [kMoneyModel inputValue].doubleValue;
    
    double totalMoney = buyNum * price + charge;
    
    [self.buyView configMoney:totalMoney];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 选择套餐cell
    if ([self.dataSource[indexPath.row] isMemberOfClass:[HLBuyCardPackageViewModel class]]) {
        HLBuyCardPackageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLBuyCardPackageViewCell"];
        if (!cell) {
            cell = [[HLBuyCardPackageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HLBuyCardPackageViewCell"];
            cell.delegate = self;
        }
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    
    HLBuyCardListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLBuyCardListViewCell"];
    if (!cell) {
        cell = [[HLBuyCardListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HLBuyCardListViewCell"];
        cell.delegate = self;
    }
    cell.listModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource[indexPath.row] isMemberOfClass:[HLBuyCardPackageViewModel class]]) {
        return [self.dataSource[indexPath.row] cellHeight];
    }
    return FitPTScreen(46.5);
}

#pragma mark - HLBuyCardListViewCellDelegate

-(void)cardListViewCell:(HLBuyCardListViewCell *)cell editWithListModel:(HLBuyCardListViewModel *)model{
    // 购买张数编辑
    if(model == kNumModel){
        NSInteger num = [[kNumModel inputValue] integerValue];
        NSInteger multiple = self.vcModel.card.multiple.integerValue;
        if (num >= 1000 && (num % multiple == 0)) {
            [kGiveNumModel setInputValue:[NSString stringWithFormat:@"%.0lf",num * self.vcModel.card.gife.doubleValue]];
        }else{
            [kGiveNumModel setInputValue:@""];
        }
        // 触发金额计算方法
        [self calucateTotalMoney];
        // 刷新赠送张数
        NSIndexPath *giveNumIndexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:kGiveNumModel] inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[giveNumIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    // 服务费编辑
    if (model == kMoneyModel) {
        // 触发金额计算方法
        [self calucateTotalMoney];
        return;
    }
}

#pragma mark - HLBuyCardPackageViewCellDelegate

- (void)packageViewCell:(HLBuyCardPackageViewCell *)cell selectItem:(HLBuyCardPackageViewItem *)item{
    
    if (item.isCustom) {
        // 自定义的时候，购买张数可以编辑
        [kNumModel setCanEdit:YES];
        [kNumModel setInputValue:@""];
        [kGiveNumModel setInputValue:@""];
        [self.tableView reloadData];
        
        NSIndexPath *numIndexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:kNumModel] inSection:0];
        HLBuyCardListViewCell *numCell = [self.tableView cellForRowAtIndexPath:numIndexPath];
        [numCell changeEditState];
        // 计算总金额
        [self calucateTotalMoney];
    }else{
        // 非自定义的时候，购买张数不可编辑
        [kNumModel setCanEdit:NO];
        [kNumModel setInputValue:item.num];
        [kGiveNumModel setInputValue:item.gife];
        [self.tableView reloadData];
        // 计算总金额
        [self calucateTotalMoney];
    }
}

#pragma mark - HLBuyCardBottomBuyViewDelegate

- (void)buyButtonClickWithBuyView:(HLBuyCardBottomBuyView *)buyView{

    // 判断是否选择套餐
    if([kNumModel inputValue].length == 0 && [kNumModel inputValue].intValue == 0){
        HLShowText(@"请选择服务套餐或输入购买张数");
        return;
    }
    
    // 判断是否为整数
    NSInteger buyNum = [kNumModel inputValue].integerValue;
    NSInteger multiple = self.vcModel.card.multiple.integerValue;
    if(buyNum % multiple != 0 && [kPackageModel selectItem].isCustom){
        NSString *tips = [NSString stringWithFormat:@"购买张数请设置为%@的倍数",self.vcModel.card.multiple];
        HLShowText(tips);
        return;
    }
    
    // 购买张数限制
    if(buyNum < self.vcModel.card.minNum.integerValue && [kPackageModel selectItem].isCustom){
        NSString *tips = [NSString stringWithFormat:@"购买张数至少%@张",self.vcModel.card.minNum];
        HLShowText(tips);
        return;
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreCardBuy.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{
            @"num":[kNumModel inputValue] ?: @"", 
            @"charge":[kMoneyModel inputValue] ?: @""
        };
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            // 获取数据去支付
            [[HLPayManage shareManage] preparePayWithParams:result.data finishBlock:^(BOOL success, NSString * _Nonnull msg) {
                HLShowHint(msg, KEY_WINDOW);
                if(success){
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.buySuccessBlock) {
                        self.buySuccessBlock();
                    }
                }
            }];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        weakify(self)
        [self hl_showNetFail:self.view.frame callBack:^{
            [weak_self loadData];
        }];
    }];
}

#pragma mark - Getter

// 获取选择model
- (HLBuyCardPackageViewModel *)packageViewModel{
    for (NSObject *object in self.dataSource) {
        if ([object isMemberOfClass:[HLBuyCardPackageViewModel class]]) {
            return (HLBuyCardPackageViewModel *)object;
        }
    }
    return nil;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = FitPTScreen(46.5);
        _tableView.separatorColor = [UIColor hl_StringToColor:@"#EDEDED"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor hl_StringToColor:@"#F8F8F8"];
        
    }
    return _tableView;
}

- (void)createTableDataSource{
    HLBuyCardListViewModel *telModel = [[HLBuyCardListViewModel alloc] init];
    telModel.tip = @"商家手机号:";
    telModel.placeHolder = @"请输入商家手机号";
    telModel.canEdit = NO;
    telModel.keyboardType = UIKeyboardTypeDefault;
    telModel.inputValue = self.vcModel.store.name;
    
    
    HLBuyCardListViewModel *nameModel = [[HLBuyCardListViewModel alloc] init];
    nameModel.tip = @"商家名称:";
    nameModel.placeHolder = @"请输入商家名称";
    nameModel.canEdit = NO;
    nameModel.keyboardType = UIKeyboardTypeDefault;
    nameModel.inputValue = self.vcModel.store.storeName;
    
    HLBuyCardListViewModel *classModel = [[HLBuyCardListViewModel alloc] init];
    classModel.tip = @"商家类别:";
    classModel.placeHolder = @"请输入商家类别";
    classModel.canEdit = NO;
    classModel.keyboardType = UIKeyboardTypeDefault;
    classModel.inputValue = self.vcModel.store.className ?: @"";
    
    ///  选择服务套餐model
    HLBuyCardPackageViewModel *packageModel = [[HLBuyCardPackageViewModel alloc] init];
    packageModel.tip = @"服务套餐选择:";
    packageModel.items = [HLBuyCardPackageViewItem mj_objectArrayWithKeyValuesArray:self.vcModel.card.package];
    
    HLBuyCardListViewModel *numModel = [[HLBuyCardListViewModel alloc] init];
    numModel.tip = @"购买张数:";
    numModel.placeHolder = [NSString stringWithFormat:@"请输入购买张数(不低于%@张)",self.vcModel.card.minNum];
    numModel.canEdit = NO;
    numModel.keyboardType = UIKeyboardTypeNumberPad;
    
    HLBuyCardListViewModel *giveNumModel = [[HLBuyCardListViewModel alloc] init];
    giveNumModel.tip = @"赠送张数:";
    giveNumModel.placeHolder = @"赠送张数";
    giveNumModel.canEdit = NO;
    giveNumModel.inputValue = @"0";
    giveNumModel.keyboardType = UIKeyboardTypeNumberPad;
    
    HLBuyCardListViewModel *moneyModel = [[HLBuyCardListViewModel alloc] init];
    moneyModel.tip = @"服务费:";
    moneyModel.placeHolder = @"请输入服务费(选填)";
    moneyModel.canEdit = YES;
    moneyModel.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.dataSource = [@[telModel,nameModel,packageModel,numModel,giveNumModel,moneyModel] mutableCopy];
    
    // 如果有类别
    if ([self hasClassName]) {
        [self.dataSource insertObject:classModel atIndex:2];
    }
}

// 是否有类别
- (BOOL)hasClassName{
    return (self.vcModel.store.className && self.vcModel.store.className.length > 0);
}

@end



@implementation HLBuyCardVCModel

@end

@implementation HLBuyCardVCStore

@end

@implementation HLBuyCardVCCard

@end
