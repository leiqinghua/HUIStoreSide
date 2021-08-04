//
//  HLSetViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLSetViewController.h"
#import "HLSetImageTableCell.h"
#import "HLSetInfoTableCell.h"
#import "HLSetModel.h"
#import "HLStoreImageController.h"
#import "HLAreaSelectView.h"
#import "HLLocationViewController.h"
#import "HLSetVideoTableCell.h"
#import "HLJDAPIManager.h"
#import "HLSetStoreModel.h"
#import "HLSetShopControlView.h"

@interface HLSetViewController ()<UITableViewDelegate,UITableViewDataSource,HLSetInfoTableCellDelegate,UIImagePickerControllerDelegate,HLSetShopControlViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)HLSetModel * mainModel;

/// 缓存的地区数据
@property (nonatomic, copy) NSArray *cacheAreaArr;

@property (nonatomic, strong) NSMutableDictionary *pargram;

@property(nonatomic,strong)HLBaseInputModel * detailAdress;

@property(nonatomic,assign)double lat;

@property(nonatomic,assign)double lon;

@property(nonatomic,strong)UIImagePickerController * imagePicker;

//视频在APP中的路径
@property(nonatomic,copy) NSString * videoPath;
//缩略图在APP中的路径
@property(nonatomic,copy) NSString * picPath;

@property(nonatomic,assign) BOOL uploading;

/// 店铺列表视图
@property (nonatomic, strong) HLSetShopControlView *controlView;

/// 添加店铺时记录的storeId
@property (nonatomic, copy) NSString *editStoreId;

@end

@implementation HLSetViewController

#pragma mark - Life Cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"设置" andTitleColor:UIColorFromRGB(0x222222)];
    [self hl_hideBack:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"门店管理" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF9900)} forState:UIControlStateNormal];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = left;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self creatFootView];
    [HLNotifyCenter addObserver:self selector:@selector(loadDefaultData:) name:HLReloadSetPageNotifi object:nil];
    
    // 定位之后获取数据
    [[HLLocationManager shared] startLocationWithCallBack:^(BMKLocation *location) {
        self.lon = location.location.coordinate.longitude;
        self.lat = location.location.coordinate.latitude;
        [self loadDefaultData:YES];
    }];
}

#pragma mark - Network

/// 加载默认数据
- (void)loadDefaultData:(BOOL)showHud{
    if (showHud) {
        HLLoading(self.view);
    }
    NSDictionary *params = @{};
    if (self.editStoreId.length) {
       params = @{@"storeId":self.editStoreId?:@""};
    }
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/BusinessEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = params;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            if(![self.view.subviews containsObject:self.tableView]){
                [self.view addSubview:self.tableView];
            }
            [self handleDataWithDict:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

/// 加载店铺列表
- (void)loadStoreListData:(void(^)(BOOL canAdd, NSArray <HLSetStoreModel *>*storeList))finish{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            BOOL canAdd = [result.data[@"canAdd"] integerValue];
            NSMutableArray *stores = [HLSetStoreModel mj_objectArrayWithKeyValuesArray:result.data[@"stores"]];
            finish(canAdd,[stores copy]);
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - Method

// 右边按钮点击，门店管理
- (void)rightBarButtonItemClick{
    
    // 如果此时已经展示了
    if ([self.view.subviews containsObject:self.controlView]) {
        [self.controlView hide];
        return;
    }
    
    [self loadStoreListData:^(BOOL canAdd, NSArray <HLSetStoreModel *>*storeList) {
        [self.view addSubview:self.controlView];
        [self.controlView configStores:storeList canAdd:canAdd];
    }];
}

//保存
- (void)saveBtnClick{
    
    if (self.uploading) {
        HLShowHint(@"视频上传中，请稍后...", self.view);
        return;
    }
    
    if (self.mainModel.videoState < 0 || self.mainModel.picState < 0) {
        HLShowHint(@"请重新上传视频后保存", self.view);
        return;
    }
    
    if (!_mainModel.pic.length) {
        HLShowHint(@"请选择店铺logo", self.view);
        return;
    }
    
    self.pargram[@"storeId"] = self.mainModel.id;    
    for (HLBaseInputModel * model in self.mainModel.inputs) {
        if (model.needCheck && ![model checkResult]) {
            HLShowHint(model.errorHint, self.view);
            return;
        }
        if (model.key.length) {
            [self.pargram setValue:model.value?:@"" forKey:model.key];
        }
        if (model.pargram.count) {
            [self.pargram setValuesForKeysWithDictionary:model.pargram];
        }
    }
    
    [self.pargram setValue:_mainModel.pic forKey:@"pic"];
    [self updateStoreData];
}

// 取消
-(void)cancelBtnClick{
    [self hl_goback];
}

#pragma mark - HLSetShopControlViewDelegate

/// 编辑门店
- (void)controlView:(HLSetShopControlView *)controlView editWithStoreModel:(HLSetStoreModel *)storeModel{
    self.editStoreId = storeModel.storeId;
    [self.controlView hide];
    [self loadDefaultData:YES];
}

/// 删除门店
- (void)controlView:(HLSetShopControlView *)controlView deleteWithStoreModel:(HLSetStoreModel *)storeModel successBlock:(void (^)(void))successBlock{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreDel.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"storeId":storeModel.storeId};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            HLShowText(@"操作成功");
            // 并且重新加载数据，加载默认的
            self.editStoreId = nil;
            [self loadDefaultData:NO];
            // 删除之后，再次获取
            [self loadStoreListData:^(BOOL canAdd, NSArray <HLSetStoreModel *>*storeList) {
                [self.controlView configStores:storeList canAdd:canAdd];
            }];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

/// 添加门店
- (void)addStoreWithControlView:(HLSetShopControlView *)controlView{
    // 获取id
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreAdd.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            // 获取storeId
            self.editStoreId = [NSString stringWithFormat:@"%ld",[result.data[@"storeId"] integerValue]];
            [self.controlView hide];
            [self loadDefaultData:NO];
        }else{
            HLHideLoading(self.view);
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        HLSetInfoTableCell * cell = [HLSetInfoTableCell dequeueReusableCell:tableView];
        cell.mainModel = self.mainModel;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == 1) {
        HLSetVideoTableCell * cell = [HLSetVideoTableCell dequeueReusableCell:tableView];
        cell.mainModel = _mainModel;
        return cell;
    }
    
    HLSetImageTableCell *cell = [HLSetImageTableCell dequeueReusableCell:tableView];
    cell.mainModel = _mainModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return self.mainModel.inputCellH;
    }
    return FitPTScreen(131);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        HLStoreImageController * storeVC = [[HLStoreImageController alloc]init];
        storeVC.storePic = _mainModel.pic;
        storeVC.storeId = _mainModel.id;
        [self hl_pushToController:storeVC];
        return;
    }
    
    if (indexPath.row == 1) {
        
        if (!self.uploading && self.mainModel.picState >= 0) {
            [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
            return;
        }
        
        if (self.mainModel.videoState < 0) {
            self.mainModel.state = @"";
            [[HLJDAPIManager manager]reUploadWithFileName:_videoPath.lastPathComponent video:YES];
            return;
        }
        
        if (self.mainModel.picState < 0){
            self.mainModel.state = @"";
            [[HLJDAPIManager manager]reUploadWithFileName:_picPath.lastPathComponent video:false];
        }
    }
}

#pragma mark - HLSetInfoTableCellDelegate

- (void)infoCell:(HLSetInfoTableCell *)cell selectWithModel:(HLBaseInputModel *)model{
    if ([model.text isEqualToString:@"店铺地址"]) {
        HLLocationViewController * locationVC = [[HLLocationViewController alloc]init];
        locationVC.locationBlock = ^(double lat, double lon, NSString *province, NSString *city, NSString *area, NSString *address) {
            model.value = [NSString stringWithFormat:@"%@-%@-%@",province,city,area];
            model.pargram = @{@"province":province,@"city":city,@"county":area,@"longitude":@(lon),@"latitude":@(lat)};
            self.detailAdress.value = address;
            [self.tableView reloadData];
        };
        [self hl_pushToController:locationVC];
    }
}

#pragma mark - UIImagePickerControllerDelegate

// 选择视频
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    
    // 先删除之前的
    [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];
    _videoPath = [HLTools filePathWithSystemPath:info[UIImagePickerControllerMediaURL]];
    // 拿到视频长度
    [self reloadVideoCellTime];
    // 上传视频
    [self.imagePicker dismissViewControllerAnimated:NO completion:^{
        [[HLJDAPIManager manager]uploadFileWithFilePath:_videoPath video:YES completion:^(NSString * _Nonnull uploadUrl, NSInteger result) {
            dispatch_main_async_safe(^{
                if (result < 0) {
                    self.mainModel.state = @"重新上传";
                    self.mainModel.videoState = -1;
                }else if (uploadUrl.length){
                    [self.pargram setValue:uploadUrl forKey:@"video_url"];
                    self.mainModel.state = @"";
                    self.mainModel.videoState = 1;
                    [self uploadVideoImage];
                }
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        } progress:^(CGFloat progress) {
            dispatch_main_async_safe(^{
                self.uploading = YES;
                self.mainModel.progress = progress;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        }];
    }];
}

// 更新时间
-(void)reloadVideoCellTime{
    // 拿到视频长度
    AVURLAsset*audioAsset=[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_videoPath] options:nil];
    _mainModel.video_duration = [NSString stringWithFormat:@"%lf",CMTimeGetSeconds(audioAsset.duration) *1000];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.pargram setValue:_mainModel.video_duration forKey:@"video_duration"];
}

// 上传缩略图
-(void)uploadVideoImage{
    // 先删除之前的缩略图
    [[NSFileManager defaultManager] removeItemAtPath:_picPath error:nil];
    //获取视频缩略图
    UIImage * videoImage = [HLTools getScreenShotImageFromVideoPath:_videoPath];
    _picPath = [HLTools saveImageWithImage:[HLTools compressImage:videoImage toByte:800 * 1024]];
    [[HLJDAPIManager manager]uploadFileWithFilePath:_picPath video:false completion:^(NSString * _Nonnull uploadUrl, NSInteger result) {
        dispatch_main_async_safe(^{
            self.uploading = false;
            if (result < 0) {
                self.mainModel.state = @"重新上传";
                self.mainModel.picState = -1;
            }else if (uploadUrl.length){
                self.mainModel.picState = 1;
                self.mainModel.state = @"";
                self.mainModel.video_pic = uploadUrl;
                [self.pargram setValue:uploadUrl forKey:@"video_pic"];
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    } progress:^(CGFloat progress) {}];
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePicker dismissViewControllerAnimated:NO completion:^{}];
}

/// 加载地区的数据
- (void)loadAreaDataWithCallBack:(void(^)(NSArray *areaArr))callBack{
    if (self.cacheAreaArr.count) {
        callBack(self.cacheAreaArr);
        return;
    }
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/UserAddressCity.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            self.cacheAreaArr = result.data;
            callBack(self.cacheAreaArr);
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

/// 处理数据，dict可能为空
- (void)handleDataWithDict:(NSDictionary *)dict{
    
    if (dict) {
        _mainModel = [HLSetModel mj_objectWithKeyValues:dict];
        [self.pargram setValue:_mainModel.video_pic forKey:@"video_pic"];
        [self.pargram setValue:_mainModel.video_url forKey:@"video_url"];
        [self.pargram setValue:_mainModel.video_duration forKey:@"video_duration"];
    }
    
    HLBaseInputModel * model1 = [[HLBaseInputModel alloc]init];
    model1.text = @"店铺名称";
    model1.place = @"输入店铺名称";
    model1.key = @"name";
    if (dict) {
        model1.value = dict[@"name"] ?: @"";
    }
    model1.errorHint = @"请输入店铺名称";
    model1.needCheck = YES;
    
    HLBaseInputModel * model2 = [[HLBaseInputModel alloc]init];
    model2.text = @"店铺电话";
    model2.place = @"输入店铺电话";
    model2.key = @"tel";
    if (dict) {
        model2.value = dict[@"tel"];
    }
    model2.errorHint = @"请输入店铺电话";
    model2.needCheck = YES;
    
    
    HLBaseInputModel * model3 = [[HLBaseInputModel alloc]init];
    model3.text = @"店铺地址";
    model3.place = @"快速定位选择地址";
    model3.rightImg = @"set_locate";
    model3.canEdit = false;
    model3.errorHint = @"请选择所在地区";
    model3.needCheck = YES;
    model3.placeColor = UIColorFromRGB(0x999999);
    if (dict) {
        model3.pargram = @{@"province":dict[@"province"],@"city":dict[@"city"],@"county":dict[@"county"],@"longitude":@(_lon),@"latitude":@(_lat)};
        model3.value = dict[@"cityFullName"] ?: @"";
    }
    
    HLBaseInputModel * detailAdress = [[HLBaseInputModel alloc]init];
    detailAdress.text = @"";
    detailAdress.canEdit = NO;
    if (dict) {
        detailAdress.value = dict[@"address"];
    }
    detailAdress.needCheck = YES;
    detailAdress.key = @"address";
    detailAdress.type = HLBaseInputTextViewType;
    detailAdress.cellHight = FitPTScreen(65);
    _detailAdress = detailAdress;
    
    HLBaseInputModel * doreNum = [[HLBaseInputModel alloc]init];
    doreNum.text = @"门牌号";
    doreNum.place = @"例如：1号楼2层301室";
    doreNum.canEdit = YES;
    doreNum.placeColor = UIColorFromRGB(0x999999);
    if (dict) {
        doreNum.value = dict[@"roomNumber"];
    }
    doreNum.key = @"roomNumber";
    
    HLBaseInputModel * model5 = [[HLBaseInputModel alloc]init];
    model5.text = @"店内公告";
    model5.place = @"如：填写店内招牌特色或通知等";
    model5.type = HLBaseInputTextViewType;
    model5.hideLine = YES;
    model5.cellHight = FitPTScreen(65);
    model5.key = @"serviceDes";
    if (dict) {
        model5.value = dict[@"serviceDes"];
    }
    
    _mainModel.inputs = @[model1,model2,model3,detailAdress,doreNum,model5];
    [self.tableView reloadData];
}

//https://sapi.51huilife.cn/HuiLife_Api/MerchantSide/BusinessUpdate.php
-(void)updateStoreData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/BusinessUpdate.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [HLNotifyCenter postNotificationName:HLReloadHomeDataNotifi object:nil];
            HLShowHint(@"信息修改成功", self.view);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - View

// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Getter

- (HLSetShopControlView *)controlView{
    if (!_controlView) {
        _controlView = [[HLSetShopControlView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.backgroundColor = UIColor.whiteColor;
        AdjustsScrollViewInsetNever(self, _tableView);
    }
    return _tableView;
}

- (NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}

-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        _imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.movie",  nil];
    }
    return _imagePicker;
}

@end
