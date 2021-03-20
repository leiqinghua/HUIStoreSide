//
//  HLSekillPromoteAddController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLSekillPromoteAddController.h"
#import "HLRightInputViewCell.h"
#import "HLDownSelectView.h"
#import "HLRightSwitchViewCell.h"
#import "HLInputDateViewCell.h"
#import "HLPayPromoteDayCell.h"
#import "HLTGLevelViewCell.h"
#import "HLHotSekillListController.h"

const NSInteger kOriPricelInfoIndex = 1;
const NSInteger kSalePricelInfoIndex = 2;
const NSInteger kFloorPricelInfoIndex = 3;
const NSInteger kLevelInfoIndex = 4;

@interface HLSekillPromoteAddController () <UITableViewDelegate,UITableViewDataSource,HLRightInputViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation HLSekillPromoteAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"爆款秒杀推广";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    [self creatFootViewWithButtonTitle:@"保存"];
    
    // 判断，如果是编辑就拉取数据
    if (self.listModel) {
        [self loadPageData];
    }
}

/// 保存数据
- (void)saveButtonClick{
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    
    if (self.listModel) {
        [mParams setValue:self.listModel.Id forKey:@"proId"];
    }
    
    HLBaseTypeInfo *floorPriceInfo = nil;
    HLBaseTypeInfo *salePriceInfo = nil;
    for (HLBaseTypeInfo *info in self.dataSource) {
        if (info.saveKey.length == 0) {
            continue;
        }
        // 如果必须要验证参数，那么就判断参数
        if (info.needCheckParams) {
            if (![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
        }
        // 参数验证通过，先判断 mParams ，再去设置text
        if(info.mParams.count > 0){
            [mParams setValuesForKeysWithDictionary:info.mParams];
        }else{
            [mParams setValue:info.text forKey:info.saveKey];
        }
        
        if ([info.leftTip containsString:@"售价"]) {salePriceInfo = info;}
        if ([info.leftTip containsString:@"底价"]) {floorPriceInfo = info;}

    }
    
    if (floorPriceInfo.text.doubleValue <= 0) {
        HLShowHint(@"底价不能为0", self.view);
        return;
    }
    
    if (floorPriceInfo.text.doubleValue >= salePriceInfo.text.doubleValue) {
        HLShowHint(@"底价必须低于售价", self.view);
        return;
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSide/HotSeckillPopulInsert.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = mParams;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            HLShowText(@"保存成功");
            if(self.addBlock){
                self.addBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 拉取页面数据
- (void)loadPageData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSide/HotSeckillPopulEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"proId":self.listModel.Id};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            NSDictionary *dataDict = responseObject.data;
            
            HLRightInputTypeInfo *sekillGoodInfo = self.dataSource[0];
            sekillGoodInfo.mParams = @{sekillGoodInfo.saveKey :[HLTools safeStringObject:dataDict[@"id"]]};
            sekillGoodInfo.text = dataDict[@"title"];
            
            HLRightInputTypeInfo *orinalPriceInfo = self.dataSource[1];
            orinalPriceInfo.text = [NSString hl_stringWithNoZeroMoney:[dataDict[@"orgPrice"] doubleValue]];
            
            HLRightInputTypeInfo *salePriceInfo = self.dataSource[2];
            salePriceInfo.text = [NSString hl_stringWithNoZeroMoney:[dataDict[@"price"] doubleValue]];
            
            HLRightInputTypeInfo *endPriceInfo = self.dataSource[3];
            endPriceInfo.text = [NSString hl_stringWithNoZeroMoney:[dataDict[@"floorPrice"] doubleValue]];
            
            [self caclutePopular];
            
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(100));
    
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

#pragma mark - HLRightInputViewCellDelegate

/// 输入框值改变
- (void)inputViewCell:(HLRightInputViewCell *)cell textChanged:(HLRightInputTypeInfo *)inputInfo{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 3) {
        [self caclutePopular];
//        [self.tableView reloadData];
    }
}

/// 计算推广强度
- (void)caclutePopular{
    // 售价
    HLRightInputTypeInfo *salePriceInfo = self.dataSource[kSalePricelInfoIndex];
    // 底价
    HLRightInputTypeInfo *floorPriceInfo = self.dataSource[kFloorPricelInfoIndex];
    HLTGLevelInfo *levelInfo = self.dataSource[kLevelInfoIndex];
    // 如果两个都没有数据，就return
    if(salePriceInfo.text.length == 0 || floorPriceInfo.text == 0){
        levelInfo.levle = 0;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kLevelInfoIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        return;
    };
    
    double discount = floorPriceInfo.text.doubleValue/salePriceInfo.text.doubleValue;
    NSInteger level = 0;
    if (discount >= 0.9) {
        level = 0;
    }else if(discount >= 0.8){
        level = 1;
    }else{
        level = 2;
    }
    levelInfo.levle = level;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kLevelInfoIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypeTGLevel:
        {
            HLTGLevelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLTGLevelViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            return cell;
        }
            break;
        case HLInputCellTypeDate:
        {
            HLInputDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputDateViewCell" forIndexPath:indexPath];
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
    return [self.dataSource[indexPath.row] cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 选择秒杀产品 , 如果是编辑的时候就不能再选择了
    if (indexPath.row == 0 && !self.listModel) {
        HLHotSekillListController *hotSekillList = [[HLHotSekillListController alloc] init];
        hotSekillList.selectBlock = ^(HLHotSekillGoodModel *goodModel) {
            // 第一个爆款秒杀
            HLRightInputTypeInfo *goodInfo = self.dataSource.firstObject;
            goodInfo.mParams = @{goodInfo.saveKey : goodModel.Id};
            goodInfo.text = goodModel.title;
            // 原价
            HLRightInputTypeInfo *oriPriceInfo = self.dataSource[kOriPricelInfoIndex];
            oriPriceInfo.text = [NSString hl_stringWithNoZeroMoney:goodModel.orgPrice];
            // 售价
            HLRightInputTypeInfo *salePriceInfo = self.dataSource[kSalePricelInfoIndex];
            salePriceInfo.text = [NSString hl_stringWithNoZeroMoney:goodModel.price];
            
            [self caclutePopular];
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:hotSekillList animated:YES];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLTGLevelViewCell class] forCellReuseIdentifier:@"HLTGLevelViewCell"];
        [_tableView registerClass:[HLInputDateViewCell class] forCellReuseIdentifier:@"HLInputDateViewCell"];
        
    }
    return _tableView;
}


-(NSArray *)dataSource{
    if (!_dataSource) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        HLRightInputTypeInfo *sekillGoodInfo = [[HLRightInputTypeInfo alloc] init];
        sekillGoodInfo.leftTip = @"*爆款秒杀";
        sekillGoodInfo.placeHoder = @"请选择爆款秒杀产品";
        sekillGoodInfo.cellHeight = FitPTScreen(53);
        sekillGoodInfo.canInput = NO;
        sekillGoodInfo.saveKey = @"proId";
        sekillGoodInfo.errorHint = @"请选择爆款秒杀产品";
        sekillGoodInfo.needCheckParams = YES;
        sekillGoodInfo.showRightArrow = YES;
        sekillGoodInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(13), 0, 0);
        [mArr addObject:sekillGoodInfo];
        
        HLRightInputTypeInfo *orinalPriceInfo = [[HLRightInputTypeInfo alloc] init];
        orinalPriceInfo.leftTip = @"*原价";
        orinalPriceInfo.placeHoder = @"商品原价";
        orinalPriceInfo.needCheckParams = NO;
        orinalPriceInfo.cellHeight = FitPTScreen(53);
        orinalPriceInfo.saveKey = @"";
        orinalPriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        orinalPriceInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(13), 0, 0);
        [mArr addObject:orinalPriceInfo];
        
        HLRightInputTypeInfo *salePriceInfo = [[HLRightInputTypeInfo alloc] init];
        salePriceInfo.leftTip = @"*售价";
        salePriceInfo.placeHoder = @"商品售价";
        salePriceInfo.needCheckParams = YES;
        salePriceInfo.cellHeight = FitPTScreen(53);
        salePriceInfo.canInput = NO;
        salePriceInfo.saveKey = @"";
        salePriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        salePriceInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(13), 0, 0);
        [mArr addObject:salePriceInfo];
        
        HLRightInputTypeInfo *endPriceInfo = [[HLRightInputTypeInfo alloc] init];
        endPriceInfo.leftTip = @"*底价";
        endPriceInfo.placeHoder = @"¥商品给平台最低价";
        endPriceInfo.needCheckParams = YES;
        endPriceInfo.cellHeight = FitPTScreen(53);
        endPriceInfo.canInput = YES;
        endPriceInfo.saveKey = @"floorPrice";
        endPriceInfo.errorHint = @"请输入最低价";
        endPriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        endPriceInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(13), 0, 0);
        [mArr addObject:endPriceInfo];
        
        HLTGLevelInfo *levleInfo = [[HLTGLevelInfo alloc] init];
        levleInfo.type = HLInputCellTypeTGLevel;
        levleInfo.leftTip = @"推广强度";
        levleInfo.needCheckParams = NO;
        levleInfo.cellHeight = FitPTScreen(53);
        levleInfo.saveKey = @"";
        [mArr addObject:levleInfo];
        
        _dataSource = [mArr copy];
    }
    return _dataSource;
}



@end
