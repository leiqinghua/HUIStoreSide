//
//  HLHUIAddController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/23.
//

#import "HLHUIAddController.h"
#import "HLRightInputViewCell.h"
#import "HLInputUseDescViewCell.h"
#import "HLProfitGoodTableCell.h"
#import "HLProfitGoodInfo.h"
#import "HLAddProfitController.h"

@interface HLHUIAddController ()<UITableViewDelegate, UITableViewDataSource, HLProfitGoodCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, strong) NSMutableArray *profits;
//只限于1，2，3
@property(nonatomic, strong) NSMutableArray *addProfitTypes;

@end

@implementation HLHUIAddController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:_cardId.length?@"编辑HUI卡":@"发布HUI卡"];
    [self hl_setBackImage:@"back_black"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultData];
    
//    [self initSubView];
//    [self configDatasourceWithDict:nil];
}

#pragma mark - Request
//获取联名卡信息
- (void)loadDefaultData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/CardInfo.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"cardId":_cardId?:@""};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self configDatasourceWithDict:result.data];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

//发布HUI卡
- (void)productWithPargrams:(NSDictionary *)pargram {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/CardCreate.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [HLNotifyCenter postNotificationName:HLReloadHUIMainListNotifi object:nil];
            [self hl_goback];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - Event
//确认发布
- (void)productClick {
    
    NSMutableDictionary *pargram = [NSMutableDictionary dictionary];
    for (int i = 0; i< self.datasource.count-1; i ++) {
        NSArray *infos = self.datasource[i];
        for (HLBaseTypeInfo *info in infos) {
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                [HLTools showWithText:info.errorHint];
                return;
            }
            if (info.saveKey.length) {
                [pargram setObject:info.text?:@"" forKey:info.saveKey];
            }
        }
    }
    if (self.profits.count) {
        NSMutableArray *profitJson = [NSMutableArray array];
        for (HLProfitGoodInfo *info in self.profits) {
            if (info.gainType != 60) {
                [profitJson addObject:[info mj_keyValuesWithIgnoredKeys:[HLProfitGiftInfo ignoredKeys]]];
            }
        }
        HLLog(@"profitJson = %@",profitJson);
        
        NSString *json = [profitJson mj_JSONString];
        
        [pargram setObject:json forKey:@"gain"];
        
        HLLog(@"json = %@",json);
    }
    if (_cardId) [pargram setObject:_cardId forKey:@"cardId"];
    HLLog(@"pargram = %@",pargram);
    [self productWithPargrams:pargram];
}

//添加卡权益
- (void)addTap {
    HLAddProfitController *addProfitVC = [[HLAddProfitController alloc]init];
    addProfitVC.addProfitTypes = self.addProfitTypes;
    weakify(self);
    addProfitVC.saveProfitBlock = ^(HLProfitGoodInfo * goodInfo) {
        if (goodInfo.gainType == 1||goodInfo.gainType == 2||goodInfo.gainType == 3) {
            [weak_self.addProfitTypes addObject:@(goodInfo.gainType)];
        }
        [weak_self.profits addObject:goodInfo];
        NSIndexSet *profitSet = [[NSIndexSet alloc]initWithIndex:(weak_self.datasource.count-1)];
        [weak_self.tableView reloadSections:profitSet withRowAnimation:UITableViewRowAnimationNone];
    };
    [self hl_pushToController:addProfitVC];
}
#pragma mark - HLHUIGiftCellDelegate
//删除
- (void)giftCell:(HLProfitGoodTableCell *)cell deleteInfo:(HLProfitGoodInfo *)info {
    [HLCustomAlert showNormalStyleTitle:@"删除提示" message:@"是否确定删除权益" buttonTitles:@[@"取消",@"确定"] buttonColors:@[UIColorFromRGB(0x9A9A9A),UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
        if (index == 1) {
            [self.profits removeObject:info];
            [self.tableView reloadData];
            if (info.gainType == 1 || info.gainType == 2 ||info.gainType == 3) {
                [self.addProfitTypes removeObject:@(info.gainType)];
            }
        }
    }];
}
//编辑卡权益
- (void)giftCell:(HLProfitGoodTableCell *)cell editInfo:(HLProfitGoodInfo *)info {
    NSInteger index = [self.profits indexOfObject:info];
    HLAddProfitController *addProfitVC = [[HLAddProfitController alloc]init];
    addProfitVC.editProfitInfo = info;
    weakify(self);
    addProfitVC.saveProfitBlock = ^(HLProfitGoodInfo * goodInfo) {
        [weak_self.profits replaceObjectAtIndex:index withObject:goodInfo];
        NSIndexSet *profitSet = [[NSIndexSet alloc]initWithIndex:(weak_self.datasource.count-1)];
        [weak_self.tableView reloadSections:profitSet withRowAnimation:UITableViewRowAnimationNone];
    };
    [self hl_pushToController:addProfitVC];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *infos = self.datasource[section];
    return infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != self.datasource.count-1) {
        NSArray *infos = self.datasource[indexPath.section];
        HLBaseTypeInfo *typeInfo = infos[indexPath.row];
        
        if (typeInfo.type == HLInputCellTypeDefault) {
            HLRightInputViewCell *cell = (HLRightInputViewCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseInfo = typeInfo;
            return cell;
        }
        
        HLInputUseDescViewCell *cell = (HLInputUseDescViewCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLInputUseDescViewCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.baseInfo = typeInfo;
        return cell;
    }
    
    HLProfitGoodInfo *goodInfo = self.profits[indexPath.row];
    
    if (goodInfo.gainType == 60) {
        HLProfitPhoneFeeCell *cell = (HLProfitPhoneFeeCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLProfitPhoneFeeCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.goodInfo = (HLPhoneFeeInfo *)goodInfo;
        return cell;
    }
    
    if (goodInfo.gainType == 21) { //赠品
        HLProfitGiftTableCell *cell = (HLProfitGiftTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLProfitGiftTableCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.goodInfo = goodInfo;
        return cell;
    }
    
    if (goodInfo.gainType == 2) { //外卖
        HLProfitYMTableCell *cell = (HLProfitYMTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLProfitYMTableCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.goodInfo = goodInfo;
        return cell;
    }
    
    if (goodInfo.gainType == 61) { //外卖红包
        HLProfitRedPacketTableCell *cell = (HLProfitRedPacketTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLProfitRedPacketTableCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.goodInfo = goodInfo;
        return cell;
    }
    
    HLProfitDefaultTableCell *cell = (HLProfitDefaultTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLProfitDefaultTableCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.goodInfo = goodInfo;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != self.datasource.count -1) {
        NSArray *infos = self.datasource[indexPath.section];
        HLBaseTypeInfo *info = infos[indexPath.row];
        return info.cellHeight;
    }
    HLProfitGoodInfo *goodInfo = self.profits[indexPath.row];
    return goodInfo.cellHight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) return nil;
    if (section == 1) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = UIColorFromRGB(0xf5f6f9);
        return header;
    }
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = UIColorFromRGB(0xf5f6f9);
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:12];
    [header addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.bottom.equalTo(FitPTScreen(-10));
    }];
    tipLb.text = section == (self.datasource.count-1)?@"设置卡权益":@"设置分佣";
    return header;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.001;
    if (section == 1) return FitPTScreen(10);
    return FitPTScreen(44);
}

#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    
    CGFloat bottomHight = FitPTScreen(74) + Height_Bottom_Margn;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - bottomHight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionFooterHeight = 0.001;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(85))];
    footerView.backgroundColor = UIColor.whiteColor;
    _tableView.tableFooterView = footerView;
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTap)];
    [footerView addGestureRecognizer:addTap];
    
    UIImageView *addImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_circle_alpha"]];
    [footerView addSubview:addImv];
    [addImv makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(138));
        make.centerY.equalTo(footerView);
    }];
    
    UILabel *titleLb = [UILabel hl_regularWithColor:@"#565656" font:13];
    titleLb.text = @"添加卡权益";
    [footerView addSubview:titleLb];
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addImv.right).offset(FitPTScreen(8));
        make.centerY.equalTo(addImv);
    }];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), ScreenW, bottomHight)];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    [self.view addSubview:bottomView];
    UIButton *productBtn = [[UIButton alloc] init];
    [bottomView addSubview:productBtn];
    [productBtn setTitle:_cardId.length?@"确认修改":@"确认发布" forState:UIControlStateNormal];
    productBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [productBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [productBtn setBackgroundImage:[UIImage imageNamed:@"button_bag"] forState:UIControlStateNormal];
    [productBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(FitPTScreen(-17) - Height_Bottom_Margn);
    }];
    [productBtn addTarget:self action:@selector(productClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)profits {
    if (!_profits) {
        _profits = [NSMutableArray array];
    }
    return _profits;
}

- (void)configDatasourceWithDict:(NSDictionary *)dict {
    
    BOOL add = !_cardId.length;
    
    NSDictionary *cardDict = dict[@"card"];
    
    HLRightInputTypeInfo *nameInfo = [[HLRightInputTypeInfo alloc]init];
    nameInfo.leftTip = @"* 卡名字";
    nameInfo.canInput = YES;
    nameInfo.cellHeight = FitPTScreen(50);
    nameInfo.placeHoder = @"请输入卡名字";
    nameInfo.needCheckParams = YES;
    nameInfo.errorHint = @"请输入卡名字";
    nameInfo.saveKey = @"cardName";
    nameInfo.text = add?@"":cardDict[@"cardName"];
    
    HLRightInputTypeInfo *cardInfo = [[HLRightInputTypeInfo alloc]init];
    cardInfo.leftTip = @"* 卡价值";
    cardInfo.canInput = YES;
    cardInfo.cellHeight = FitPTScreen(50);
    cardInfo.placeHoder = @"请输入卡原价";
    cardInfo.needCheckParams = YES;
    cardInfo.errorHint = @"请输入卡原价";
    cardInfo.rightText = @"元";
    cardInfo.keyBoardType = UIKeyboardTypeDecimalPad;
    cardInfo.saveKey = @"originalPrice";
    cardInfo.text = add?@"":[NSString stringWithFormat:@"%@",cardDict[@"originalPrice"]];
    
    HLRightInputTypeInfo *priceInfo = [[HLRightInputTypeInfo alloc]init];
    priceInfo.leftTip = @"* 卡售价";
    priceInfo.canInput = YES;
    priceInfo.cellHeight = FitPTScreen(50);
    priceInfo.placeHoder = @"请输入卡售价";
    priceInfo.needCheckParams = YES;
    priceInfo.errorHint = @"请输入卡售价";
    priceInfo.rightText = @"元";
    priceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
    priceInfo.saveKey = @"salePrice";
    priceInfo.text = add?@"":[NSString stringWithFormat:@"%@",cardDict[@"salePrice"]];
    
    HLRightInputTypeInfo *timeInfo = [[HLRightInputTypeInfo alloc]init];
    timeInfo.leftTip = @"* 卡有效期";
    timeInfo.rightText = @"年";
    timeInfo.cellHeight = FitPTScreen(50);
    timeInfo.needCheckParams = YES;
    timeInfo.canInput = NO;
    timeInfo.text = @"1";
    timeInfo.saveKey = @"termYear";
    NSArray *firstSection = @[nameInfo,cardInfo,priceInfo,timeInfo];
    
    HLInputUseDescInfo *descInfo = [[HLInputUseDescInfo alloc]init];
    descInfo.leftTip = @"使用须知";
    descInfo.showNum = YES;
    descInfo.maxNum = 50;
    descInfo.placeHolder = @"请输入卡描述（便于用户购买）";
    descInfo.hideBorder = YES;
    descInfo.singleLine = YES;
    descInfo.cellHeight = FitPTScreen(130);
    descInfo.type = HLInputCellTypeUseDesc;
    descInfo.saveKey = @"cardDesc";
    descInfo.text = add?@"":[cardDict[@"cardDesc"] filterwithRegex:@"\n"];
    NSArray *secondSection = @[descInfo];
    
    HLRightInputTypeInfo *fxInfo = [[HLRightInputTypeInfo alloc]init];
    fxInfo.leftTip = @"分销佣金";
    fxInfo.cellHeight = FitPTScreen(50);
    fxInfo.placeHoder = @"请输入分销金额";
    fxInfo.canInput = YES;
    fxInfo.rightText = @"元";
    fxInfo.keyBoardType = UIKeyboardTypeDecimalPad;
    fxInfo.saveKey = @"commissionPrice";
    fxInfo.text = add?@"":[NSString stringWithFormat:@"%@",cardDict[@"commissionPrice"]];
    NSArray *thirdSection = @[fxInfo];
//        卡权益
    [self.datasource addObject:firstSection];
    [self.datasource addObject:secondSection];
    if ([dict[@"showCommission"] boolValue]) {
        [self.datasource addObject:thirdSection];
    }
    [self.datasource addObject:self.profits];
    
    NSArray *profits =[HLProfitGoodInfo profitsWithDict:dict[@"gain"]];
    [self.profits addObjectsFromArray:profits];
    for (HLProfitGoodInfo *goodInfo in self.profits) {
        NSLog(@"goodinfo gaintype - %ld",goodInfo.gainType);
        if (goodInfo.gainType == 1 || goodInfo.gainType == 2 ||goodInfo.gainType == 3) {
            [self.addProfitTypes addObject:@(goodInfo.gainType)];
        }
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)addProfitTypes {
    if (!_addProfitTypes) {
        _addProfitTypes = [NSMutableArray array];
    }
    return _addProfitTypes;
}
@end
