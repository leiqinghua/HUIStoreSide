//
//  HLAddTicketController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/5.
//

#import "HLAddTicketController.h"
#import "HLRightInputViewCell.h"
#import "HLInputDateViewCell.h"
#import "HLRuleDescViewCell.h"
#import "HLRulesDescController.h"
#import "HLTemplateController.h"
#import "HLCalendarViewController.h"

@interface HLAddTicketController ()<UITableViewDelegate,UITableViewDataSource,HLInputDateViewCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property (nonatomic, copy) NSMutableArray *dataSource;
//消费满赠送
@property(nonatomic,strong)HLRightInputTypeInfo * giftInfo;

@property(nonatomic,strong)NSMutableDictionary * pargrams;

//领取有效期
@property(nonatomic,copy)NSDate *recStaTime;
//使用有效期
@property(nonatomic,copy)NSDate *useStaTime;

@property(nonatomic,strong)NSArray *selectRules;

@end

@implementation HLAddTicketController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"添加代金券"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self creatFootView];
}


-(void)nextClick{
    
    for (NSArray * infos in self.dataSource) {
        for (HLBaseTypeInfo *info in infos) {
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            // 参数验证通过，先判断 mParams ，再去设置text
            if(info.mParams.count > 0){
                [self.pargrams setValuesForKeysWithDictionary:info.mParams];
            }else{
                if (info.saveKey) {
                  [self.pargrams setValue:info.text forKey:info.saveKey];
                }
            }
        }
    }
    
    if (![self checkSelectDate]) {
        return;
    }
    
    HLTemplateController * templateVC = [[HLTemplateController alloc]init];
    templateVC.isTicket = YES;
    templateVC.pargram = self.pargrams;
    [self hl_pushToController:templateVC];
    
    HLLog(@"self.pargrams = %@",self.pargrams);
}


//比较使用有效期 和领取有效期（领取有效期 小于 使用）
-(BOOL)checkSelectDate{
    
    if (!_recStaTime || !_useStaTime) {
        return YES;
    }
    NSComparisonResult result = [_recStaTime compare:_useStaTime];
    
    if (result == NSOrderedDescending) {
        HLShowHint(@"领取有效期应小于使用有效期", self.view);
        return false;
    }
    
    return YES;
}

/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"下一步 选择主题" forState:UIControlStateNormal];
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

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSArray *)self.dataSource[section]).count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * infos = self.dataSource[indexPath.section];
    HLBaseTypeInfo *info = infos[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault:
        {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case HLInputCellTypeDate:
        {
            HLInputDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputDateViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypeRuleDesc:
        {
            HLRuleDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRuleDescViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * infos = self.dataSource[indexPath.section];
    HLBaseTypeInfo *info = infos[indexPath.row];
    return [info cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * infos = self.dataSource[indexPath.section];
    HLBaseTypeInfo *info = infos[indexPath.row];
    
    weakify(self);
    if (indexPath.section == 2) {
        HLRulesDescController * rules = [[HLRulesDescController alloc]init];
        rules.lastRules = _selectRules;
        [self hl_pushToController:rules];
        
        rules.selectBlock = ^(NSArray *texts, NSString *addTexts, NSString *ids,NSArray * rules) {
            HLRuleDescTypeInfo *gzInfo =(HLRuleDescTypeInfo *)info;
            gzInfo.rules = texts;
            gzInfo.mParams = @{@"ruleDesc":addTexts,@"ruleIds":ids};
            weak_self.selectRules = rules;
            gzInfo.placeHolder =rules.count?@"以下是已选择":@"去选择";
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return;
    }
    
    if ([info.leftTip isEqualToString:@"*领取有效期"] || [info.leftTip isEqualToString:@"*使用有效期"]) {
        HLCalendarViewController * calender = [[HLCalendarViewController alloc]initWithCallBack:^(NSDate *start, NSDate *end) {
            NSString * startStr = [HLTools formatterWithDate:start formate:@"yyyy-MM-dd"];
            NSString * endStr = [HLTools formatterWithDate:end formate:@"yyyy-MM-dd"];
            HLInputDateInfo * dateInfo = (HLInputDateInfo *)info;
            dateInfo.text = [NSString stringWithFormat:@"%@ - %@",startStr,endStr];
            if ([info.leftTip isEqualToString:@"*领取有效期"] && start && end) {
               dateInfo.mParams = @{@"recStaTime":startStr,@"recEndTime":endStr};
               weak_self.recStaTime = start;
            }else{
                if (start && end) {
                  dateInfo.mParams = @{@"useStaTime":startStr,@"useEndTime":endStr};;
                  weak_self.useStaTime = start;
                }
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController presentViewController:calender animated:false completion:nil];
    }
    
    
    
}

#pragma mark - HLInputDateViewCellDelegate
-(void)dateCell:(HLInputDateViewCell *)cell switchON:(BOOL)on{
    
    NSMutableArray * datas = self.dataSource[1];
    
    if (on && ![datas containsObject:self.giftInfo]) {
        [datas addObject:self.giftInfo];
    }else if (!on && [datas containsObject:self.giftInfo]){
        [datas removeObject:self.giftInfo];
    }
    
    if (!on) {
        self.giftInfo.text = @"";
        [self.pargrams removeObjectForKey:self.giftInfo.saveKey];
    }
    
    [self.dataSource replaceObjectAtIndex:1 withObject:datas];
    [self.tableView reloadData];
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
        [_tableView registerClass:[HLInputDateViewCell class] forCellReuseIdentifier:@"HLInputDateViewCell"];
        [_tableView registerClass:[HLRuleDescViewCell class] forCellReuseIdentifier:@"HLRuleDescViewCell"];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        
        HLRightInputTypeInfo *companyInfo = [[HLRightInputTypeInfo alloc] init];
        companyInfo.leftTip = @"*券金额";
        companyInfo.placeHoder = @"¥使用时优惠的金额";
        companyInfo.cellHeight = FitPTScreen(51);
        companyInfo.canInput = YES;
        companyInfo.saveKey = @"couponPrice";
        companyInfo.needCheckParams = YES;
        companyInfo.errorHint = @"请输入优惠金额";
        companyInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        
        HLRightInputTypeInfo *addressInfo = [[HLRightInputTypeInfo alloc] init];
        addressInfo.leftTip = @"*售价";
        addressInfo.placeHoder = @"¥售价 0为免费领取";
        addressInfo.canInputZero = YES;
        addressInfo.cellHeight = FitPTScreen(51);
        addressInfo.canInput = YES;
        addressInfo.saveKey = @"salePrice";
        addressInfo.needCheckParams = YES;
        addressInfo.errorHint = @"请输入售价";
        addressInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        
        HLRightInputTypeInfo *addressDetailInfo = [[HLRightInputTypeInfo alloc] init];
        addressDetailInfo.leftTip = @"限额使用";
        addressDetailInfo.placeHoder = @"¥满多少元可使用券，可不填";
        addressDetailInfo.cellHeight = FitPTScreen(51);
        addressDetailInfo.canInput = YES;
        addressDetailInfo.saveKey = @"limitPrice";
        addressDetailInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        
        HLRightInputTypeInfo *numberInfo = [[HLRightInputTypeInfo alloc] init];
        numberInfo.leftTip = @"*发售总数量";
        numberInfo.placeHoder = @"发售总数量领完为止";
        numberInfo.rightText = @"份";
        numberInfo.cellHeight = FitPTScreen(51);
        numberInfo.canInput = YES;
        numberInfo.saveKey = @"limitNum";
        numberInfo.keyBoardType = UIKeyboardTypeNumberPad;
        numberInfo.needCheckParams = YES;
        numberInfo.errorHint = @"请输入领取总数量";
        
        
        HLRightInputTypeInfo *bankNameInfo = [[HLRightInputTypeInfo alloc] init];
        bankNameInfo.leftTip = @"*每人限领";
        bankNameInfo.placeHoder = @"每人限领多少份";
        bankNameInfo.rightText = @"份";
        bankNameInfo.needCheckParams = YES;
        bankNameInfo.cellHeight = FitPTScreen(51);
        bankNameInfo.canInput = YES;
        bankNameInfo.saveKey = @"limitOneNum";
        bankNameInfo.needCheckParams = YES;
        bankNameInfo.keyBoardType = UIKeyboardTypeNumberPad;
        bankNameInfo.errorHint = @"请输入每人限领多少份";
        
        HLInputDateInfo * acceptDate = [[HLInputDateInfo alloc]init];
        acceptDate.type = HLInputCellTypeDate;
        acceptDate.leftTip = @"*领取有效期";
        acceptDate.text = @"";
        acceptDate.placeHoder = @"在有效期内可领取";
        acceptDate.cellHeight = FitPTScreen(76);
        acceptDate.needCheckParams = YES;
        acceptDate.errorHint = @"请选择领取有效期";
        
        HLInputDateInfo * useDate = [[HLInputDateInfo alloc]init];
        useDate.type = HLInputCellTypeDate;
        useDate.leftTip = @"*使用有效期";
        useDate.text = @"";
        useDate.placeHoder = @"在有效期内可领取";
        useDate.cellHeight = FitPTScreen(76);
        useDate.needCheckParams = YES;
        useDate.errorHint = @"请选择使用有效期";
        
        HLInputDateInfo * giftInfo = [[HLInputDateInfo alloc]init];
        giftInfo.type = HLInputCellTypeDate;
        giftInfo.dateType = 1;
        giftInfo.leftTip = @"满额消费赠送此券";
        giftInfo.text = @"";
        giftInfo.placeHoder = @"买单时赠送代金券，下次买单时可使用";
        giftInfo.cellHeight = FitPTScreen(76);
        giftInfo.saveKey = @"isGive";
        
        
        HLRuleDescTypeInfo *gzInfo = [[HLRuleDescTypeInfo alloc] init];
        gzInfo.type = HLInputCellTypeRuleDesc;
        gzInfo.leftTip = @"使用说明";
        gzInfo.placeHolder = @"去选择";
        
        NSArray *firstSection = @[companyInfo,addressInfo,addressDetailInfo,numberInfo,bankNameInfo,acceptDate,useDate];
        NSMutableArray * secondArr = [NSMutableArray arrayWithArray:@[giftInfo]];
        NSMutableArray * thirdArr = [NSMutableArray arrayWithArray:@[gzInfo]];
        
        
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:firstSection];
        [_dataSource addObject:secondArr];
        [_dataSource addObject:thirdArr];
    }
    return _dataSource;
}


-(HLRightInputTypeInfo *)giftInfo{
    if (!_giftInfo) {
        _giftInfo = [[HLRightInputTypeInfo alloc] init];
        _giftInfo.leftTip = @"*消费满赠送";
        _giftInfo.placeHoder = @"¥满多少元总送此券";
        _giftInfo.cellHeight = FitPTScreen(51);
        _giftInfo.canInput = YES;
        _giftInfo.saveKey = @"fullNume";
        _giftInfo.needCheckParams = YES;
        _giftInfo.errorHint = @"请输入消费满赠送金额";
        _giftInfo.keyBoardType = UIKeyboardTypeDecimalPad;
    }
    return _giftInfo;
}

-(NSMutableDictionary *)pargrams{
    if (!_pargrams) {
        _pargrams = [NSMutableDictionary dictionary];
    }
    return _pargrams;
}
@end
