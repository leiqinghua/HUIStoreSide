//
//  HLHotBuyAddController.m
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import "HLHotBuyAddController.h"
#import "HLRightInputViewCell.h"
#import "HLRightImageViewCell.h"
#import "HLInputUseDescViewCell.h"
#import "HLAdmitInputViewCell.h"
#import "HLHotBuyImageController.h"
#import "HLHotBuyKindView.h"
#import "HLHotBuySendRangeController.h"

static NSString *kPriceInfoLeftTip = @"抢购价";
static NSString *kOrinalPriceInfoLeftTip = @"商品原价";
static NSString *kNumberInfoLeftTip = @"抢购数量";

@interface HLHotBuyAddController () <UITableViewDelegate, UITableViewDataSource, HLAdmitInputViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *dataSource;

@property (nonatomic, copy) NSMutableDictionary *pargram;

@property (nonatomic, copy) NSArray *categoryData; // 分类数据，页面内缓存

@property (nonatomic, strong) HLHotBuyImageController *buyImage;

@end

@implementation HLHotBuyAddController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"添加爆款抢购"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self creatFootView];
}

/// 构建底部的view
- (void)creatFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"添加" forState:UIControlStateNormal];
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

#pragma mark - Private Method

// 开始上传
- (void)nextClick{
    HLRightInputTypeInfo *priceInfo = nil;
    HLRightInputTypeInfo *orinalPriceInfo = nil;
    HLRightInputTypeInfo *numberInfo = nil;
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    for (HLBaseTypeInfo *info in self.dataSource) {
        if (info.needCheckParams && ![info checkParamsIsOk]) {
            HLShowHint(info.errorHint, self.view);
            return;
        }else{
            if (info.mParams.count > 0) {
                [mParams setValuesForKeysWithDictionary:info.mParams];
            }else{
                [mParams setValue:info.text forKey:info.saveKey];
            }
        }
        
        if ([info.leftTip containsString:kPriceInfoLeftTip]) {
            priceInfo = (HLRightInputTypeInfo *)info;
            
            if (priceInfo.text.doubleValue <= 0) {
                HLShowHint(@"抢购价必须大于0", self.view);
                return;
            }
        }
        
        if ([info.leftTip containsString:kOrinalPriceInfoLeftTip]) {
            orinalPriceInfo = (HLRightInputTypeInfo *)info;
            
            if (orinalPriceInfo.text.doubleValue <= 0) {
                HLShowHint(@"原价必须大于0", self.view);
                return;
            }
        }
        
        if ([info.leftTip containsString:kNumberInfoLeftTip]) {
            numberInfo = (HLRightInputTypeInfo *)info;
            
            if (numberInfo.text.integerValue <= 0) {
                HLShowHint(@"抢购数量必须大于0", self.view);
                return;
            }
        }
    }
    
    if (priceInfo.text.doubleValue >= orinalPriceInfo.text.doubleValue) {
        HLShowHint(@"原价必须大于抢购价", self.view);
        return;
    }
    
    NSLog(@"%@",mParams);
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/shopplus/hotgoods/add";
        request.serverType = HLServerTypeStoreService;
        request.parameters = mParams;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
    
        if ([responseObject code] == 200) {
            if (self.callBack) {
                self.callBack();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

// 展示分类选择视图
- (void)showCategorySelectViewWithIndexPath:(NSIndexPath *)indexPath{
    // 获取已选择的数据
    __block HLRightInputTypeInfo *kindInfo = self.dataSource[indexPath.row];
    NSArray *selectKinds = kindInfo.text.length ? [kindInfo.text componentsSeparatedByString:@">"] : @[];
    [self loadCategoryDataWithCallBack:^(NSArray *categoryData) {
        [HLHotBuyKindView showHotBuyKindView:selectKinds allDatas:categoryData callBack:^(NSString * _Nonnull selectName, NSInteger firstId, NSInteger secondId, NSInteger thirdId) {
            kindInfo.text = selectName;
            kindInfo.mParams = @{
                @"cid":@(firstId),
                @"sub_cid":@(secondId),
                @"ssub_cid":@(thirdId)
            };
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}

// 获取分类信息
- (void)loadCategoryDataWithCallBack:(void(^)(NSArray *categoryData))callBack{
    if (self.categoryData.count > 0) {
        callBack(self.categoryData);
        return;
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/shopplus/hotgoods/category";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 处理数据
            self.categoryData = [HLHotBuyKindModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"list"]];
            if (callBack) {
                callBack(self.categoryData);
            }
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - HLAdmitInputViewDelegate

// 切换自提还是上门
-(void)admitViewWithModel:(HLBaseTypeInfo *)inputInfo admit:(BOOL)admit{
    NSMutableDictionary *mParams = [inputInfo.mParams mutableCopy];
    [mParams setObject:admit ? @2 : @1 forKey:@"is_custom"];
    if ([mParams.allKeys containsObject:@"distance"]) {
        [mParams removeObjectForKey:@"distance"];
    }
    inputInfo.mParams = [mParams copy];
    inputInfo.text = @"";
    inputInfo.cellHeight = admit?FitPTScreen(100):FitPTScreen(51);
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
        case HLInputCellTypeUseDesc:
        {
            HLInputUseDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputUseDescViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        case HLInputCellTypeRightImage:
        {
            HLRightImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightImageViewCell" forIndexPath:indexPath];
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
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    return [info cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    
    if ([info.leftTip isEqualToString:@"商品图册"]) {
        [self.view endEditing:YES];
        if (!_buyImage) {
            _buyImage = [[HLHotBuyImageController alloc] init];
            weakify(self);
            __block HLRightImageTypeInfo *imageInfo = (HLRightImageTypeInfo *)info;
            _buyImage.callBack = ^(NSString * _Nonnull pic, NSString * _Nonnull detail_pic, UIImage *firstImage, NSInteger count) {
                imageInfo.mParams = @{
                    @"pic":pic,
                    @"detail_pic":detail_pic
                };
                imageInfo.count = count;
                imageInfo.selectImage = firstImage;
                [weak_self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
        [self.navigationController pushViewController:_buyImage animated:YES];
        return;
    }
    
    if ([info.leftTip containsString:@"商品类别"]) {
        [self.view endEditing:YES];
        [self showCategorySelectViewWithIndexPath:indexPath];
        return;
    }
    
    if ([info.leftTip containsString:@"配送方式"] && [(HLAdmitInputInfo *)info admit]) {
        [self.view endEditing:YES];
        __block HLAdmitInputInfo *rangeInfo = (HLAdmitInputInfo *)info;
        HLHotBuySendRangeController *range = [[HLHotBuySendRangeController alloc] init];
        range.callBack = ^(BOOL isCustom, NSInteger range) {
            NSMutableDictionary *mParams = [info.mParams mutableCopy];
            [mParams setObject:@(range) forKey:@"distance"];
            rangeInfo.mParams = [mParams copy];
            NSString *rangeText = range > 0 ? [NSString stringWithFormat:@"%ld公里",range] : @"不限";
            rangeInfo.text = [NSString stringWithFormat:@"已选%@:%@",isCustom ? @"自定义" : @"推荐",rangeText];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:range animated:YES];
        return;
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(18), 0, FitPTScreen(9));
        _tableView.separatorColor = SeparatorColor;
        _tableView.showsVerticalScrollIndicator = NO;
        AdjustsScrollViewInsetNever(self, _tableView);
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLInputUseDescViewCell class] forCellReuseIdentifier:@"HLInputUseDescViewCell"];
        [_tableView registerClass:[HLRightImageViewCell class] forCellReuseIdentifier:@"HLRightImageViewCell"];
        [_tableView registerClass:[HLAdmitInputViewCell class] forCellReuseIdentifier:@"HLAdmitInputViewCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        HLRightInputTypeInfo *nameInfo = [[HLRightInputTypeInfo alloc] init];
        nameInfo.leftTip = @"商品名称";
        nameInfo.placeHoder = @"请输入商品名称";
        nameInfo.cellHeight = FitPTScreen(51);
        nameInfo.canInput = YES;
        nameInfo.saveKey = @"proname";
        nameInfo.needCheckParams = YES;
        nameInfo.errorHint = @"请输入商品名称";
        
        HLRightImageTypeInfo *imageInfo = [[HLRightImageTypeInfo alloc]init];
        imageInfo.leftTip = @"商品图册";
        imageInfo.cellHeight = FitPTScreen(101);
        imageInfo.saveKey = @"";
        imageInfo.needCheckParams = YES;
        imageInfo.errorHint = @"请上传图片";
        imageInfo.type = HLInputCellTypeRightImage;
        
        HLRightInputTypeInfo *priceInfo = [[HLRightInputTypeInfo alloc] init];
        priceInfo.leftTip = kPriceInfoLeftTip;
        priceInfo.placeHoder = @"¥请输入商品抢购价";
        priceInfo.cellHeight = FitPTScreen(51);
        priceInfo.canInput = YES;
        priceInfo.saveKey = @"prounitprice";
        priceInfo.needCheckParams = YES;
        priceInfo.errorHint = @"请输入商品抢购价";
        priceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        
        HLRightInputTypeInfo *oriPriceInfo = [[HLRightInputTypeInfo alloc] init];
        oriPriceInfo.leftTip = kOrinalPriceInfoLeftTip;
        oriPriceInfo.placeHoder = @"¥请输入商品原价";
        oriPriceInfo.cellHeight = FitPTScreen(51);
        oriPriceInfo.canInput = YES;
        oriPriceInfo.saveKey = @"market_price";
        oriPriceInfo.needCheckParams = YES;
        oriPriceInfo.errorHint = @"请输入商品原价";
        oriPriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        
        HLRightInputTypeInfo *numInfo = [[HLRightInputTypeInfo alloc] init];
        numInfo.leftTip = kNumberInfoLeftTip;
        numInfo.placeHoder = @"请输入抢购数量（如：100、200等）";
        numInfo.cellHeight = FitPTScreen(51);
        numInfo.canInput = YES;
        numInfo.saveKey = @"propurveynum";
        numInfo.needCheckParams = YES;
        numInfo.errorHint = @"请输入抢购数量";
        numInfo.keyBoardType = UIKeyboardTypeNumberPad;
        
        HLRightInputTypeInfo *classInfo = [[HLRightInputTypeInfo alloc] init];
        classInfo.leftTip = @"商品类别";
        classInfo.placeHoder = @"请选择商品类别";
        classInfo.cellHeight = FitPTScreen(51);
        classInfo.canInput = NO;
        classInfo.saveKey = @"";
        classInfo.showRightArrow = YES;
        classInfo.needCheckParams = YES;
        classInfo.errorHint = @"请选择商品类别";
        
        HLAdmitInputInfo * admitInfo = [[HLAdmitInputInfo alloc]init];
        admitInfo.cellHeight = FitPTScreen(51);
        admitInfo.type = HLInputCellTypeAdmit;
        admitInfo.leftTip = @"配送方式";
        admitInfo.subText = @"配送范围";
        admitInfo.placeHolder = @"请选择配送范围";
        admitInfo.saveKey = @"is_custom";
        admitInfo.mParams = @{@"is_custom":@(1)};
        admitInfo.needCheckParams = YES;
        admitInfo.errorHint = @"请选择配送范围";
        admitInfo.keyBoardType = UIKeyboardTypeNumberPad;
        admitInfo.showArrow = YES;
        admitInfo.showBox = false;
        admitInfo.titles = @[@"自提",@"配送上门"];
        
        HLInputUseDescInfo *useInfo = [[HLInputUseDescInfo alloc]init];
        useInfo.leftTip = @"备注";
        useInfo.placeHolder = @"请填写备注信息\n如：填写商品特色或其他说明等";
        useInfo.type = HLInputCellTypeUseDesc;
        useInfo.cellHeight = FitPTScreen(172);
        useInfo.saveKey = @"brief_nick";
        useInfo.showNum = YES;
        useInfo.maxNum = 200;
        
        NSArray *models = @[nameInfo,imageInfo,priceInfo,oriPriceInfo,numInfo,classInfo,admitInfo,useInfo];
        [_dataSource addObjectsFromArray:models];
    }
    return _dataSource;
    
}
@end
