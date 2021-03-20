//
//  HLSendOrderRewardController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderRewardController.h"
#import "HLRightInputViewCell.h"
#import "HLInputDateViewCell.h"
#import "HLSendOrderRewardInfo.h"

@interface HLSendOrderRewardController () <UITableViewDelegate,UITableViewDataSource,HLInputDateViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HLSendOrderRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    AdjustsScrollViewInsetNever(self, self.tableView);
    self.navigationItem.title = @"自提奖励";
    
    [self loadData];
    
    [self creatFootViewWithButtonTitle:@"保存"];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];

    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

/// 保存数据
- (void)saveButtonClick{
    [self.view endEditing:YES];
    
    // 判断
    NSDictionary *params = nil;
    HLInputDateInfo *info = self.dataSource.firstObject;
    if (info.swithOn) {
        HLRightInputTypeInfo *moneyInfo = self.dataSource.lastObject;
        if (moneyInfo.text.length == 0) {
            HLShowHint(@"请输入奖励金额", self.view);
            return;
        }
        params = @{@"isReward":@"1",@"money":@((NSInteger)(moneyInfo.text.doubleValue * 100)),@"type":self.type};
    }else{
        params = @{@"isReward":@"0",@"money":@"0",@"type":self.type};
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/SelfmentionRewardSet.php";
        request.parameters = params;
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            HLShowText(@"保存成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 加载数据
- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/SelfmentionReward.php";
        request.parameters = @{@"type":self.type?:@"1"};
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            HLSendOrderRewardInfo *mainInfo = [HLSendOrderRewardInfo mj_objectWithKeyValues:[XMResult dataDict:responseObject]];
            
            // 配置接收到的数据
            HLInputDateInfo *rewardInfo = self.dataSource.firstObject;
            rewardInfo.swithOn = mainInfo.isOpen;
            rewardInfo.leftTip = mainInfo.title;
            rewardInfo.placeHoder = mainInfo.subTitle;
            
            if (mainInfo.isOpen) {
                [self addMoneyInputInfo];
            }
            
            if (self.dataSource.count > 1) {
                HLRightInputTypeInfo *moneyInfo = self.dataSource.lastObject;
                moneyInfo.text = mainInfo.money ? [NSString hl_stringWithNoZeroMoney:mainInfo.money.doubleValue/100] : @"";
            }
            
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 移出
- (void)removeMoneyInputInfo{
    if (self.dataSource.count == 2) {
        [self.dataSource removeObjectAtIndex:1];
    }
}

/// 添加
- (void)addMoneyInputInfo{
    if (self.dataSource.count == 1) {
        
        HLRightInputTypeInfo *moneyInfo = [[HLRightInputTypeInfo alloc] init];
        moneyInfo.leftTip = @"立减金额";
        moneyInfo.placeHoder = @"¥自提时本单立减金额";
        moneyInfo.cellHeight = FitPTScreen(53);
        moneyInfo.canInput = YES;
        moneyInfo.saveKey = @"";
        moneyInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(14), 0, 0);
        moneyInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        [self.dataSource addObject:moneyInfo];
    }
}

#pragma mark - HLInputDateViewCellDelegate

/// 输入框
- (void)dateCell:(HLInputDateViewCell *)cell switchON:(BOOL)on{
    if (on) {
        [self addMoneyInputInfo];
    }else{
        [self removeMoneyInputInfo];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDate:
        {
            HLInputDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputDateViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypeDefault:
        {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    return info.cellHeight;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        HLInputDateInfo *rewardInfo = [[HLInputDateInfo alloc] init];
        rewardInfo.type = HLInputCellTypeDate;
        rewardInfo.leftTip = @"自提奖励";
        rewardInfo.placeHoder = @"如用户自提，本单可立减金额";
        rewardInfo.needCheckParams = YES;
        rewardInfo.dateType = 1;
        rewardInfo.swithOn = NO;
        rewardInfo.cellHeight = FitPTScreen(76);
        rewardInfo.saveKey = @"";
        rewardInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(14), 0, 0);
        [_dataSource addObject:rewardInfo];
    }
    return _dataSource;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLInputDateViewCell class] forCellReuseIdentifier:@"HLInputDateViewCell"];
    }
    return _tableView;
}

@end
