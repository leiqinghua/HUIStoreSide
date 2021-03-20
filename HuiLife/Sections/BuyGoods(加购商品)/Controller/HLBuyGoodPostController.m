//
//  HLBuyGoodPostController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/26.
//

#import "HLBuyGoodPostController.h"

#import "HLImageSinglePickerController.h"
#import "HLInputDateViewCell.h"
#import "HLRightImageViewCell.h"
#import "HLRightInputViewCell.h"
#import "HLSelectArea.h"
#import "HLTimeSingleSelectView.h"
#import "HLVoucherMarketAddHead.h"
#import "HLVoucherMarketEditInfo.h"

@interface HLBuyGoodPostController () <UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HLVoucherMarketAddHead *tableHead;

@end

@implementation HLBuyGoodPostController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布预览";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    [self creatFootViewWithButtonTitle:@"完成发布"];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    // 所有的数据模型，都不可再编辑，点击事件已经去掉
    for (HLBaseTypeInfo *info in _dataSource) {
        info.enabled = NO;
    }
}

/// 提交数据
- (void)saveButtonClick {
    HLCustomAlert *alert = [[HLCustomAlert alloc] initWithContentFrame:CGRectMake(0, 0, FitPTScreen(227), FitPTScreen(149))];
    alert.message = @"完成发布";
    alert.messageColor = UIColorFromRGB(0x333333);
    alert.messageFont = [UIFont systemFontOfSize:FitPTScreen(16)];
    alert.buttonTitles = @[@"取消", @"确认"];
    alert.buttonColors = @[UIColorFromRGB(0x333333), UIColorFromRGB(0xFF9F16)];
    alert.callBack = ^(NSInteger index) {
        if (index == 1) {
            // 压缩图片
            HLLoading(self.view);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data =
                [HLTools compressImage:self.selectImage
                                toByte:200 * 1024];
                dispatch_main_async_safe(^{
                    [XMCenter sendRequest:^(XMRequest *_Nonnull request) {
                        request.api = @"/Shopplus/Billpurchased/payPurchased";
                        request.requestType = kXMRequestUpload;
                        request.serverType = HLServerTypeStoreService;
                        request.parameters = self.mParams;
                        // 后台会生成图片名称
                        [request addFormDataWithName:@"goodsPic"
                                            fileName:@"data.jpg"
                                            mimeType:@"image/jpeg"
                                            fileData:data];
                    }
                                onSuccess:^(XMResult *_Nullable responseObject) {
                                    HLHideLoading(self.view);
                                    
                                    if ([responseObject code] == 200) {
                                        HLShowText(@"保存成功");
                                        [HLNotifyCenter postNotificationName:@"buyGoodListReloadData"
                                                                      object:nil];
                                        [self hl_popToControllerWithClassName:@[
                                                                                @"HLBuyGoodsListController"
                                                                                ]];
                                    }
                                }
                                onFailure:^(NSError *_Nullable error) {
                                    HLHideLoading(self.view);
                                }];
                });
            });
        }
    };
    [alert show];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title {
    
    UIView *footView =
    [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91),
                                             ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW,
                                      ScreenH - Height_NavBar - FitPTScreen(110));
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"]
                          forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self
                   action:@selector(saveButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    // 提示信息
    UILabel *tipLab = [[UILabel alloc] init];
    [footView addSubview:tipLab];
    tipLab.text = @"完成发布后，发布的信息不可再修改";
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    tipLab.textColor = UIColorFromRGB(0xFF4646);
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(saveButton);
        make.bottom.equalTo(saveButton.top).offset(FitPTScreen(3));
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault: {
            HLRightInputViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell"
                                            forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } break;
        case HLInputCellTypeRightImage: {
            HLRightImageViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"HLRightImageViewCell"
                                            forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } break;
        case HLInputCellTypeDate: {
            HLInputDateViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"HLInputDateViewCell"
                                            forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource[indexPath.row] cellHeight];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView =
        [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW,
                                                      ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLRightInputViewCell class]
           forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLRightImageViewCell class]
           forCellReuseIdentifier:@"HLRightImageViewCell"];
        [_tableView registerClass:[HLInputDateViewCell class]
           forCellReuseIdentifier:@"HLInputDateViewCell"];
    }
    return _tableView;
}

@end
