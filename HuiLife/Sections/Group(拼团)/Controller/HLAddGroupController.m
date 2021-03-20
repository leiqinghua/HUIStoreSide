//
//  HLAddGroupController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/14.
//

#import "HLAddGroupController.h"
#import "HLRightInputViewCell.h"
#import "HLRightDownSelectCell.h"
#import "HLDownSelectView.h"
#import "HLRightButtonsViewCell.h"
#import "HLGroupViewController.h"

@interface HLAddGroupController ()<UITableViewDelegate,UITableViewDataSource,HLRightDownSelectCellDelegate,HLRightButtonsViewCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property (nonatomic, copy) NSMutableArray *dataSource;

@property(nonatomic,strong)HLRightInputTypeInfo *priceInfo;

@property(nonatomic,strong)NSMutableDictionary * pargram;

@property(nonatomic, strong) NSArray *times;

@end

@implementation HLAddGroupController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"发布拼团"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatFootView];
    [self.view addSubview:self.tableView];
    
    [self loadGroupNum];
}

- (void)nextClick {
    
    if (!_pargram) _pargram = [NSMutableDictionary dictionary];
    
    for (HLBaseTypeInfo * info  in self.dataSource) {
        if (info.needCheckParams && ![info checkParamsIsOk]) {
            HLShowHint(info.errorHint, self.view);
            return;
        }
        if (info.saveKey.length) {
            [self.pargram setObject:info.text forKey:info.saveKey];
        }
        if (info.mParams.count) {
            [self.pargram addEntriesFromDictionary:info.mParams];
        }
    }
    
    double groupPrice = [self.pargram[@"grpPrice"] doubleValue];
    if (groupPrice > [self.priceInfo.text doubleValue]) {
        HLShowHint(@"拼团价不能高于原价", self.view);
        return;
    }
    
    [self uploadData];
    
    HLLog(@"_pargram = %@",self.pargram);
    
}

/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"完成发布" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLRightDownSelectCell class] forCellReuseIdentifier:@"HLRightDownSelectCell"];
        [_tableView registerClass:[HLRightButtonsViewCell class] forCellReuseIdentifier:@"HLRightButtonsViewCell"];
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault:
        {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case HLInputCellTypeDownSelect:
        {
            HLRightDownSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightDownSelectCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.delegate = self;
            return cell;
        }
            break;
            
        case HLInputCellRightButton:
        {
            HLRightButtonsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightButtonsViewCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.baseInfo = info;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    return [info cellHeight];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HLRightInputTypeInfo *nameInfo = self.dataSource[indexPath.row];
        HLGroupViewController * groupVC = [[HLGroupViewController alloc]init];
        groupVC.select = YES;
        [self hl_pushToController:groupVC];
        
        weakify(self);
        groupVC.selectBlock = ^(NSString * _Nonnull name, NSString * _Nonnull Id, double price) {
            nameInfo.text = name;
            nameInfo.mParams = @{@"proId":Id};
            weak_self.priceInfo.text = [NSString stringWithFormat:@"%.2lf",price];
            [tableView reloadData];
        };
       
        return;
    }
}

#pragma mark - HLRightDownSelectCellDelegate
-(void)downSeletCell:(HLRightDownSelectCell *)cell selectInfo:(HLDownSelectInfo *)selectInfo appendView:(UIView *)view{
    
    [HLDownSelectView showSelectViewWithTitles:selectInfo.titles currentTitle:selectInfo.selectSubInfo.name needShowSelect:YES showSeperator:NO itemHeight:FitPTScreen(40) dependView:view showType:HLDownSelectTypeDown maxNum:6 hideCallBack:^{
        
    } callBack:^(NSInteger index) {
        selectInfo.selectSubInfo = selectInfo.subInfos[index];
        selectInfo.mParams = @{@"peoNum":selectInfo.selectSubInfo.Id};
        [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - HLRightButtonsViewCellDelegate
-(void)hlButtonsCellWithSelectIndex:(NSInteger)index typeInfo:(HLRightButtonsInfo *)info{
    
//    NSString * hour = @"24";
//    switch (index) {
//        case 1:
//            hour = @"48";
//            break;
//        case 2:
//            hour = @"72";
//            break;
//        default:
//            break;
//    }
    
    NSString *Id = _times[index][@"Id"];
    info.mParams = @{@"limitHour":Id};
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(void)loadGroupNum{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/ToGroupNum.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        [self handleDatasWithDict:result.data];
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

//提交
-(void)uploadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/GroupBuy.php?action=2";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.pargram;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self hl_goback];
            [HLNotifyCenter postNotificationName:HLAddGroupNotifi object:nil];
            [HLNotifyCenter postNotificationName:HLMarketToolReloadNotifi object:nil];
            HLShowHint(@"发布成功", self.view);
        }
       
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}



-(void)handleDatasWithDict:(NSDictionary *)dict{
    
    NSArray *list = dict[@"items"];
    _times = dict[@"time_blue"];
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *data in _times) {
        [titles addObject:data[@"name"]];
    }
    
    
    HLRightInputTypeInfo *nameInfo = [[HLRightInputTypeInfo alloc] init];
    nameInfo.leftTip = @"*名称";
    nameInfo.placeHoder = @"选择拼团秒杀商品";
    nameInfo.cellHeight = FitPTScreen(51);
    nameInfo.canInput = false;
    nameInfo.needCheckParams = YES;
    nameInfo.showRightArrow = YES;
    
    HLRightInputTypeInfo *priceInfo = [[HLRightInputTypeInfo alloc] init];
    priceInfo.leftTip = @"*原价";
    priceInfo.placeHoder = @"¥商品原价";
    priceInfo.needCheckParams = YES;
    priceInfo.cellHeight = FitPTScreen(51);
    priceInfo.canInput = false;
    priceInfo.saveKey = @"orgPrice";
    priceInfo.needCheckParams = YES;
    priceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
    _priceInfo = priceInfo;
    
    
    HLRightInputTypeInfo *groupInfo = [[HLRightInputTypeInfo alloc] init];
    groupInfo.leftTip = @"*拼团价";
    groupInfo.placeHoder = @"¥商品拼团价";
    groupInfo.cellHeight = FitPTScreen(51);
    groupInfo.canInput = YES;
    groupInfo.saveKey = @"grpPrice";
    groupInfo.needCheckParams = YES;
    groupInfo.keyBoardType = UIKeyboardTypeDecimalPad;
    groupInfo.errorHint = @"请输入拼团价";
    
    // 构建子类选择，如果数据请求错误的时候，用本地的
    NSArray *needOrderSubInfoDicts = @[@{@"Id":@"2",@"name":@"两人拼团"},@{@"Id":@"3",@"name":@"三人拼团"},@{@"Id":@"5",@"name":@"5人拼团"}];
    NSArray *needOrderSubInfos = [HLDownSelectSubInfo mj_objectArrayWithKeyValuesArray:list.count?list:needOrderSubInfoDicts];
    
    HLDownSelectInfo *needOrderInfo = [[HLDownSelectInfo alloc] init];
    needOrderInfo.subInfos = needOrderSubInfos;
    needOrderInfo.leftTip = @"*拼团人数";
    needOrderInfo.selectSubInfo = needOrderInfo.subInfos.firstObject;
    needOrderInfo.needCheckParams = YES;
    needOrderInfo.cellHeight = FitPTScreen(70);
    needOrderInfo.type = HLInputCellTypeDownSelect;
    needOrderInfo.mParams = @{@"peoNum":@"2"};
    
    HLRightButtonsInfo * buttonInfo = [[HLRightButtonsInfo alloc]init];
    buttonInfo.leftTip = @"*成团时间";
    buttonInfo.tip = @"每单在成团时间内没有拼到人数，自动退款";
    buttonInfo.titles = titles;
    buttonInfo.type = HLInputCellRightButton;
    buttonInfo.selectIndex = 0;
    buttonInfo.cellHeight = FitPTScreen(103);
    
    [_dataSource addObject:nameInfo];
    [_dataSource addObject:priceInfo];
    [_dataSource addObject:groupInfo];
    [_dataSource addObject:needOrderInfo];
    [_dataSource addObject:buttonInfo];
    
    [_tableView reloadData];
}

@end
