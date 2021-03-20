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

@interface HLSetViewController ()<UITableViewDelegate,UITableViewDataSource,HLSetInfoTableCellDelegate,UIImagePickerControllerDelegate>

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
@property(nonatomic,copy)NSString * videoPath;
//缩略图在APP中的路径
@property(nonatomic,copy)NSString * picPath;

@property(nonatomic,assign)BOOL uploading;

@end

@implementation HLSetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"设置" andTitleColor:UIColorFromRGB(0x222222)];
    [self hl_hideBack:YES];
}

//保存
-(void)saveBtnClick{
    
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
    
    HLLog(@"pargram = %@",self.pargram);
}

//取消
-(void)cancelBtnClick{
    [self hl_goback];
}

-(void)reloadData:(NSNotification *)sender{
    [self loadDefaultData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initCancel];
    [self creatFootView];
    [HLNotifyCenter addObserver:self selector:@selector(reloadData:) name:HLReloadSetPageNotifi object:nil];
    
    
    [[HLLocationManager shared] startLocationWithCallBack:^(BMKLocation *location) {
        self.lon = location.location.coordinate.longitude;
        self.lat = location.location.coordinate.latitude;
        [self loadDefaultData];
    }];
}

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

- (void)initCancel{
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = left;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    HLSetImageTableCell * cell = [HLSetImageTableCell dequeueReusableCell:tableView];
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

#pragma mark - SET&GET
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


#pragma mark -UIImagePickerControllerDelegate

//选择视频
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    HLLog(@"info = %@",info);
    
//    先删除之前的
    [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];
    _videoPath = [HLTools filePathWithSystemPath:info[UIImagePickerControllerMediaURL]];
//    拿到视频长度
    [self reloadVideoCellTime];
//    上传视频
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

//更新时间
-(void)reloadVideoCellTime{
    //    拿到视频长度
    AVURLAsset*audioAsset=[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_videoPath] options:nil];
    _mainModel.video_duration = [NSString stringWithFormat:@"%lf",CMTimeGetSeconds(audioAsset.duration) *1000];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.pargram setValue:_mainModel.video_duration forKey:@"video_duration"];
}

//上传缩略图
-(void)uploadVideoImage{
//    先删除之前的缩略图
    [[NSFileManager defaultManager] removeItemAtPath:_picPath error:nil];
    //获取视频缩略图
    UIImage * videoImage = [HLTools getScreenShotImageFromVideoPath:_videoPath];
    _picPath = [HLTools saveImageWithImage:[HLTools compressImage:videoImage toByte:800*1024]];
    
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
    } progress:^(CGFloat progress) {
    }];
    
}


//取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePicker dismissViewControllerAnimated:NO completion:^{
    }];
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

- (void)loadDefaultData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/BusinessEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self.view addSubview:self.tableView];
            [self handleDataWithDict:result.data];
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDataWithDict:(NSDictionary *)dict{
    
    _mainModel = [HLSetModel mj_objectWithKeyValues:dict];
    
    [self.pargram setValue:_mainModel.video_pic forKey:@"video_pic"];
    [self.pargram setValue:_mainModel.video_url forKey:@"video_url"];
    [self.pargram setValue:_mainModel.video_duration forKey:@"video_duration"];
    
    HLBaseInputModel * model1 = [[HLBaseInputModel alloc]init];
    model1.text = @"店铺名称";
    model1.place = @"输入店铺名称";
    model1.key = @"name";
    model1.value = dict[@"name"];
    model1.errorHint = @"请输入店铺名称";
    model1.needCheck = YES;
    
    HLBaseInputModel * model2 = [[HLBaseInputModel alloc]init];
    model2.text = @"店铺电话";
    model2.place = @"输入店铺电话";
    model2.key = @"tel";
    model2.value = dict[@"tel"];
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
    model3.pargram = @{@"province":dict[@"province"],@"city":dict[@"city"],@"county":dict[@"county"],@"longitude":@(_lon),@"latitude":@(_lat)};
    model3.value = dict[@"cityFullName"];
    
    
    HLBaseInputModel * detailAdress = [[HLBaseInputModel alloc]init];
    detailAdress.text = @"";
    detailAdress.canEdit = NO;
    detailAdress.value = dict[@"address"];
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
    doreNum.value = dict[@"roomNumber"];
    doreNum.key = @"roomNumber";
    
    HLBaseInputModel * model5 = [[HLBaseInputModel alloc]init];
    model5.text = @"店内公告";
    model5.place = @"如：填写店内招牌特色或通知等";
    model5.type = HLBaseInputTextViewType;
    model5.hideLine = YES;
    model5.cellHight = FitPTScreen(65);
    model5.key = @"serviceDes";
    model5.value = dict[@"serviceDes"];
    
    _mainModel.inputs = @[model1,model2,model3,detailAdress,doreNum,model5];
    [self.tableView reloadData];
}


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

@end
