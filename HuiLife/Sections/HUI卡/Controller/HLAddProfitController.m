//
//  HLAddProfitController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/24.
//

#import "HLAddProfitController.h"
#import "HLProfitFooterView.h"
#import "HLProfitGoodInfo.h"
#import "HLSellTimeSelectView.h"
#import "HLHUIProfitInfo.h"
#import "HLImageSinglePickerController.h"
#import "HLImageUpTool.h"
#import "HLBaseUploadModel.h"
#import "HLCalendarViewController.h"

@interface HLAddProfitController ()<UITableViewDelegate, UITableViewDataSource, HLProfitOrderViewDelegate, HLInputImagesViewCellDelegate,HLInputDateViewCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
//头部 显示的 选择的 权益名称
@property(nonatomic, strong) UILabel *typeLb;
//选择按钮
@property(nonatomic, strong) UIButton *selectBtn;
//首单折扣显示 视图
@property(nonatomic, strong) HLProfitDiscountView *discountFooter;
//订单折扣显示 视图
@property(nonatomic, strong) HLProfitOrderView *orderFooter;
//主model
@property(nonatomic, strong) HLHUIProfitInfo *mainInfo;
//服务器返回 权益类型
@property(nonatomic, strong) NSArray *profitTypes;
//下拉框显示的 权益名称
@property(nonatomic, strong) NSMutableArray *profitNames;
//服务器 返回折扣
@property(nonatomic, strong) NSMutableArray *discounts;
//选择的权益 索引
@property(nonatomic, assign) NSInteger profitIndex;
//图片上传的工具
@property(nonatomic, strong) HLImageUpTool *imageUpTool;
//选择的图片
@property(nonatomic,strong) HLBaseUploadModel *singleImgModel;
//添加 1，2，3 默认值
@property(nonatomic, copy) NSString *firstFist;//首单折扣
@property(nonatomic, copy) NSString *normalFist;//日常折扣
@property(nonatomic, strong) NSMutableArray *orderDiscounts;//外卖折扣

@property(nonatomic, assign) NSInteger firstIndex; //首次选择首单折扣，默认值位置
@property(nonatomic, assign) NSInteger normalIndex;//首次选择日常折扣，默认值位置
//@property(nonatomic, assign) BOOL firstSelect; //是否第一次选择 首单
//@property(nonatomic, assign) BOOL normalSelect;//是否第一次选择 日常
@end

@implementation HLAddProfitController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"添加卡权益"];
    [self hl_setBackImage:@"back_black"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.editProfitInfo) {
        [self initSubView];
        _selectBtn.userInteractionEnabled = NO;
        _typeLb.text = _editProfitInfo.gainTypeName;
        self.mainInfo.editProfitInfo = _editProfitInfo;
        [self configFooterView];
        [self.tableView reloadData];
        return;
    }
    
    [self loadDefaultData];
}

#pragma mark - Request
- (void)loadProfitTypes {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/GainEnum.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self handleProfitTypes:result.data[@"gainTypes"]];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleProfitTypes:(NSArray *)typs {
    _profitTypes = typs;
    for (NSDictionary *dict in typs) {
        [self.profitNames addObject:dict[@"typeName"]];
    }
    NSDictionary *defaultType = _profitTypes.firstObject;
    self.mainInfo.type = [defaultType[@"typeValue"] integerValue];
    _typeLb.text = defaultType[@"typeName"];
    
    [self configFooterView];
    [self.tableView reloadData];
}

//加载折扣
- (void)loadDiscount {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HuiCardSpreadSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"type":@"1"};
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleDiscount:result.data];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDiscount:(NSDictionary *)dict {
    NSArray *discounts = dict[@"discount"];
    NSString *tip = dict[@"unit"];
    for (NSString *discount in discounts) {
        NSString *discountStr = [NSString stringWithFormat:@"%@%@",discount,tip];
        if (!discount.floatValue) discountStr = @"无折扣";
        [self.discounts addObject:discountStr];
    }
    self.tableView.tableFooterView = self.discountFooter;
    self.discountFooter.discounts = self.discounts;
    if (_editProfitInfo) {
        HLProfitFirstInfo *info = (HLProfitFirstInfo *)_editProfitInfo;
        [self.discountFooter configDefaultDiscountStr:[NSString stringWithFormat:@"%@折",info.disFirst]];
    } else {
        NSString *disStr = self.mainInfo.type ==1?[NSString stringWithFormat:@"%@折",_firstFist]:[NSString stringWithFormat:@"%@折",_normalFist];
        [self.discountFooter configDefaultDiscountStr:disStr];
    }
    
}

//添加时的1，2，3的默认值
- (void)loadDefaultData {
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HuiCardSpreadSetInfo.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    }onSuccess:^(id responseObject) {
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray *contents = result.data[@"setContent"];
            NSDictionary *first = contents.firstObject;
            NSDictionary *normal = contents[1];
            _firstFist = [NSString stringWithFormat:@"%@",first[@"set"]];
            _normalFist = [NSString stringWithFormat:@"%@",normal[@"set"]];
        }
        [self loadProfitTypes];
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

//请求外卖折扣的默认值
- (void)loadOrderDefault {
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/TakeAwayDiscountSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
        request.httpMethod = kXMHTTPMethodPOST;
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200){
            NSArray *datas = result.data[@"discount_set"];
            self.orderDiscounts = [NSMutableArray array];
            for (NSDictionary *dict in datas) {
                HLProfitOrderInfo *info = [[HLProfitOrderInfo alloc]init];
                info.priceStart = [NSString stringWithFormat:@"%@",dict[@"start_price"]];
                info.priceEnd = [NSString stringWithFormat:@"%@",dict[@"end_price"]];
                info.discount = [NSString stringWithFormat:@"%@",dict[@"discount"]];
                [self.orderDiscounts addObject:info];
            }
            self.orderFooter.orderDiscounts = self.orderDiscounts;
            self.tableView.tableFooterView = self.orderFooter;
            self.orderFooter.backgroundColor = UIColor.whiteColor;
            [self cacluateOrderFooterFrame:self.orderDiscounts.count];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - Event
//确定添加
- (void)addClick {
    if (!_editProfitInfo) { //添加
        HLProfitGoodInfo *goodInfo = [self createAddProfitGoodInfo];
        if (!goodInfo) return;
        
        for (NSNumber *type in self.addProfitTypes) {
            if (goodInfo.gainType == type.integerValue) {
                [HLTools showWithText:@"该类型不能重复添加"];
                return;
            }
        }
        if (self.saveProfitBlock) self.saveProfitBlock(goodInfo);
        [self hl_goback];
        return;
    }
    BOOL success = [self configEditProfitGoodInfo];
    if (!success) return;
    if (self.saveProfitBlock) self.saveProfitBlock(self.editProfitInfo);
    [self hl_goback];
}


- (void)selectClick:(UIButton *)sender {
    weakify(self);
    [HLSellTimeSelectView showWithTitles:self.profitNames selectIndex:_profitIndex height:FitPTScreen(280) dependView:sender completion:^(NSInteger index){
        NSDictionary *dict = weak_self.profitTypes[index];
        weak_self.mainInfo.type = [dict[@"typeValue"] integerValue];
        NSString *title = weak_self.profitNames[index];
        weak_self.typeLb.text = title;
        weak_self.profitIndex = index;
        [weak_self configFooterView];
        [weak_self.tableView reloadData];
    }];
}

#pragma mark - Method
- (void)configFooterView {
    if (self.mainInfo.type == 1 || self.mainInfo.type == 3) {
        //先请求折扣
        if (!self.discounts.count) [self loadDiscount];
        
        if (!_editProfitInfo) {
            NSString *disStr = self.mainInfo.type ==1?[NSString stringWithFormat:@"%@折",_firstFist]:[NSString stringWithFormat:@"%@折",_normalFist];
            [self.discountFooter configDefaultDiscountStr:disStr];
        }
        self.tableView.tableFooterView = self.discountFooter;
        self.discountFooter.backgroundColor = UIColor.whiteColor;
        return;
    }
    
    if (self.mainInfo.type == 2) {
        //订单折扣
        if (_editProfitInfo) { //获取到所有订单折扣
            HLProfitYMInfo *info = (HLProfitYMInfo *)_editProfitInfo;
            self.orderFooter.orderDiscounts = info.disOut;
            [self cacluateOrderFooterFrame:info.disOut.count];
            self.tableView.tableFooterView = self.orderFooter;
            self.orderFooter.backgroundColor = UIColor.whiteColor;
        } else { //添加 ，请求默认
            if (!_orderDiscounts) {
                [self loadOrderDefault];
            } else {
                self.tableView.tableFooterView = self.orderFooter;
                self.orderFooter.backgroundColor = UIColor.whiteColor;
            }
        }
        return;
    }
    self.tableView.tableFooterView = [UIView new];
}

- (void)cacluateOrderFooterFrame:(NSInteger)disoutCount {
    CGFloat hight = FitPTScreen(89);
    hight += disoutCount *FitPTScreen(50);
    
    CGRect frame = self.orderFooter.frame;
    frame.size.height = hight;
    self.orderFooter.frame = frame;
    self.tableView.tableFooterView = self.orderFooter;
}

- (HLProfitGoodInfo *)createAddProfitGoodInfo {
    HLProfitGoodInfo *goodInfo;
    if (self.mainInfo.type == 1 || self.mainInfo.type == 3) {
        HLProfitFirstInfo *firstInfo = [[HLProfitFirstInfo alloc]init];
        firstInfo.gainType = self.mainInfo.type;
        firstInfo.disFirst = self.discountFooter.discount;
        goodInfo = firstInfo;
    } else if (self.mainInfo.type == 2) { //外卖折扣
        HLProfitYMInfo *ymInfo = [[HLProfitYMInfo alloc]init];
        ymInfo.gainType = self.mainInfo.type;
        NSMutableArray *disout = [NSMutableArray array];
        //获取除最后一个外的所有 折扣
        if (self.orderFooter.datasource.count > 1) {
            NSArray *subArr = [self.orderFooter.datasource subarrayWithRange:NSMakeRange(0, self.orderFooter.datasource.count-1)];
            [disout addObjectsFromArray:subArr];
        }
        HLProfitOrderInfo *downInfo = self.orderFooter.datasource.lastObject;
        HLProfitOrderInfo *upInfo = disout.lastObject;
        if ((downInfo.priceStart.doubleValue < upInfo.priceEnd.doubleValue) && upInfo) {
            [HLTools showWithText:@"价格区间填写有误"];
            return nil;
        }
        
        if (![downInfo check]) {
            return nil;
        }
        [disout addObject:downInfo];
        ymInfo.disOut = [disout copy];
        goodInfo = ymInfo;
    } else {
        for (HLBaseTypeInfo *info in self.mainInfo.datasource) {
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                [HLTools showWithText:info.errorHint];
                return nil;
            }
        }
        goodInfo = [self.mainInfo createProfitGoodInfo];
    }
    HLLog(@"goodInfo = %@",[goodInfo mj_JSONString]);
    return goodInfo;
}

//重组编辑 模型
- (BOOL)configEditProfitGoodInfo {
    if (self.mainInfo.type == 1 || self.mainInfo.type == 3) {
        HLProfitFirstInfo *firstInfo = (HLProfitFirstInfo *)self.editProfitInfo;
        firstInfo.disFirst = self.discountFooter.discount;
    } else if (self.mainInfo.type == 2) {
        HLProfitYMInfo *ymInfo = (HLProfitYMInfo *)self.editProfitInfo;
        NSMutableArray *disout = [NSMutableArray array];
        //获取除最后一个外的所有 折扣
        if (self.orderFooter.datasource.count > 1) {
            NSArray *subArr = [self.orderFooter.datasource subarrayWithRange:NSMakeRange(0, self.orderFooter.datasource.count-1)];
            [disout addObjectsFromArray:subArr];
        }
        HLProfitOrderInfo *downInfo = self.orderFooter.datasource.lastObject;
        HLProfitOrderInfo *upInfo = disout.lastObject;
        if ((downInfo.priceStart.doubleValue < upInfo.priceEnd.doubleValue) && upInfo) {
            [HLTools showWithText:@"价格区间填写有误"];
            return NO;
        }
        
        if (![downInfo check]) {
            return NO;
        }
        [disout addObject:downInfo];
        ymInfo.disOut = [disout copy];
    } else {
        for (HLBaseTypeInfo *info in self.mainInfo.datasource) {
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                [HLTools showWithText:info.errorHint];
                return NO;
            }
        }
        [self.mainInfo configEditProfitGoodInfo];
    }
    HLLog(@"goodInfo = %@",[_editProfitInfo mj_JSONObject]);
    return YES;
}

#pragma mark - HLProfitOrderViewDelegate
//添加或删除
- (void)orderViewAdd:(BOOL)add allSource:(NSArray *)datasource {
    [self cacluateOrderFooterFrame:datasource.count];
}

#pragma mark - HLInputImagesViewCellDelegate
//添加图片
- (void)imagesCell:(HLInputImagesViewCell *)cell imagesInfo:(HLInputImagesInfo *)info {
    weakify(self);
    HLImageSinglePickerController * picker = [[HLImageSinglePickerController alloc]initWithAllowsEditing:YES callBack:^(UIImage * _Nonnull image) {
        dispatch_main_async_safe(^{
            weak_self.singleImgModel.image = image;
            HLLoading(weak_self.view);
            [weak_self.imageUpTool asyncConcurrentGroupUploadArray:@[weak_self.singleImgModel] uploading:^{
                
            } completion:^{
                HLHideLoading(weak_self.view);
                info.text = weak_self.singleImgModel.imgUrl;
                info.pics = @[weak_self.singleImgModel.imgUrl];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[weak_self.mainInfo.datasource indexOfObject:info] inSection:0];
                [weak_self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        });
    }];
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - HLInputDateViewCellDelegate
//月月赠送开关
- (void)dateCell:(HLInputDateViewCell *)cell switchON:(BOOL)on {
    [self.mainInfo monthGiftOpen:on];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainInfo.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseTypeInfo *info = self.mainInfo.datasource[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault: //默认输入
        {
            HLRightInputViewCell *cell = (HLRightInputViewCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseInfo = info;
            return cell;
            
        }break;
        case HLInputCellTypeUseDesc: //使用说明
        {
            HLInputUseDescViewCell *cell = (HLInputUseDescViewCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLInputUseDescViewCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseInfo = info;
            return cell;
            
        }break;
        case HLInputCellTypeDate: //开关
        {
            HLInputDateViewCell *cell = (HLInputDateViewCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLInputDateViewCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseInfo = info;
            cell.delegate = self;
            return cell;
            
        }break;
        case HLInputCellRightEditNum: //折扣
        {
            HLRightEditNumViewCell *cell = (HLRightEditNumViewCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLRightEditNumViewCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseInfo = info;
            return cell;
            
        }break;
        case HLInputPickImagesType: //图片选择
        {
            HLInputImagesViewCell *cell = (HLInputImagesViewCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLInputImagesViewCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.baseInfo = info;
            return cell;
            
        }break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseTypeInfo *info = self.mainInfo.datasource[indexPath.row];
    return info.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLBaseTypeInfo *info = self.mainInfo.datasource[indexPath.row];
    if ([info.leftTip isEqualToString:@"* 使用有效期"]) {
        HLCalendarViewController * calender = [[HLCalendarViewController alloc]initWithCallBack:^(NSDate *start, NSDate *end) {
            NSString * startStr = [HLTools formatterWithDate:start formate:@"yyyy.MM.dd"];
            NSString * endStr = [HLTools formatterWithDate:end formate:@"yyyy.MM.dd"];
            HLInputDateInfo * dateInfo = (HLInputDateInfo *)info;
            dateInfo.text = [NSString stringWithFormat:@"%@ - %@",startStr,endStr];
            if (start && end) {
                dateInfo.mParams =  @{@"startDate":startStr,@"endDate":endStr};
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController presentViewController:calender animated:false completion:nil];
    }
}
#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    
    CGFloat bottomHight = FitPTScreen(90);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - bottomHight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    UIView *tableHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(62))];
    tableHead.backgroundColor = UIColorFromRGB(0xf5f6f9);
    _tableView.tableHeaderView = tableHead;
    
    UIView *bagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(53))];
    bagView.backgroundColor = UIColor.whiteColor;
    [tableHead addSubview:bagView];
    
    UILabel *titleLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    titleLb.text = @"权益类型";
    [bagView addSubview:titleLb];
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(bagView);
    }];
    
    UIButton *selectBtn = [[UIButton alloc]init];
    selectBtn.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    selectBtn.layer.borderWidth = 0.5;
    selectBtn.layer.cornerRadius = FitPTScreen(2);
    [bagView addSubview:selectBtn];
    [selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(bagView);
        make.size.equalTo(CGSizeMake(FitPTScreen(170), FitPTScreen(35)));
    }];
    _selectBtn = selectBtn;
    
    _typeLb = [UILabel hl_regularWithColor:@"#343434" font:14];
    _typeLb.text = @"首单折扣";
    [selectBtn addSubview:_typeLb];
    [_typeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(18));
        make.centerY.equalTo(selectBtn);
        make.size.equalTo(CGSizeMake(FitPTScreen(100), FitPTScreen(30)));
    }];
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_tip_down"]];
    [selectBtn addSubview:arrow];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-14));
        make.centerY.equalTo(selectBtn);
    }];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), ScreenW, bottomHight)];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    [self.view addSubview:bottomView];
    UIButton *addBtn = [[UIButton alloc] init];
    [bottomView addSubview:addBtn];
    [addBtn setTitle:_editProfitInfo?@"确定修改":@"确定添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"button_bag"] forState:UIControlStateNormal];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(FitPTScreen(-40));
    }];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (HLProfitDiscountView *)discountFooter {
    if (!_discountFooter) {
        _discountFooter = [[HLProfitDiscountView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(270))];
    }
    return _discountFooter;
}

- (HLProfitOrderView *)orderFooter {
    if (!_orderFooter) {
        _orderFooter = [[HLProfitOrderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(139))];
        _orderFooter.backgroundColor = UIColor.whiteColor;
        _orderFooter.delegate = self;
    }
    return _orderFooter;
}

- (HLHUIProfitInfo *)mainInfo {
    if (!_mainInfo) {
        _mainInfo = [[HLHUIProfitInfo alloc]init];
    }
    return _mainInfo;
}

- (NSMutableArray *)profitNames {
    if (!_profitNames) {
        _profitNames = [NSMutableArray array];
    }
    return _profitNames;
}

- (NSMutableArray *)discounts {
    if (!_discounts) {
        _discounts = [NSMutableArray array];
    }
    return _discounts;
}

- (HLImageUpTool *)imageUpTool {
    if (!_imageUpTool) {
        _imageUpTool = [[HLImageUpTool alloc]init];
    }
    return _imageUpTool;
}

- (HLBaseUploadModel *)singleImgModel {
    if (!_singleImgModel) {
        _singleImgModel = [[HLBaseUploadModel alloc]init];
        _singleImgModel.saveName = @"ul";
        _singleImgModel.postParams = @{@"type" : @"1"};
        _singleImgModel.uploadedImgUrlKey = @"imgPath";
        _singleImgModel.requestApi = @"/MerchantSide/UploadImage.php?dev=1";
    }
    return _singleImgModel;
}

@end
