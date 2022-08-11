//
//  HLAddCardController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLAddCardController.h"
#import "HLRightInputViewCell.h"
#import "HLInputDateViewCell.h"
#import "HLRightBoxInputViewCell.h"
#import "HLAdmitInputViewCell.h"
#import "HLInputUseDescViewCell.h"
#import "HLCalendarViewController.h"
#import "HLTemplateController.h"

@interface HLAddCardController ()<UITableViewDelegate,UITableViewDataSource,HLAdmitInputViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property (nonatomic, copy) NSMutableArray *dataSource;

@property (nonatomic, copy) NSMutableDictionary *pargram;

//领取有效期
@property(nonatomic,copy)NSDate *recStaTime;
//使用有效期
@property(nonatomic,copy)NSDate *useStaTime;

@end

@implementation HLAddCardController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"卡营销"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self creatFootView];
}

- (void)nextClick{
    for (NSArray * infos in self.dataSource) {
        for (HLBaseTypeInfo *info in infos) {
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            // 参数验证通过，先判断 mParams ，再去设置text
            if(info.mParams.count > 0){
                [self.pargram setValuesForKeysWithDictionary:info.mParams];
            }
            if (info.saveKey) {
                [self.pargram setValue:info.text forKey:info.saveKey];
            }
        }
    }
    
    NSString * carNum = self.pargram[@"cardTimes"];
    if (carNum.length && carNum.doubleValue == 0) {
        HLShowHint(@"卡次数不能为0", self.view);
        return;
    }
    
    double  price = [self.pargram[@"salePrice"] doubleValue];
    double  oriPrice = [self.pargram[@"originaPrice"] doubleValue];
    if (price >= oriPrice) {
        HLShowHint(@"售价必须小于原价", self.view);
        return;
    }
    
    if (![self checkSelectDate]) {
        return;
    }
    
    [self.pargram setObject:@(_type) forKey:@"cardType"];
    
    if ([self.pargram objectForKey:@"cardDesc"]) {
        NSMutableString * desc = [self.pargram objectForKey:@"cardDesc"];
        NSString * replaceStr = [desc stringByReplacingOccurrencesOfString:@"\n" withString:@"@"];
        [self.pargram setObject:replaceStr forKey:@"cardDesc"];
    }
    
    HLTemplateController * template = [[HLTemplateController alloc]init];
    template.pargram = self.pargram;
    template.isTicket = false;
    [self hl_pushToController:template];
    
    HLLog(@"pargram = %@",self.pargram);
    
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
        [_tableView registerClass:[HLRightBoxInputViewCell class] forCellReuseIdentifier:@"HLRightBoxInputViewCell"];
        [_tableView registerClass:[HLAdmitInputViewCell class] forCellReuseIdentifier:@"HLAdmitInputViewCell"];
        [_tableView registerClass:[HLInputUseDescViewCell class] forCellReuseIdentifier:@"HLInputUseDescViewCell"];
        
    }
    return _tableView;
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
            return cell;
        }
            break;
        case HLInputCellTypeRightBox:
        {
            HLRightBoxInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightBoxInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case HLInputCellTypeAdmit:
        {
            HLAdmitInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLAdmitInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypeUseDesc:
        {
            HLInputUseDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputUseDescViewCell" forIndexPath:indexPath];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    
    UIView * headerView = [tableView headerViewForSection:section];
    if (!headerView) {
        headerView = [[UIView alloc]init];
        headerView.backgroundColor = UIColorFromRGB(0xF6F6F6);
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.textColor =UIColorFromRGB(0x333333);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        tipLb.text = @"规则说明";
        [headerView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(FitPTScreen(14));
        }];
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return FitPTScreen(35);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * infos = self.dataSource[indexPath.section];
    HLBaseTypeInfo *info = infos[indexPath.row];
    if ([info.leftTip isEqualToString:@"*领取有效期"] || [info.leftTip isEqualToString:@"*使用有效期"]) {
        weakify(self);
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
#pragma mark - HLAdmitInputViewDelegate
-(void)admitViewWithModel:(HLBaseTypeInfo *)inputInfo admit:(BOOL)admit{
    inputInfo.cellHeight = admit?FitPTScreen(126):FitPTScreen(51);
    inputInfo.mParams = @{@"isLimit":admit?@(1):@(2)};
    if (!admit) {
        inputInfo.text = @"";
    }
    [self.tableView reloadData];
}


-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        
        HLRightBoxInputInfo *nameInfo = [[HLRightBoxInputInfo alloc] init];
        nameInfo.type = HLInputCellTypeRightBox;
        nameInfo.leftTip = @"*名称";
        nameInfo.placeHolder = @"请输入卡名称";
        nameInfo.cellHeight = FitPTScreen(77);
        nameInfo.saveKey = @"cardName";
        nameInfo.needCheckParams = YES;
        nameInfo.errorHint = @"请输入卡名称";
        
        HLRightInputTypeInfo *numInfo = [[HLRightInputTypeInfo alloc] init];
        numInfo.leftTip = _type == 2?@"*卡数量":@"*卡次数";
        numInfo.placeHoder =_type == 2?@"请输入卡数量":@"请输入次数";
        numInfo.needCheckParams = YES;
        numInfo.cellHeight = FitPTScreen(51);
        numInfo.canInput = YES;
        numInfo.saveKey = @"cardTimes";
        numInfo.keyBoardType = UIKeyboardTypeNumberPad;
        numInfo.errorHint = _type == 2?@"请输入卡数量":@"请输入次数";;
        
        
        HLRightInputTypeInfo *totalNum = [[HLRightInputTypeInfo alloc] init];
        totalNum.leftTip = @"*发卡总数";
        totalNum.placeHoder = @"请输入卡总数量";
        totalNum.needCheckParams = YES;
        totalNum.cellHeight = FitPTScreen(51);
        totalNum.canInput = YES;
        totalNum.saveKey = @"cardCount";
        totalNum.keyBoardType = UIKeyboardTypeNumberPad;
        totalNum.errorHint = @"请输入卡总数量";
        
//        -----
        HLRightInputTypeInfo *dwInfo = [[HLRightInputTypeInfo alloc] init];
        dwInfo.leftTip = @"*设置单位";
        dwInfo.placeHoder =@"请输入单位（如：瓶）";
        dwInfo.needCheckParams = YES;
        dwInfo.cellHeight = FitPTScreen(51);
        dwInfo.canInput = YES;
        dwInfo.saveKey = @"cardUnit";
        dwInfo.errorHint = @"请输入单位";
        
        HLRightInputTypeInfo *seilPriceInfo = [[HLRightInputTypeInfo alloc] init];
        seilPriceInfo.leftTip = @"*售价";
        seilPriceInfo.placeHoder = @"¥请输入卡售价";
        seilPriceInfo.cellHeight = FitPTScreen(51);
        seilPriceInfo.canInput = YES;
        seilPriceInfo.saveKey = @"salePrice";
        seilPriceInfo.needCheckParams = YES;
        seilPriceInfo.errorHint = @"请输入售价";
        seilPriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        
        HLRightInputTypeInfo *priceInfo = [[HLRightInputTypeInfo alloc] init];
        priceInfo.leftTip = @"*原价";
        priceInfo.placeHoder = @"¥请输入卡原价";
        priceInfo.cellHeight = FitPTScreen(51);
        priceInfo.canInput = YES;
        priceInfo.saveKey = @"originaPrice";
        priceInfo.needCheckParams = YES;
        priceInfo.errorHint = @"请输入原价";
        priceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        
        HLInputDateInfo *acceptInfo = [[HLInputDateInfo alloc] init];
        acceptInfo.type = HLInputCellTypeDate;
        acceptInfo.leftTip = @"*领取有效期";
        acceptInfo.placeHoder = @"请选择领取有效期";
        acceptInfo.needCheckParams = YES;
        acceptInfo.cellHeight = FitPTScreen(72);
        acceptInfo.errorHint = @"请选择领取有效期";
        
        
        HLInputDateInfo *dateInfo = [[HLInputDateInfo alloc] init];
        dateInfo.type = HLInputCellTypeDate;
        dateInfo.leftTip = @"*使用有效期";
        dateInfo.placeHoder = @"请选择使用有效期";
        dateInfo.needCheckParams = YES;
        dateInfo.cellHeight = FitPTScreen(72);
        dateInfo.errorHint = @"请选择使用有效期";
        
        HLAdmitInputInfo * admitInfo = [[HLAdmitInputInfo alloc]init];
        admitInfo.cellHeight = FitPTScreen(51);
        admitInfo.type = HLInputCellTypeAdmit;
        admitInfo.canInput = YES;
        admitInfo.leftTip = @"限领说明";
        admitInfo.subText = @"每人限领";
        admitInfo.placeHolder = @"请输入每人限领";
        admitInfo.saveKey = @"limitOneNum";
        admitInfo.mParams = @{@"isLimit":@(0)};
        admitInfo.needCheckParams = YES;
        admitInfo.errorHint = @"请输入卡的限领数量";
        admitInfo.keyBoardType = UIKeyboardTypeNumberPad;
        admitInfo.showArrow = false;
        admitInfo.showBox = YES;
        admitInfo.titles = @[@"不限领取",@"每人限领"];
        
        HLInputUseDescInfo * useInfo = [[HLInputUseDescInfo alloc]init];
        useInfo.leftTip = @"使用说明";
        useInfo.placeHolder = @"请输入使用说明";
        useInfo.type = HLInputCellTypeUseDesc;
        useInfo.cellHeight = FitPTScreen(149);
        useInfo.saveKey = @"cardDesc";
        useInfo.changeLine = YES;
        
        
        NSArray *firstSection = @[nameInfo,numInfo,totalNum,seilPriceInfo,priceInfo,acceptInfo,dateInfo];
        if (_type == 2) {
            firstSection = @[nameInfo,numInfo,dwInfo,totalNum,seilPriceInfo,priceInfo,acceptInfo,dateInfo];
        }
        
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:firstSection];
        [_dataSource addObject:@[admitInfo,useInfo]];
    }
    return _dataSource;
}

@end
