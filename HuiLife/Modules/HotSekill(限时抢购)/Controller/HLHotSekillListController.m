//
//  HLHotSekillListController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLHotSekillListController.h"
#import "HLHotSekillInputController.h"
#import "HLBottomControlView.h"
#import "HLHotSekillEditView.h"

@interface HLHotSekillListController () <UITableViewDelegate,UITableViewDataSource,HLHotSekillListViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger page; // page， 默认为1

@property (nonatomic, strong) UIView *placeView; // 占位图

@property (nonatomic, strong) UIView *reasonView;   // 驳回原因展示视图
@property (nonatomic, strong) UILabel *reasonLab;   // 驳回原因

@end

@implementation HLHotSekillListController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 默认是 normal
        self.type = @"10";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"限时抢购"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.placeView];
    [self.view addSubview:self.tableView];
    AdjustsScrollViewInsetNever(self, self.tableView);
    [self creatFootViewWithButtonTitle:self.selectBlock ? @"确定" : @"添加秒杀商品"];
    
    /// 加载数据
    [self reloadListData];
    
    [HLNotifyCenter addObserver:self selector:@selector(reloadListData) name:@"hotSekillListReloadData" object:nil];
}

#pragma mark - Methods

- (void)reloadListData{
    self.page = 1;
    [self loadGoodsList:YES];
}

/// 加载数据
- (void)loadGoodsList:(BOOL)hud{
    
    // 是否为选择商品
    BOOL isSelectGoods = self.selectBlock != nil;
    NSString *api = @"";
    NSDictionary *params = @{};
    if (isSelectGoods) {
        api = @"/MerchantSide/HotSeckillListPL.php";
        params = @{@"page":@(_page)};
    }else{
        api = @"/MerchantSide/HotSeckillList.php";
        params = @{@"page":@(_page),@"type":self.type};
    }
        
    if (hud) {
        HLLoading(self.view);
    }
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = api;
        request.serverType = HLServerTypeNormal;
        request.parameters = params;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *models = [HLHotSekillGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
            [self handleBuyGoodsModels:models];
        }else{
            self.page > 1 ? 1 : --self.page;
        }
    } onFailure:^(NSError * _Nullable error) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        self.page > 1 ? 1 : --self.page;
    }];
}

/// 处理数据
- (void)handleBuyGoodsModels:(NSArray *)models{
    
    [self.tableView.mj_header endRefreshing];
    
    // 如果是第一页
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (models.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.dataSource addObjectsFromArray:models];
    [self.tableView reloadData];
    
    self.tableView.hidden = self.dataSource.count == 0;
    self.placeView.hidden = self.dataSource.count > 0;
    self.tableView.mj_footer.hidden = self.dataSource.count == 0;
}

/// 添加
- (void)addButtonClick{
    
    // 判断如果是选择的
    if (self.selectBlock) {
        
        __block HLHotSekillGoodModel *goodModel = nil;
        [self.dataSource enumerateObjectsUsingBlock:^(HLHotSekillGoodModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.userSelect) {
                goodModel = obj;
                *stop = YES;
            }
        }];
        
        if (!goodModel) {
            HLShowHint(@"请选择秒杀商品", self.view);
            return;
        }
        
        self.selectBlock(goodModel);
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        HLHotSekillInputController *addGoods = [[HLHotSekillInputController alloc] init];
        addGoods.isEdit = NO;
        addGoods.sekillType = self.sekillType;
        [self.navigationController pushViewController:addGoods animated:YES];
    }
}

- (HLHotSekillType)sekillType{
    return self.type.integerValue;
}

/// 部分编辑
- (void)saveEditModelWithParams:(NSDictionary *)params{
   HLLoading(self.view);
   [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
       request.api = @"/MerchantSide/SeckillInsert.php?dev=1";
       request.serverType = HLServerTypeNormal;
       request.parameters = params;
   } onSuccess:^(XMResult *  _Nullable responseObject) {
       if ([responseObject code] == 200) {
           self.page = 1;
           [self loadGoodsList:YES];
       }
   } onFailure:^(NSError * _Nullable error) {
       HLHideLoading(self.view);
   }];
}

#pragma mark - HLHotSekillListViewCellDelegate

/// 点击原因
- (void)listViewCell:(HLHotSekillListViewCell *)cell reasonClick:(HLHotSekillGoodModel *)goodModel{
    if (goodModel.reason.length == 0) {
        return;
    }
    [self.view addSubview:self.reasonView];
    self.reasonLab.text = goodModel.reason;
}

/// 隐藏理由视图
- (void)hideReasonView{
    [self.reasonView removeFromSuperview];
}

/// 点击更多按钮
- (void)listViewCell:(HLHotSekillListViewCell *)cell moreBtnClick:(HLHotSekillGoodModel *)goodModel{
    
    // 判断是否是上架还是
    BOOL showUp = goodModel.upOrDown == 2;
    NSString *upStateStr = showUp ? @"上架" : @"下架";
    [HLBottomControlView showControlViewWithItemTitles:@[@"微信朋友圈",@"微信好友",@"生成展架",@"二维码下载",upStateStr,@"修改"] callBack:^(HLControlType type) {
        if (type == HLControlTypeStateDown || type == HLControlTypeStateUp) {
            // 审核中不支持上下架操作
            if (goodModel.stateCode == 7) {
                HLShowHint(@"审核中不支持上/下架操作", self.view);
                return;
            }
            [self changeUpStatesWithGoodModel:goodModel cell:cell];
            return;
        }
        
        if(type == HLControlTypeWXChat || type == HLControlTypeWXCycle){
            if (![[HLPayManage shareManage].wxManage wxAppIsInstalled]) {
                HLShowText(@"请安装微信客户端");
                return;
            }
            
            NSString *weChat = type == HLControlTypeWXChat?goodModel.friendCircle:goodModel.wechatMoments;
            [self loadWXShareDataWithProId:goodModel.Id isChat:type == HLControlTypeWXChat weChat:weChat];
            return;
        }
        
        if (type == HLControlTypeQRCode) {
            [self dowonLoadQRCodeWithId:goodModel.Id qrcode:goodModel.qrCode];
            return;
        }
        
        if (type == HLControlTypeDisplay) {
            [self createDisplayWithId:goodModel.Id display:goodModel.displayRack];
        }
        
        // 修改
        if (type == HLControlTypeEditCard){
            // 订单数>0，只能部分编辑
            if(goodModel.orderCnt > 0){
                // 判断类型
                NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
                if ([self sekillType] == HLHotSekillTypeNormal || [self sekillType] == HLHotSekillType40) {
                    [mDict setObject:[NSString stringWithFormat:@"%.2lf",goodModel.invite_amount] forKey:@"invite_amount"];
                }
                [mDict setObject:[NSString stringWithFormat:@"%ld",goodModel.offerNum] forKey:@"offerNum"];
                [mDict setObject:[NSString stringWithFormat:@"%ld",goodModel.limitNum] forKey:@"limitNum"];
                [mDict setObject:goodModel.startTime forKey:@"startTime"];
                [mDict setObject:goodModel.endTime forKey:@"endTime"];
                [mDict setObject:goodModel.closingDate forKey:@"closingDate"];
                weakify(self);
                [HLHotSekillEditView showEditViewWithData:mDict superView:self.view submitBlock:^(NSDictionary * _Nonnull dict, HLHotSekillEditView * _Nonnull editView) {
                    // 验证规则
                    NSArray *roles = [weak_self editDataRolesWithModel:goodModel params:dict];
                    for (NSDictionary *subRole in roles) {
                        BOOL roleValue = [subRole[@"role"] boolValue];
                        if (roleValue == YES) {
                            HLShowHint(subRole[@"tip"], self.view);
                            return;
                        }
                    }
                    
                    [editView hide];
                    
                    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    [mParams setObject:goodModel.Id forKey:@"bid"];
                    // 保存
                    [weak_self saveEditModelWithParams:mParams];
                }];
            }else{ // 订单数 = 0，可以全量编辑
                HLHotSekillInputController *editGoods = [[HLHotSekillInputController alloc] init];
                editGoods.isEdit = YES;
                editGoods.editId = goodModel.Id;
                editGoods.sekillType = self.sekillType;
                [self.navigationController pushViewController:editGoods animated:YES];
            }
        }
    }];
}

/// 分享到朋友圈还是好友
- (void)loadWXShareDataWithProId:(NSString *)proId isChat:(BOOL)isChat weChat:(NSString *)weChat{
    
    if (weChat.length) {
        HLShowHint(weChat, self.view);
        return;
    }
    
    if (isChat) {
        [HLTools shareWithId:proId type:3 controller:self completion:^(NSDictionary *dict) {
            [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"pic"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                dispatch_main_async_safe(^{
                    [HLWXManage shareToWXWithMiniProgramUserName:WX_MINIPAGRAM_USERNAME title:dict[@"title"] description:@"" image:image webpageUrl:dict[@"link"] path:dict[@"path"]];
                });
            }];
        }];
        
        return;
    }
    
    [HLTools shareImageWithId:proId type:3 controller:self completion:^(NSDictionary * dict) {
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"imgUrl"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            dispatch_main_async_safe(^{
                [HLWXManage shareToWXWithImage:image scene:HLSceneTimeline];
            });
        }];
    }];
}

/// 改变上下架的状态
- (void)changeUpStatesWithGoodModel:(HLHotSekillGoodModel *)goodModel cell:(HLHotSekillListViewCell *)cell {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSide/SeckillUpDown.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"proId":goodModel.Id,@"upDown":@(goodModel.upOrDown)};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            [goodModel mj_setKeyValues:responseObject.data];
            [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

//下载二维码
- (void)dowonLoadQRCodeWithId:(NSString *)Id qrcode:(NSString *)qrcode{
    if (qrcode.length) {
        HLShowHint(qrcode, self.view);
        return;
    }
    [HLTools saveQRCodeWithId:Id type:3 controller:self completion:^(NSDictionary *data) {
        NSDictionary *pargram = @{
            @"codeImgUrl": data[@"erweimaUrl"]?:@"",
              @"navTitle": @"二维码下载",
        };
        [HLTools pushAppPageLink:@"HLMatterCodeController" params:pargram needBack:false];
    }];
}

//生成展架
/**
 type：3抢购 1卡 2券
 */
- (void)createDisplayWithId:(NSString *)Id display:(NSString *)display{
    if (display.length) {
        HLShowHint(display, self.view);
        return;
    }
    [HLTools pushAppPageLink:@"HLDispalyMainController" params:@{@"pro_id":Id,@"type":@(3)} needBack:false];
}

#pragma mark - Helper

// 编辑时的规则
- (NSArray *)editDataRolesWithModel:(HLHotSekillGoodModel *)goodModel params:(NSDictionary *)params{
    NSArray *roles = @[];
    switch ([self sekillType]) {
        case HLHotSekillTypeNormal:
        case HLHotSekillType40:
        {
            double inviteAmount = [params[@"invite_amount"] doubleValue];
            NSString *fySmallerTip = [NSString stringWithFormat:@"跨店分佣不能低于%.2lf元",goodModel.price * 0.06];
            roles = @[@{@"tip":fySmallerTip,@"role":@(inviteAmount < goodModel.price * 0.06)},
                      @{@"tip":@"跨店分佣不能大于售价",@"role":@(inviteAmount > goodModel.price)}];
        }
            
            break;
        default:
            roles = @[];
            break;
    }
    return roles;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLHotSekillListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHotSekillListViewCell" forIndexPath:indexPath];
    cell.showSelectView = self.selectBlock != nil;
    cell.sekillType = self.sekillType;
    cell.goodModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        
        HLHotSekillGoodModel *goodModel = self.dataSource[indexPath.row];
        if (goodModel.userSelect || goodModel.isSelected) {
            return;
        }
        [self.dataSource enumerateObjectsUsingBlock:^(HLHotSekillGoodModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userSelect = obj == goodModel;
        }];
        [self.tableView reloadData];
    }
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(91));
    
    // 加按钮
    UIButton *addButton = [[UIButton alloc] init];
    [footView addSubview:addButton];
    [addButton setTitle:title forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [addButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [addButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Getter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = FitPTScreen(134);
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(18))];
        [_tableView registerClass:[HLHotSekillListViewCell class] forCellReuseIdentifier:@"HLHotSekillListViewCell"];
//        weakify(self);
//        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weak_self.page = 1;
//            [weak_self loadGoodsList];
//        }];
//        mj_header.lastUpdatedTimeLabel.hidden = YES;
//
//        _tableView.mj_header = mj_header;
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            weak_self.page++;
//            [weak_self loadGoodsList];
//        }];
        
        [_tableView footerWithEndText:@"没有更多数据"
                      refreshingBlock:^{
            self.page++;
            [self loadGoodsList:NO];
        }];
        
        [_tableView headerNormalRefreshingBlock:^{
            self.page = 1;
            [self loadGoodsList:NO];
        }];
        [_tableView hideFooter:YES];
        
    }
    return _tableView;
}

- (UIView *)placeView{
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _placeView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_sekill_place"]];
        [_placeView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(213));
            make.centerX.equalTo(_placeView);
            make.width.equalTo(FitPTScreen(93));
            make.height.equalTo(FitPTScreen(72));
        }];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [_placeView addSubview:tipLab];
        tipLab.text = @"暂无秒杀商品进行推广";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(13));
            make.centerX.equalTo(_placeView);
        }];
    }
    return _placeView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)reasonView{
    if (!_reasonView) {
        
        _reasonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _reasonView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        
        CGFloat contentWidth = FitPTScreen(260);
        CGFloat contentHeight = FitPTScreen(160);
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake((ScreenW - contentWidth)/2, (ScreenH - contentHeight)/2, contentWidth, contentHeight)];
        contentV.backgroundColor = UIColor.whiteColor;
        contentV.layer.cornerRadius = FitPTScreen(10);
        contentV.layer.masksToBounds = YES;
        [_reasonView addSubview:contentV];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [contentV addSubview:tipLab];
        tipLab.text = @"驳回说明";
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(FitPTScreen(0));
            make.height.equalTo(FitPTScreen(45));
        }];
        
        UIButton *okBtn = [[UIButton alloc] init];
        [contentV addSubview:okBtn];
        [okBtn setTitle:@"知道了" forState:UIControlStateNormal];
        okBtn.backgroundColor = UIColorFromRGB(0xFF9900);
        [okBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [okBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            make.height.equalTo(FitPTScreen(45));
        }];
        [okBtn addTarget:self action:@selector(hideReasonView) forControlEvents:UIControlEventTouchUpInside];
        
        self.reasonLab = [[UILabel alloc] init];
        [contentV addSubview:self.reasonLab];
        self.reasonLab.textColor = UIColorFromRGB(0x333333);
        self.reasonLab.numberOfLines = 3;
        self.reasonLab.textAlignment = NSTextAlignmentCenter;
        self.reasonLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [self.reasonLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLab.bottom).offset(FitPTScreen(0));
            make.left.equalTo(FitPTScreen(12));
            make.right.equalTo(FitPTScreen(-12));
            make.bottom.equalTo(okBtn.top).offset(FitPTScreen(-13));
        }];
    }
    return _reasonView;
}


@end


///// 洗发水 50 35 2.10 提前 48 小时 5-6人 2份 1份 2021-08-08至2021-08-10 2021-08-08 仅此一天
////  飘柔洗发水 1瓶 50 大瓶装   包装 1套 2 包装盒
///   上：1（默认） 2 3 下：4 5

//invite_amount    2.10
//booking    2
//peoType    4
//offerNum    2
//limitNum    1
//startTime    2021-08-08
//endTime    2021-08-10
//closingDate    2021-08-08
//setMealDetails    [{"remarks":"大瓶装","num":"1","price":"50","name":"飘柔洗发水","unit":"瓶"},{"remarks":"包装盒","num":"1","price":"2","name":"包装","unit":"套"}]
//summary    仅此一天
//logo    http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284258231121.jpg
//master    [{"id":"32870","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284258231121.jpg","is_check":0},{"id":"32871","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284258241563.jpg","is_check":0},{"id":"32869","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284258221207.jpg","is_check":0}]
//album    [{"id":"32866","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284257321050.jpg","is_check":0},{"id":"32865","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284257321326.jpg","is_check":0}]
//pid    1346191

//id    60528
//token    yjkyBQ8wKU8mBlZrpS0V
//bidd    44744
//type    10
//title    洗发水
//orgPrice    50.00
//price    35.00
//invite_amount    2.10
//booking    2
//peoType    4
//offerNum    2
//limitNum    1
//startTime    2021-08-08
//endTime    2021-08-10
//closingDate    2021-08-08
//setMealDetails    [{"remarks":"大瓶装","num":"1","price":"50","name":"飘柔洗发水","unit":"瓶"},{"remarks":"包装盒","num":"1","price":"2","name":"包装","unit":"套"}]
//summary    仅此一天
//logo    http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284258231121.jpg
//master    [{"id":"32869","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284258221207.jpg","is_check":0},{"id":"32870","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284258231121.jpg","is_check":0},{"id":"32871","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284258241563.jpg","is_check":0}]
//album    [{"id":"32865","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284257321326.jpg","is_check":0},{"id":"32866","imgPath":"http://aimg8.oss-cn-shanghai.aliyuncs.com/HotSKAlbum/47979_16284257321050.jpg","is_check":0}]
//pid    1346191
