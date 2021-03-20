//
//  HLVoucherMarketAddController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import "HLVoucherMarketAddController.h"
#import "HLRightInputViewCell.h"
#import "HLRightImageViewCell.h"
#import "HLVoucherMarketAddHead.h"
#import "HLImageSinglePickerController.h"
#import "HLVoucherMarketEditInfo.h"
#import "HLSelectArea.h"
#import "HLVoucherAddRangeCell.h"
#import "HLTimeSingleSelectView.h"
#import "HLDownSelectView.h"
#import "HLAreaSelectView.h"
#import "HLVoucherAddTwoImageCell.h"
#import "HLVoucherBankQueryController.h"

@interface HLVoucherMarketAddController () <UITableViewDelegate,UITableViewDataSource,HLVoucherAddRangeCellDelegate,HLVoucherAddTwoImageCellDelegate,HLRightInputViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HLVoucherMarketAddHead *tableHead;

@property (nonatomic, copy) NSArray *dataSource;

/// 缓存的地区数据
@property (nonatomic, copy) NSArray *cacheAreaArr;

/// 银行筛选页面，这个页面持有，用于页面保持
@property (nonatomic, strong) HLVoucherBankQueryController *bankQuery;

/// 审核失败的情况下，头部展示错误原因
@property (nonatomic, strong) UIView *topErrorView;

@end

@implementation HLVoucherMarketAddController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [self needLoadData] ? @"修改信息" : @"生成买单牌";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    // 判断如果需要拉取数据，说明已经填写过数据了
    if ([self needLoadData]) {
        [self loadPageData];
    }else{
        [self creatTableHeadViewWithState:0];
        [self creatFootViewWithButtonTitle:@"下一步 提交待审核"];
    }
}

/// 需要加载数据
- (BOOL)needLoadData{
    return self.state.integerValue > 0;
}


#pragma mark - HLRightInputViewCellDelegate
//
- (void)inputViewCell:(HLRightInputViewCell *)cell rightImgClick:(HLRightInputTypeInfo *)inputInfo {
    [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:@"便于收款成功，需二次验证微信号" buttonTitles:@[@"知道了"] buttonColors:@[UIColorFromRGB(0xFF7213)] callBack:^(NSInteger index) {
        
    }];
}

/// 未提交审核状态下，请求费率，目前不用了
//- (void)loadRateData{
//    HLLoading(self.view);
//    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
//        request.api = @"/Shopplus/Agentserver/rate";
//        request.serverType = HLServerTypeStoreService;
//        request.parameters = @{};
//    } onSuccess:^(XMResult *  _Nullable responseObject) {
//        HLHideLoading(self.view);
//
//        if ([(XMResult *)responseObject checkIsTokenExpire]) {
//            [HLTools shwoMutableDeviceLogin:^{
//                [self loadRateData];
//            }];
//            return ;
//        }
//
//        if ([responseObject code] == 200) {
//            // 设置费率数据
//            HLRightInputTypeInfo *rateInfo = self.dataSource.lastObject;
//            rateInfo.text = responseObject.data[@"rate"];
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        }
//    } onFailure:^(NSError * _Nullable error) {
//        HLHideLoading(self.view);
//    }];
//}

/// 保存信息
- (void)saveButtonClick{
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    
    for (HLBaseTypeInfo *info in self.dataSource) {
        
        // 默认的右边输入
        if(info.type == HLInputCellTypeDefault || info.type == HLInputCellTypeVoucherRange){
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            // 参数验证通过，先判断 mParams ，再去设置text
            if(info.mParams.count > 0){
                [mParams setValuesForKeysWithDictionary:info.mParams];
            }else{
                [mParams setValue:info.text forKey:info.saveKey];
            }
            continue;
        }
        
        /// 右边的选择图片
        if (info.type == HLInputCellTypeRightImage){
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            [mParams setValue:[(HLRightImageTypeInfo *)info imageUrl]?:@"" forKey:info.saveKey];
            continue;
        }
        
        /// 选择两个图片
        if (info.type == HLInputCellTypeTwoImage){
            // 如果必须要验证参数，那么就判断参数
            if (info.needCheckParams && ![info checkParamsIsOk]) {
                HLShowHint(info.errorHint, self.view);
                return;
            }
            [mParams setValue:[(HLVoucherTwoImageInfo *)info leftImageUrl]?:@"" forKey:@"certCorrect"];
            [mParams setValue:[(HLVoucherTwoImageInfo *)info leftImageUrl]?:@"" forKey:@"certOpposite"];
            continue;
        }
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Agentserver/register";
        request.serverType = HLServerTypeStoreService;
        request.parameters = mParams;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            HLShowText(@"提交成功");
            if(self.addBlock){
                self.addBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 加载数据
- (void)loadPageData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Agentserver/tenantInfo";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            HLVoucherMarketEditInfo *editInfo = [HLVoucherMarketEditInfo mj_objectWithKeyValues:responseObject.data];
            [self handleMarketEditInfo:editInfo];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 处理数据
- (void)handleMarketEditInfo:(HLVoucherMarketEditInfo *)editInfo{
    
    NSInteger state = self.state.integerValue;
    
    // 如果正在审核中，那么显示头部，不显示底部
    if (state == 1) {
        [self creatTableHeadViewWithState:1];
    }
    
    if (state == 2) {
        [self creatFootViewWithButtonTitle:@"提交 再次审核"];
        // 审核失败，头部展示错误信息
        [self showTopErrorView:editInfo.resMsg];
    }
    
    // 审核状态中 或者 通过审核，就不可以再修改
    BOOL enable = state != 3 && state != 1;
    
    for (HLBaseTypeInfo *info in self.dataSource) {
        info.enabled = enable;
    }
    
    // 填充数据
    HLRightInputTypeInfo *companyInfo = self.dataSource[0];
    companyInfo.text = editInfo.mchntName;
    
    HLRightInputTypeInfo *addressInfo = self.dataSource[1];
    addressInfo.text = [editInfo.contactAddr stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    addressInfo.mParams = @{
                            @"province":editInfo.province,
                            @"city":editInfo.city,
                            @"district":editInfo.district,
                            @"contactAddr":editInfo.contactAddr
                            };
    
    HLRightInputTypeInfo *addressDetailInfo = self.dataSource[2];
    addressDetailInfo.text = editInfo.address;
    
    // 这里上传的是url
    HLRightImageTypeInfo *menTouImgInfo = self.dataSource[3];
    menTouImgInfo.imageUrl = editInfo.shopHeader;
    
    // 这里上传的是url
    HLRightImageTypeInfo *menLianImgInfo = self.dataSource[4];
    menLianImgInfo.imageUrl = editInfo.shopFront;
    
    HLRightInputTypeInfo *lianHangInfo = self.dataSource[5];
    lianHangInfo.text = editInfo.pmsBankName;
    lianHangInfo.mParams = @{lianHangInfo.saveKey : editInfo.pmsBankNo};
    
    HLRightInputTypeInfo *mobilePhoneInfo = self.dataSource[6];
    mobilePhoneInfo.text = editInfo.mobile;
    
    HLRightInputTypeInfo *bankNumInfo = self.dataSource[7];
    bankNumInfo.text = editInfo.cardNo;
    
    HLRightInputTypeInfo *personInfo = self.dataSource[8];
    personInfo.text = editInfo.realName;
    
    HLRightInputTypeInfo *idCardInfo = self.dataSource[9];
    idCardInfo.text = editInfo.certNo;
    
    HLRightInputTypeInfo *startTime = self.dataSource[10];
    startTime.text = editInfo.cardStartDt;
    
    HLRightInputTypeInfo *invaidTime = self.dataSource[11];
    invaidTime.text = editInfo.licenseExpireDt;
    
    // 手持证件照
    HLRightImageTypeInfo *handCardInfo = self.dataSource[12];
    handCardInfo.imageUrl = editInfo.certMeet?:@"";
    
    // 银行卡
    HLRightImageTypeInfo *bankCardInfo = self.dataSource[13];
    bankCardInfo.imageUrl = editInfo.cardCorrect?:@"";

    HLVoucherTwoImageInfo *twoImageInfo = self.dataSource[14];
    twoImageInfo.leftImageUrl = editInfo.certCorrect?:@"";
    twoImageInfo.rightImageUrl = editInfo.certOpposite?:@"";

    HLRightInputTypeInfo *telInfo = self.dataSource[15];
    telInfo.text = editInfo.account;
    
//    weixinNum
    HLRightInputTypeInfo *WechatInfo = self.dataSource[16];
    WechatInfo.text = editInfo.weixinNum;
    
    HLVoucherAddRangeSubInfo *secondSubInfo = [[HLVoucherAddRangeSubInfo alloc] init];
    secondSubInfo.manage_name = editInfo.twoClassName;
    secondSubInfo.manage_id = editInfo.twoClassId;
    secondSubInfo.manage_code = @"";
    
    HLVoucherAddRangeSubInfo *thirdSubInfo = [[HLVoucherAddRangeSubInfo alloc] init];
    thirdSubInfo.manage_name = editInfo.threeClassName;
    thirdSubInfo.manage_id = editInfo.threeClassId;
    thirdSubInfo.manage_code = editInfo.business;
    
    // 构建参数
    HLVoucherAddRangeInfo *rangInfo = self.dataSource[17];
    rangInfo.secondSubInfo = secondSubInfo;
    rangInfo.thirdSubInfo = thirdSubInfo;
    [rangInfo buildRangParams];
    
    [self.tableView reloadData];
}

/// 构建顶部的view
- (void)creatTableHeadViewWithState:(NSInteger)state{
    _tableHead = [[HLVoucherMarketAddHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(134))];
    [_tableHead configState:state];
    self.tableView.tableHeaderView = _tableHead;
}

/// 展示头部错误信息
- (void)showTopErrorView:(NSString *)errorMsg{
    
    if (errorMsg.length == 0) {
        return;
    }
    
    self.topErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(35))];
    [self.view addSubview:self.topErrorView];
    self.topErrorView.backgroundColor = UIColorFromRGB(0xFFF4D9);
    
    UIImageView *errorTipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waring_red"]];
    [self.topErrorView addSubview:errorTipImgV];
    [errorTipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.centerY.equalTo(self.topErrorView);
        make.width.height.equalTo(FitPTScreen(11));
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [self.topErrorView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"error_red_light"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hideTopErrorView) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-0));
        make.top.bottom.equalTo(0);
        make.width.equalTo(FitPTScreen(35));
    }];
    
    UILabel *errorLab = [[UILabel alloc] init];
    [self.topErrorView addSubview:errorLab];
    errorLab.text = errorMsg;
    errorLab.numberOfLines = 2;
    errorLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    errorLab.textColor = UIColorFromRGB(0xFF8168);
    [errorLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(errorTipImgV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.topErrorView);
        make.right.lessThanOrEqualTo(closeBtn.left).offset(FitPTScreen(-5));
    }];
    
    CGRect frame = self.tableView.frame;
    frame = CGRectMake(0, CGRectGetMaxY(self.topErrorView.frame), ScreenW, frame.size.height - CGRectGetHeight(self.topErrorView.frame));
    self.tableView.frame = frame;
}

/// 隐藏头部错误信息
- (void)hideTopErrorView{
    CGRect frame = self.tableView.frame;
    frame = CGRectMake(0, Height_NavBar, ScreenW, frame.size.height + CGRectGetHeight(self.topErrorView.frame));
    self.tableView.frame = frame;
    [self.topErrorView removeFromSuperview];
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

/// 加载地区的数据
- (void)loadAreaDataWithCallBack:(void(^)(NSArray *areaArr))callBack{
    if (self.cacheAreaArr.count) {
        callBack(self.cacheAreaArr);
        return;
    }
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSideA/UserAddressCity.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            self.cacheAreaArr = responseObject.data;
            callBack(self.cacheAreaArr);
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - HLVoucherAddRangeCellDelegate

/// 经营分类二级
-(void)rangeCell:(HLBaseInputViewCell *)cell secondDependView:(UIView *)view{
    // 如果此时不y能编辑，就return
    HLVoucherAddRangeInfo *info = (HLVoucherAddRangeInfo *)cell.baseInfo;
    if(!info.enabled)return;
    
    [self fetchSecondDataWithRangeInfo:info callBack:^(NSArray *array) {
        [HLDownSelectView showSelectViewWithTitles:info.secondTitleArr currentTitle:info.secondSubInfo.manage_name needShowSelect:YES showSeperator:YES itemHeight:FitPTScreen(36) dependView:view showType:HLDownSelectTypeAuto maxNum:6 hideCallBack:nil callBack:^(NSInteger index) {
            // 如果之前有，并且和之前的相等，不会把二级三级置为空
            if(![info secondSubInfoEqualTo:info.secondArr[index]]){
                [info cleanThridData];
            }
            info.secondSubInfo = info.secondArr[index];
            [info buildRangParams];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}

/// 拉取二级分类的数据
- (void)fetchSecondDataWithRangeInfo:(HLVoucherAddRangeInfo *)rangeInfo callBack:(void(^)(NSArray *array))callBack{
    if (rangeInfo.secondArr.count > 0) {
        callBack(rangeInfo.secondArr);
        return;
    }

    // 拉取二级类目
    [self loadRangeDataWithManageId:@"" type:@"2" callBack:^(NSArray *array) {
        rangeInfo.secondArr = array;
        callBack(rangeInfo.secondArr);
    }];
}

/// 经营分类三级
-(void)rangeCell:(HLBaseInputViewCell *)cell thirdDependView:(UIView *)view{
    // 如果此时不y能编辑，就return
    HLVoucherAddRangeInfo *info = (HLVoucherAddRangeInfo *)cell.baseInfo;
    if(!info.enabled)return;    // 如果二级分类没有选择，则提示
    if (!info.secondSubInfo) {
        HLShowHint(@"请选择一级分类", self.view);
        return;
    }
    [self fetchThirdDataWithRangeInfo:info callBack:^(NSArray *array) {
        [HLDownSelectView showSelectViewWithTitles:info.thirdTitleArr currentTitle:info.thirdSubInfo.manage_name needShowSelect:YES showSeperator:YES itemHeight:FitPTScreen(36) dependView:view showType:HLDownSelectTypeAuto maxNum:6 hideCallBack:nil callBack:^(NSInteger index) {
            info.thirdSubInfo = info.thirdArr[index];
            [info buildRangParams];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}

/// 拉取三级分类的数据
- (void)fetchThirdDataWithRangeInfo:(HLVoucherAddRangeInfo *)rangeInfo callBack:(void(^)(NSArray *array))callBack{
    if (rangeInfo.thirdArr.count > 0) {
        callBack(rangeInfo.thirdArr);
        return;
    }
    // 拉取三级类目
    [self loadRangeDataWithManageId:rangeInfo.secondSubInfo.manage_id type:@"3" callBack:^(NSArray *array) {
        rangeInfo.thirdArr = array;
        callBack(rangeInfo.thirdArr);
    }];
}

/// 拉取数据
- (void)loadRangeDataWithManageId:(NSString *)manageId type:(NSString *)type callBack:(void(^)(NSArray *array))callBack{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Agentserver/manageRange";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"manageId":manageId,@"type":type};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            NSArray *itemArr = [HLVoucherAddRangeSubInfo mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
            if (callBack) {
                callBack(itemArr);
            }
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - HLVoucherAddTwoImageCellDelegate

/// 点击选择两张照片
-(void)twoImageCell:(HLVoucherAddTwoImageCell *)cell selectLeftImage:(BOOL)selectLeft{
    HLVoucherTwoImageInfo *imageInfo = (HLVoucherTwoImageInfo *)cell.baseInfo;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!imageInfo.enabled) {return;}
    weakify(self);
    HLImageSinglePickerController *imagePicker = [[HLImageSinglePickerController alloc] initWithAllowsEditing:NO callBack:^(UIImage * _Nonnull image) {
        [weak_self uploadImage:image callBack:^(NSString *imgageUrl) {
            if (selectLeft) {
                imageInfo.leftImageUrl = imgageUrl;
                imageInfo.leftImage = image;
            }else{
                imageInfo.rightImageUrl = imgageUrl;
                imageInfo.rightImage = image;
            }
            [weak_self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
    [self presentViewController:imagePicker animated:YES completion:nil];
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
        case HLInputCellTypeVoucherRange:
        {
            HLVoucherAddRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLVoucherAddRangeCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypeTwoImage:
        {
            HLVoucherAddTwoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLVoucherAddTwoImageCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource[indexPath.row] cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HLBaseTypeInfo *baseInfo = self.dataSource[indexPath.row];
    
    // 图片选择
    if (baseInfo.type == HLInputCellTypeRightImage) {
        HLRightImageTypeInfo *imageInfo = (HLRightImageTypeInfo *)baseInfo;
        if (!imageInfo.enabled) {return;}
        weakify(self);
        HLImageSinglePickerController *imagePicker = [[HLImageSinglePickerController alloc] initWithAllowsEditing:NO callBack:^(UIImage * _Nonnull image) {
            [weak_self uploadImage:image callBack:^(NSString *imgageUrl) {
                imageInfo.imageUrl = imgageUrl;
                imageInfo.selectImage = image;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
        return;
    }
    
    // 选择地址
    if (indexPath.row == 1) {
        HLRightInputTypeInfo *addrssInfo = (HLRightInputTypeInfo *)baseInfo;
        if (!addrssInfo.enabled) {return;}
        [self loadAreaDataWithCallBack:^(NSArray *areaArr) {
            NSString *selectAddress = addrssInfo.text ? [addrssInfo.text stringByReplacingOccurrencesOfString:@" " withString:@"-"] :@"";
            [HLAreaSelectView showCurrentSelectArea:selectAddress areas:areaArr callBack:^(NSString *province, NSString *city, NSString *area, NSString *proId, NSString *cityId, NSString *areaId) {
                addrssInfo.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,area];
                addrssInfo.mParams = @{
                                       @"province":proId,
                                       @"city":cityId,
                                       @"district":areaId,
                                       @"contactAddr":[addrssInfo.text stringByReplacingOccurrencesOfString:@" " withString:@"-"]
                                       };
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
        return;
    }
    
    // 选择时间
    if (indexPath.row == 10 || indexPath.row == 11) {
        HLRightInputTypeInfo *timeInfo = (HLRightInputTypeInfo *)baseInfo;
        if (!timeInfo.enabled) {return;}
        [HLTimeSingleSelectView showEditTimeView:timeInfo.text startWithToday:indexPath.row == 11 callBack:^(NSString * _Nonnull date) {
            timeInfo.text = date;
            [self.tableView reloadData];
        }];
        return;
    }
    
    // 选择银行
    if (indexPath.row == 5) {
        HLRightInputTypeInfo *bankInfo = (HLRightInputTypeInfo *)baseInfo;
        if(!bankInfo.enabled) return;
        if(!_bankQuery){
            _bankQuery = [[HLVoucherBankQueryController alloc] init];
            weakify(self);
            _bankQuery.selectBlock = ^(NSString * _Nonnull bankName, NSString * _Nonnull bankId) {
                bankInfo.mParams = @{bankInfo.saveKey : bankId};
                bankInfo.text = bankName;
                [weak_self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
        [self.navigationController pushViewController:_bankQuery animated:YES];
        return;
    }
    
}

/// 上传图片
- (void)uploadImage:(UIImage *)image callBack:(void(^)(NSString *imgageUrl))callBack{
    HLLoading(self.view);
    // 压缩图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSData *data = [HLTools compressImage:image toByte:200 * 1024];
        dispatch_main_async_safe(^{
            [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
                request.api = @"/Shopplus/Agentserver/upPic";
                request.requestType = kXMRequestUpload;
                request.serverType = HLServerTypeStoreService;
                request.parameters = @{};
                // 后台会生成图片名称
                [request addFormDataWithName:@"pic" fileName:@"data.jpg" mimeType:@"image/jpeg" fileData:data];
            } onSuccess:^(XMResult *  _Nullable responseObject) {
                HLHideLoading(self.view);
                if ([responseObject code] == 200) {
                    NSString *imgUrl = responseObject.data[@"url"];
                    if (callBack) {
                        callBack(imgUrl);
                    }
                }
            } onFailure:^(NSError * _Nullable error) {
                HLHideLoading(self.view);
            }];
        });
    });
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLVoucherAddTwoImageCell class] forCellReuseIdentifier:@"HLVoucherAddTwoImageCell"];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLRightImageViewCell class] forCellReuseIdentifier:@"HLRightImageViewCell"];
        [_tableView registerClass:[HLVoucherAddRangeCell class] forCellReuseIdentifier:@"HLVoucherAddRangeCell"];
    }
    return _tableView;
}


-(NSArray *)dataSource{
    if (!_dataSource) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        HLRightInputTypeInfo *companyInfo = [[HLRightInputTypeInfo alloc] init];
        companyInfo.leftTip = @"*店铺名称";
        companyInfo.placeHoder = @"请输入店铺名称";
        companyInfo.cellHeight = FitPTScreen(53);
        companyInfo.canInput = YES;
        companyInfo.saveKey = @"mchntName";
        companyInfo.errorHint = @"请输入店铺名称";
        companyInfo.needCheckParams = YES;
        [mArr addObject:companyInfo];
        
        // 这个参数较多，所以使用 mParams 包含 contactAddr province city district
        HLRightInputTypeInfo *addressInfo = [[HLRightInputTypeInfo alloc] init];
        addressInfo.leftTip = @"*店铺地址";
        addressInfo.placeHoder = @"请选择所在城市";
        addressInfo.needCheckParams = YES;
        addressInfo.cellHeight = FitPTScreen(53);
        addressInfo.canInput = NO;
        addressInfo.saveKey = @"";
        addressInfo.errorHint = @"请选择所在城市";
        addressInfo.showRightArrow = YES;
        addressInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(250), 0, FitPTScreen(12));
        [mArr addObject:addressInfo];
        
        HLRightInputTypeInfo *addressDetailInfo = [[HLRightInputTypeInfo alloc] init];
        addressDetailInfo.leftTip = @"";
        addressDetailInfo.placeHoder = @"请输入店铺详情地址";
        addressDetailInfo.cellHeight = FitPTScreen(53);
        addressDetailInfo.canInput = YES;
        addressDetailInfo.saveKey = @"address";
        addressDetailInfo.errorHint = @"请输入店铺详情地址";
        addressDetailInfo.needCheckParams = YES;
        [mArr addObject:addressDetailInfo];

        // 这里上传的是url
        HLRightImageTypeInfo *menTouImgInfo = [[HLRightImageTypeInfo alloc] init];
        menTouImgInfo.leftTip = @"*上传门头照";
        menTouImgInfo.needCheckParams = YES;
        menTouImgInfo.saveKey = @"shopHeader";
        menTouImgInfo.type = HLInputCellTypeRightImage;
        menTouImgInfo.cellHeight = FitPTScreen(104);
        menTouImgInfo.errorHint = @"请选择门头照";
        [mArr addObject:menTouImgInfo];
        
        // 这里上传的是url
        HLRightImageTypeInfo *menLianImgInfo = [[HLRightImageTypeInfo alloc] init];
        menLianImgInfo.leftTip = @"*上传店内环境图";
        menLianImgInfo.needCheckParams = YES;
        menLianImgInfo.saveKey = @"shopFront";
        menLianImgInfo.type = HLInputCellTypeRightImage;
        menLianImgInfo.cellHeight = FitPTScreen(104);
        menLianImgInfo.errorHint = @"请上传店内环境图";
        [mArr addObject:menLianImgInfo];
        
        // TODO: 数据提交和回显
        HLRightInputTypeInfo *lianHangInfo = [[HLRightInputTypeInfo alloc] init];
        lianHangInfo.leftTip = @"*开户行";
        lianHangInfo.placeHoder = @"请选择开户行";
        lianHangInfo.needCheckParams = YES;
        lianHangInfo.rightImage = [UIImage imageNamed:@"search_darkGrey"];
        lianHangInfo.cellHeight = FitPTScreen(53);
        lianHangInfo.canInput = NO;
        lianHangInfo.showRightArrow = YES;
        lianHangInfo.saveKey = @"pmsBankNo";
        lianHangInfo.errorHint = @"请选择开户行";
        [mArr addObject:lianHangInfo];
        
        HLRightInputTypeInfo *mobilePhoneInfo = [[HLRightInputTypeInfo alloc] init];
        mobilePhoneInfo.leftTip = @"*开户预留手机号";
        mobilePhoneInfo.placeHoder = @"请输入开户时绑定手机号";
        mobilePhoneInfo.needCheckParams = YES;
        mobilePhoneInfo.cellHeight = FitPTScreen(53);
        mobilePhoneInfo.canInput = YES;
        mobilePhoneInfo.saveKey = @"mobile";
        mobilePhoneInfo.keyBoardType = UIKeyboardTypeNumberPad;
        mobilePhoneInfo.errorHint = @"请输入开户时绑定手机号";
        [mArr addObject:mobilePhoneInfo];
        
        HLRightInputTypeInfo *bankNumInfo = [[HLRightInputTypeInfo alloc] init];
        bankNumInfo.leftTip = @"*银行账户";
        bankNumInfo.placeHoder = @"请输入银行账户";
        bankNumInfo.needCheckParams = YES;
        bankNumInfo.cellHeight = FitPTScreen(53);
        bankNumInfo.canInput = YES;
        bankNumInfo.saveKey = @"cardNo";
        bankNumInfo.keyBoardType = UIKeyboardTypeNumberPad;
        bankNumInfo.errorHint = @"请输入银行账户";
        [mArr addObject:bankNumInfo];
        
        HLRightInputTypeInfo *personInfo = [[HLRightInputTypeInfo alloc] init];
        personInfo.leftTip = @"*开户人";
        personInfo.placeHoder = @"请输入开户人姓名";
        personInfo.needCheckParams = YES;
        personInfo.cellHeight = FitPTScreen(53);
        personInfo.canInput = YES;
        personInfo.saveKey = @"realName";
        personInfo.errorHint = @"请输入开户人姓名";
        [mArr addObject:personInfo];
        
        HLRightInputTypeInfo *idCardInfo = [[HLRightInputTypeInfo alloc] init];
        idCardInfo.leftTip = @"*身份证号码";
        idCardInfo.placeHoder = @"请输入证件号码";
        idCardInfo.needCheckParams = YES;
        idCardInfo.cellHeight = FitPTScreen(53);
        idCardInfo.canInput = YES;
        idCardInfo.saveKey = @"certNo";
        idCardInfo.errorHint = @"请输入证件号码";
        [mArr addObject:idCardInfo];
        
        HLRightInputTypeInfo *startTime = [[HLRightInputTypeInfo alloc] init];
        startTime.leftTip = @"*身份证开始日期";
        startTime.placeHoder = @"请选择身份证开始日期";
        startTime.needCheckParams = YES;
        startTime.cellHeight = FitPTScreen(53);
        startTime.canInput = NO;
        startTime.saveKey = @"cardStartDt";
        startTime.errorHint = @"请选择身份证开始日期";
        startTime.showRightArrow = YES;
        [mArr addObject:startTime];
        
        HLRightInputTypeInfo *invaidTime = [[HLRightInputTypeInfo alloc] init];
        invaidTime.leftTip = @"*身份证到期日期";
        invaidTime.placeHoder = @"请选择身份证到期日期";
        invaidTime.needCheckParams = YES;
        invaidTime.cellHeight = FitPTScreen(53);
        invaidTime.canInput = NO;
        invaidTime.saveKey = @"licenseExpireDt";
        invaidTime.errorHint = @"请选择身份证到期日期";
        invaidTime.showRightArrow = YES;
        [mArr addObject:invaidTime];
        
        // 手持证件照
        HLRightImageTypeInfo *handCardInfo = [[HLRightImageTypeInfo alloc] init];
        handCardInfo.leftTip = @"*上传手持证件照";
        handCardInfo.needCheckParams = YES;
        handCardInfo.saveKey = @"certMeet";
        handCardInfo.type = HLInputCellTypeRightImage;
        handCardInfo.cellHeight = FitPTScreen(104);
        handCardInfo.errorHint = @"请上传手持证件照";
        [mArr addObject:handCardInfo];
        
        // 手持证件照
        HLRightImageTypeInfo *bankCardInfo = [[HLRightImageTypeInfo alloc] init];
        bankCardInfo.leftTip = @"*上传银行卡正面图";
        bankCardInfo.needCheckParams = YES;
        bankCardInfo.saveKey = @"cardCorrect";
        bankCardInfo.type = HLInputCellTypeRightImage;
        bankCardInfo.cellHeight = FitPTScreen(104);
        bankCardInfo.errorHint = @"请上传银行卡正面图";
        [mArr addObject:bankCardInfo];
        
        HLVoucherTwoImageInfo *twoImageInfo = [[HLVoucherTwoImageInfo alloc] init];
        twoImageInfo.leftTip = @"*上传证件照片";
        twoImageInfo.needCheckParams = YES;
        twoImageInfo.type = HLInputCellTypeTwoImage;
        twoImageInfo.cellHeight = FitPTScreen(173);
        twoImageInfo.errorHint = @"请上传证件照片";
        [mArr addObject:twoImageInfo];
        
        HLRightInputTypeInfo *telInfo = [[HLRightInputTypeInfo alloc] init];
        telInfo.leftTip = @"*联系电话";
        telInfo.placeHoder = @"请输入联系人电话";
        telInfo.needCheckParams = YES;
        telInfo.cellHeight = FitPTScreen(53);
        telInfo.canInput = YES;
        telInfo.saveKey = @"account";
        telInfo.keyBoardType = UIKeyboardTypeNumberPad;
        telInfo.errorHint = @"请输入联系人电话";
        [mArr addObject:telInfo];
        
        
        HLRightInputTypeInfo *WechatInfo = [[HLRightInputTypeInfo alloc] init];
        WechatInfo.leftTip = @"*微信号";
        WechatInfo.placeHoder = @"请输入微信号";
        WechatInfo.rightImage = [UIImage imageNamed:@"waring_grey"];
        WechatInfo.needCheckParams = YES;
        WechatInfo.cellHeight = FitPTScreen(53);
        WechatInfo.canInput = YES;
        WechatInfo.rightClick = YES;
        WechatInfo.showRightArrow = YES;
        WechatInfo.saveKey = @"weixinNum";
        WechatInfo.errorHint = @"请输入微信号";
        [mArr addObject:WechatInfo];
        
        HLVoucherAddRangeInfo *rangInfo = [[HLVoucherAddRangeInfo alloc] init];
        rangInfo.leftTip = @"*商户经营范围";
        rangInfo.needCheckParams = YES;
        rangInfo.errorHint = @"请选择商户经营范围";
        rangInfo.cellHeight = FitPTScreen(170);
        rangInfo.type = HLInputCellTypeVoucherRange;
        [mArr addObject:rangInfo];
        
        _dataSource = [mArr copy];
    }
    return _dataSource;
}



@end
