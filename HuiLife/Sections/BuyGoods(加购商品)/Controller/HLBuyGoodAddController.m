//
//  HLBuyGoodAddController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBuyGoodAddController.h"
#import "HLBuyGoodPostController.h"
#import "HLCalendarViewController.h"
#import "HLImageSinglePickerController.h"
#import "HLInputDateViewCell.h"
#import "HLRightImageViewCell.h"
#import "HLRightInputViewCell.h"
#import "HLSelectArea.h"
#import "HLTimeSingleSelectView.h"
#import "HLVoucherMarketAddHead.h"
#import "HLVoucherMarketEditInfo.h"
#import "HLImagePickerController.h"

@interface HLBuyGoodAddController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HLVoucherMarketAddHead *tableHead;

@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, assign) double mainScale;

@end

@implementation HLBuyGoodAddController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"买单加购商品";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    [self creatFootViewWithButtonTitle:@"完成发布"];
    
    /// 加载领取方式
    [self loadAcceptType];
    
    [self loadImageResizeScale];
}

// 加载数据
- (void)loadImageResizeScale{
    [HLTools loadImageResizeScaleWithType:6 controller:self completion:^(double mainScale, double subScale) {
        self.mainScale = mainScale;
    }];
}

/// 加载领取方式
- (void)loadAcceptType {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *_Nonnull request) {
        request.api = @"/Shopplus/Billpurchased/getPickup";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    }
    onSuccess:^(XMResult *_Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            HLRightInputTypeInfo *acceptTypeInfo = self.dataSource[7];
            acceptTypeInfo.text = responseObject.data[@"name"];
            acceptTypeInfo.saveKey = @"pickup";
            acceptTypeInfo.mParams = @{ @"pickup": responseObject.data[@"id"] };
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    onFailure:^(NSError *_Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 提交数据
- (void)saveButtonClick {
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    UIImage *selectImage = nil;
    
    // 增加限制
    HLBaseTypeInfo *orinalInfo = nil;
    HLBaseTypeInfo *saleInfo = nil;
    HLBaseTypeInfo *conditionInfo = nil;
    HLBaseTypeInfo *sumNumInfo = nil;
    HLBaseTypeInfo *limitInfo = nil;
    
    for (HLBaseTypeInfo *info in self.dataSource) {
        if (info.type == HLInputCellTypeDefault || info.type == HLInputCellTypeDate) {
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            // 参数验证通过，先判断 mParams ，再去设置text
            if (info.mParams.count > 0) {
                [mParams setValuesForKeysWithDictionary:info.mParams];
            } else {
                if (info.text && info.text.length > 0) {
                    [mParams setValue:info.text forKey:info.saveKey];
                }
            }
        }
        
        /// 右边的选择图片
        if (info.type == HLInputCellTypeRightImage) {
            selectImage = [(HLRightImageTypeInfo *)info selectImage];
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && !selectImage) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
        }
        
        /// 额外的判断
        if ([info.leftTip containsString:@"原价"]) { orinalInfo = info; }
        if ([info.leftTip containsString:@"售价"]) { saleInfo = info; }
        if ([info.leftTip containsString:@"购买条件"]) { conditionInfo = info; }
        if ([info.leftTip containsString:@"购买总数量"]) { sumNumInfo = info; }
        if ([info.leftTip containsString:@"每人限购"]) { limitInfo = info; }
    }
    
    if (orinalInfo.text.doubleValue == 0) {
        HLShowHint(@"原价必须大于0", self.view);
        return;
    }
    
    if (orinalInfo.text.doubleValue <= saleInfo.text.doubleValue) {
        HLShowHint(@"售价必须低于原价", self.view);
        return;
    }
    
    if (conditionInfo.text.length && conditionInfo.text.doubleValue == 0) {
        HLShowHint(@"购买条件必须大于0", self.view);
        return;
    }
    
    // 额外增加的判断
    if (sumNumInfo.text.length > 0 && sumNumInfo.text.integerValue == 0) {
        HLShowHint(@"购买总数量不能输入0", self.view);
        return;
    }
    
    if (limitInfo.text.length > 0 && limitInfo.text.integerValue == 0) {
        HLShowHint(@"限购数量不能输入0", self.view);
        return;
    }
    
    // 额外增加的判断
    if ((sumNumInfo.text.length > 0 && limitInfo.text.length > 0) && sumNumInfo.text.integerValue < limitInfo.text.integerValue) {
        HLShowHint(@"购买总数量必须大于限购数量", self.view);
        return;
    }
    
    // 这一步验证，跳转到下一步时，提交参数
    HLBuyGoodPostController *post = [[HLBuyGoodPostController alloc] init];
    post.mParams = mParams;
    post.selectImage = selectImage;
    post.dataSource = [self.dataSource copy];
    [self.navigationController pushViewController:post animated:YES];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(110));
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault: {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } break;
        case HLInputCellTypeRightImage: {
            HLRightImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightImageViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } break;
        case HLInputCellTypeDate: {
            HLInputDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputDateViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 选择日期
    if (indexPath.row == self.dataSource.count - 1) {
        HLInputDateInfo *dateInfo = self.dataSource[indexPath.row];
        if (!dateInfo.enabled) { return; }
        HLCalendarViewController *overView = [[HLCalendarViewController alloc] initWithCallBack:^(NSDate *start, NSDate *end) {
            dateInfo.text = [NSString stringWithFormat:@"%@ 至 %@", [HLTools formatterWithDate:start formate:@"yyyy.MM.dd"], [HLTools formatterWithDate:end formate:@"yyyy.MM.dd"]];
            dateInfo.mParams = @{
                                 @"buyStateTime": [HLTools formatterWithDate:start formate:@"yyyy-MM-dd"],
                                 @"buyEndTime": [HLTools formatterWithDate:end formate:@"yyyy-MM-dd"]
                                 };
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self presentViewController:overView animated:false completion:nil];
        return;
    }
    
    if (indexPath.row == 0) {
        
        HLRightImageTypeInfo *imageInfo = self.dataSource[indexPath.row];
        if (!imageInfo.enabled) { return; }
        
        HLImagePickerController *imagePicker = [[HLImagePickerController alloc] initWithNeedResize:YES maxSelectNum:1 singleSelect:YES mustResize:YES selectOrinal:NO resizeWHScale:self.mainScale pickerBlock:^(NSArray * _Nonnull images) {
            HLRightImageTypeInfo *imageInfo = self.dataSource[indexPath.row];
            imageInfo.selectImage = images.firstObject;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
        return;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLRightImageViewCell class] forCellReuseIdentifier:@"HLRightImageViewCell"];
        [_tableView registerClass:[HLInputDateViewCell class] forCellReuseIdentifier:@"HLInputDateViewCell"];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        
        HLRightImageTypeInfo *goodImgInfo = [[HLRightImageTypeInfo alloc] init];
        goodImgInfo.leftTip = @"*商品图片";
        goodImgInfo.needCheckParams = YES;
        goodImgInfo.saveKey = @"goodsPic";
        goodImgInfo.type = HLInputCellTypeRightImage;
        goodImgInfo.cellHeight = FitPTScreen(104);
        goodImgInfo.errorHint = @"请选择商品图片";
        goodImgInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        HLRightInputTypeInfo *goodNameInfo = [[HLRightInputTypeInfo alloc] init];
        goodNameInfo.leftTip = @"*商品名称";
        goodNameInfo.placeHoder = @"请输入增值商品名称";
        goodNameInfo.cellHeight = FitPTScreen(53);
        goodNameInfo.canInput = YES;
        goodNameInfo.saveKey = @"goodsName";
        goodNameInfo.errorHint = @"请输入增值商品名称";
        goodNameInfo.needCheckParams = YES;
        goodNameInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        HLRightInputTypeInfo *orinalPriceInfo = [[HLRightInputTypeInfo alloc] init];
        orinalPriceInfo.leftTip = @"*原价";
        orinalPriceInfo.placeHoder = @"¥商品原价";
        orinalPriceInfo.needCheckParams = YES;
        orinalPriceInfo.cellHeight = FitPTScreen(53);
        orinalPriceInfo.canInput = YES;
        orinalPriceInfo.saveKey = @"costPrice";
        orinalPriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        orinalPriceInfo.errorHint = @"请输入商品原价";
        orinalPriceInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        HLRightInputTypeInfo *salePriceInfo = [[HLRightInputTypeInfo alloc] init];
        salePriceInfo.leftTip = @"*售价";
        salePriceInfo.placeHoder = @"¥商品售价，可填0为免费赠送";
        salePriceInfo.cellHeight = FitPTScreen(53);
        salePriceInfo.canInput = YES;
        salePriceInfo.saveKey = @"price";
        salePriceInfo.canInputZero = YES;
        salePriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        salePriceInfo.errorHint = @"请输入商品售价";
        salePriceInfo.needCheckParams = YES;
        salePriceInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        HLRightInputTypeInfo *conditionInfo = [[HLRightInputTypeInfo alloc] init];
        conditionInfo.leftTip = @"购买条件";
        conditionInfo.placeHoder = @"¥消费满多少元";
        conditionInfo.cellHeight = FitPTScreen(53);
        conditionInfo.canInput = YES;
        conditionInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        conditionInfo.saveKey = @"buyWhere";
        conditionInfo.needCheckParams = NO;
        conditionInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        HLRightInputTypeInfo *sumNumInfo = [[HLRightInputTypeInfo alloc] init];
        sumNumInfo.leftTip = @"购买总数量";
        sumNumInfo.placeHoder = @"购买总数量卖完为止，可不填";
        sumNumInfo.rightText = @"份";
        sumNumInfo.cellHeight = FitPTScreen(53);
        sumNumInfo.canInput = YES;
        sumNumInfo.saveKey = @"buySum";
        sumNumInfo.needCheckParams = NO;
        sumNumInfo.keyBoardType = UIKeyboardTypeNumberPad;
        sumNumInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        HLRightInputTypeInfo *buyNumInfo = [[HLRightInputTypeInfo alloc] init];
        buyNumInfo.leftTip = @"每人限购";
        buyNumInfo.placeHoder = @"每人限购几份，可不填";
        buyNumInfo.cellHeight = FitPTScreen(53);
        buyNumInfo.canInput = YES;
        buyNumInfo.saveKey = @"buyLimitSum";
        buyNumInfo.rightText = @"份";
        buyNumInfo.needCheckParams = NO;
        buyNumInfo.keyBoardType = UIKeyboardTypeNumberPad;
        buyNumInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        HLRightInputTypeInfo *acceptTypeInfo = [[HLRightInputTypeInfo alloc] init];
        acceptTypeInfo.leftTip = @"领取方式";
        acceptTypeInfo.placeHoder = @"请输入领取方式";
        acceptTypeInfo.cellHeight = FitPTScreen(53);
        acceptTypeInfo.canInput = NO;
        acceptTypeInfo.saveKey = @"pickup";
        acceptTypeInfo.mParams = @{ @"pickup": @"0" };
        acceptTypeInfo.text = @"现场领取";
        acceptTypeInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        HLInputDateInfo *dateInfo = [[HLInputDateInfo alloc] init];
        dateInfo.leftTip = @"*限购日期";
        dateInfo.placeHoder = @"请选择限购日期";
        dateInfo.errorHint = @"请选择限购日期";
        dateInfo.dateType = 0;
        dateInfo.needCheckParams = YES;
        dateInfo.cellHeight = FitPTScreen(76);
        dateInfo.type = HLInputCellTypeDate;
        dateInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
        
        _dataSource = @[goodImgInfo, goodNameInfo, orinalPriceInfo, salePriceInfo, conditionInfo, sumNumInfo, buyNumInfo, acceptTypeInfo, dateInfo];
    }
    return _dataSource;
}

@end
