//
//  HLStoreBuyMainController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import "HLStoreBuyMainController.h"
#import "HLStoreBuyHeadView.h"
#import "HLStoreBuyMainInfo.h"
#import "HLStoreBuyPayTypeCell.h"
#import "HLStoreBuyResultController.h"
#import "HLStoreMoneyFootView.h"
#import "HLSotreBuyCodeViewCell.h"

#define kMoneyViewH (FitPTScreen(58) + Height_Bottom_Margn)

@interface HLStoreBuyMainController () <UITableViewDelegate, UITableViewDataSource, HLStoreBuyHeadViewDelegate, HLStoreMoneyFootViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HLStoreBuyHeadView *headView;
@property (nonatomic, strong) HLStoreMoneyFootView *moneyView;

@property (nonatomic, strong) HLStoreBuyMainInfo *mainInfo;

@property (nonatomic, strong) UIView *tableFootView;
@property (nonatomic, strong) UITextField *textField;

/// 输入的codeinfo
@property (nonatomic, strong) NSMutableArray *codeInfoArr;

@end

@implementation HLStoreBuyMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_setTitle:@"账户有效期设置"];

    [self loadPageData];
}

- (void)creatSubViews{
    if(_tableView) return;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - kMoneyViewH) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = FitPTScreen(57);
    _tableView.backgroundColor = UIColor.whiteColor;
    [_tableView registerClass:[HLStoreBuyPayTypeCell class] forCellReuseIdentifier:@"HLStoreBuyPayTypeCell"];
    [_tableView registerClass:[HLSotreBuyCodeViewCell class] forCellReuseIdentifier:@"HLSotreBuyCodeViewCell"];
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    
    _headView = [[HLStoreBuyHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(306))];
    _headView.delegate = self;
    self.tableView.tableHeaderView = _headView;
    
    _moneyView = [[HLStoreMoneyFootView alloc] initWithFrame:CGRectMake(0, ScreenH - kMoneyViewH, ScreenW, kMoneyViewH)];
    _moneyView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    _moneyView.delegate = self;
    [self.view addSubview:_moneyView];
}

/// 拉取数据
- (void)loadPageData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *_Nonnull request) {
        request.api = @"/MerchantSide/BusinessEffectAction.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    }
    onSuccess:^(XMResult *_Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            
            [self creatSubViews];
            
            self.mainInfo = [HLStoreBuyMainInfo mj_objectWithKeyValues:responseObject.data];
            // 必须先设置默认数据，否则下面控制数据会有问题哦
            [self.mainInfo configDefaultSelectYearAndPayType];
            // 控制默认选中，显示数据
            [_headView configMainInfo:self.mainInfo];
            [self cacluteBottomMoney];
            [self changeCodeInputNumber];
            [self.tableView reloadData];
        }
    }
    onFailure:^(NSError *_Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - Private Method

/// 判断当时选择的那个是不是特惠码支付
- (BOOL)validePayTypeIsCode{
    HLStoreBuyTypeInfo *typeInfo = [self.mainInfo selectTypeInfo];
    if (typeInfo.payment_id.integerValue == 1) {
        return YES;
    }
    return NO;
}

/// 给底部赋值钱
- (void)cacluteBottomMoney {
    HLStoreBuyYearInfo *yearInfo = [self.mainInfo selectYearInfo];
    [_moneyView configSaleMoney:yearInfo.price shengMoney:yearInfo.grayDesc];
}

/// 改变s输入框的值
- (void)changeCodeInputNumber{
    
    // 如果此时选择的不是商家支付，直接return
    if (![self validePayTypeIsCode]) {
        return;
    }
    
    HLStoreBuyYearInfo *yearInfo = [self.mainInfo selectYearInfo];
    NSInteger year = yearInfo.Id;
    
    [self.codeInfoArr removeAllObjects];
    for (NSInteger i = 0; i < year; i++) {
        HLSotreBuyCodeInfo *codeInfo = [[HLSotreBuyCodeInfo alloc] init];
        [self.codeInfoArr addObject:codeInfo];
    }
    [self.tableView reloadData];
}

#pragma mark - HLStoreMoneyFootViewDelegate

/// 点击购买按钮
- (void)clickBuyButtonWithFootView:(HLStoreMoneyFootView *)footView {
    
    // 构建参数字典
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    
    HLStoreBuyYearInfo *yearInfo = [self.mainInfo selectYearInfo];
    HLStoreBuyTypeInfo *typeInfo = [self.mainInfo selectTypeInfo];
    
    [mParams setObject:@(yearInfo.Id) forKey:@"proId"];
    
    // 如果是code支付，判断几个输入框是否有重复数据，是否全部输入了
    if ([self validePayTypeIsCode]) {
        
        // 拿到所有的输入的code值
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.codeInfoArr.count; i++) {
            HLSotreBuyCodeInfo *codeInfo = self.codeInfoArr[i];
            if (codeInfo.password.length) {
                [mArr addObject:codeInfo.password];
                [mParams setObject:codeInfo.password forKey:[NSString stringWithFormat:@"password%ld",i+1]];
            }
        }
        
        NSInteger number = yearInfo.Id;
        if (mArr.count != number) {
            HLShowHint(@"请输入支付密码", self.view);
            return;
        }
        
        // 判断是否有重复的数据
        NSSet *codeInfoSet = [NSSet setWithArray:mArr];
        if (codeInfoSet.count != number) {
            HLShowHint(@"当前有重复数据，请修改", self.view);
            return;
        }
    }
    
    // 开始提交数据了
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *_Nonnull request) {
        request.api = @"/MerchantSide/BusinessEffectSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = mParams;
    }
    onSuccess:^(XMResult *_Nullable responseObject) {
        HLHideLoading(self.view);
        // 其中有密码输入错误的问题
        if ([responseObject code] == 601) {
            self.codeInfoArr = [HLSotreBuyCodeInfo mj_objectArrayWithKeyValuesArray:responseObject.data];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        
        if ([responseObject code] == 200) {
            // 支付成功
            HLStoreBuyResultController *result = [[HLStoreBuyResultController alloc] init];
            result.payType = typeInfo.value;
            result.yearText = yearInfo.name;
            [self.navigationController pushViewController:result animated:YES];
        }
    }
    onFailure:^(NSError *_Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - HLStoreBuyHeadViewDelegate

/// 改变底部的钱
- (void)selectYearInfoChanged:(HLStoreBuyHeadView *)headView {
    [self cacluteBottomMoney];
    [self changeCodeInputNumber];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.mainInfo.zhifuData.count : self.codeInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HLStoreBuyPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLStoreBuyPayTypeCell" forIndexPath:indexPath];
        cell.info = self.mainInfo.zhifuData[indexPath.row];
        cell.hideBottomLine = indexPath.row == self.mainInfo.zhifuData.count - 1;
        return cell;
    }else{
        HLSotreBuyCodeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLSotreBuyCodeViewCell" forIndexPath:indexPath];
        cell.codeInfo = self.codeInfoArr[indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? FitPTScreen(57) : FitPTScreen(52);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? FitPTScreen(52) : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {return nil;}
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(52))];
    view.backgroundColor = UIColor.whiteColor;
    
    UILabel *itemLab = [[UILabel alloc] init];
    [view addSubview:itemLab];
    itemLab.text = @"付款方式";
    itemLab.textColor = UIColorFromRGB(0x696969);
    itemLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [itemLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(20));
        make.left.equalTo(FitPTScreen(14));
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [view addSubview:bottomLine];
    bottomLine.backgroundColor = SeparatorColor;
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(0.6);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return;
    }
    HLStoreBuyTypeInfo *info = self.mainInfo.zhifuData[indexPath.row];
    if (info.select) {return;}
    [self.mainInfo.zhifuData enumerateObjectsUsingBlock:^(HLStoreBuyTypeInfo *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.select = (obj == info);
    }];
    
    // 如果此时选择的是商家支付，那么需要改变底部输入框的数量
    if ([self validePayTypeIsCode]) {
        [self changeCodeInputNumber];
    }
    
    [self.tableView reloadData];
}

-(NSMutableArray *)codeInfoArr{
    if (!_codeInfoArr) {
        _codeInfoArr = [NSMutableArray array];
    }
    return _codeInfoArr;
}

@end
