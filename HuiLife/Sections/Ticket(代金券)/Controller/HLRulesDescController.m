//
//  HLRulesDescController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLRulesDescController.h"
#import "HLRuleDescTableCell.h"
#import "HLRuleDescHeader.h"

@interface HLRulesDescController ()<UITableViewDelegate,UITableViewDataSource,HLRuleDescHeaderDelegate>

@property(strong,nonatomic)UITableView * tableView;

@property(strong,nonatomic)NSMutableArray * datasource;

@property(strong,nonatomic)NSMutableArray * selectRules;

@end

@implementation HLRulesDescController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"规则说明"];
}

//确认
-(void)concernClick{
    if (self.selectBlock) {
        NSMutableArray * texts = [NSMutableArray array];
        NSMutableString * addStr = [NSMutableString string];
        NSMutableString * idsStr = [NSMutableString string];
        for (HLRuleModel * model in self.selectRules) {
            [texts addObject:model.content];
            if (model.Id.length) {
                if (!idsStr.length) {
                   [idsStr appendString:model.Id];
                }else{
                   [idsStr appendFormat:@",%@",model.Id];
                }
            }else {
                if (!addStr.length) {
                    [addStr appendString:model.content];
                }else{
                    [addStr appendFormat:@"@%@",model.content];
                }
            }
        }
        self.selectBlock(texts,addStr,idsStr,self.selectRules);
    }
    [self hl_goback];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self creatFootView];
    
    [self loadRulesList];
}

/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"确认" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(concernClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLRuleDescTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLRuleDescTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.datasource[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLRuleModel * model = self.datasource[indexPath.row];
    model.selected = !model.selected;
    if ([self.selectRules containsObject:model] && !model.selected) {
        [self.selectRules removeObject:model];
    }else if (![self.selectRules containsObject:model] && model.selected){
        [self.selectRules addObject:model];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - HLRuleDescHeaderDelegate
-(void)ruleHeader:(HLRuleDescHeader *)header addRule:(HLRuleModel *)model{
    
    [self.datasource insertObject:model atIndex:0];
    [self.selectRules addObject:model];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = FitPTScreen(52);
        [_tableView registerClass:[HLRuleDescTableCell class] forCellReuseIdentifier:@"HLRuleDescTableCell"];
        
        HLRuleDescHeader * tableHeader = [[HLRuleDescHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(140))];
        _tableView.tableHeaderView = tableHeader;
        tableHeader.delegate = self;
    }
    return _tableView;
}

-(NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

-(NSMutableArray *)selectRules{
    if (!_selectRules) {
        _selectRules = [NSMutableArray array];
    }
    return _selectRules;
}


-(void)loadRulesList{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Couponmanager/getCouponRule";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"type":@(1)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleDatas:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)handleDatas:(NSArray *)data{
    
    NSArray * datas = [HLRuleModel mj_objectArrayWithKeyValuesArray:data];
    if (!_lastRules) {
        [self.datasource addObjectsFromArray:datas];
        [self.tableView reloadData];
        return;
    }
    
    NSMutableArray * ids = [NSMutableArray array];
    for (HLRuleModel * rule in self.lastRules) {
        if (!rule.Id.length) {
            [self.datasource addObject:rule];
            [self.selectRules addObject:rule];
        }else{
            [ids addObject:rule.Id];
        }
    }
    
    for (NSString * Id in ids) {
        for (HLRuleModel * model in datas) {
            if ([model.Id isEqualToString:Id]) {
                model.selected = YES;
                [self.selectRules addObject:model];
            }
        }
    }
    
    [self.datasource addObjectsFromArray:datas];
    
    [self.tableView reloadData];
}

@end
