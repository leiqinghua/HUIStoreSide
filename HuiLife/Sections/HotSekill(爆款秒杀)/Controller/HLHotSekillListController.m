//
//  HLHotSekillListController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLHotSekillListController.h"
#import "HLHotSekillInputController.h"
#import "HLBottomControlView.h"

@interface HLHotSekillListController () <UITableViewDelegate,UITableViewDataSource,HLHotSekillListViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger page; // page， 默认为1

@property (nonatomic, strong) UIView *placeView; // 占位图

@end

@implementation HLHotSekillListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"限时抢购"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    [self.view addSubview:self.placeView];
    [self.view addSubview:self.tableView];
    AdjustsScrollViewInsetNever(self, self.tableView);
    [self creatFootViewWithButtonTitle:self.selectBlock ? @"确定" : @"添加秒杀商品"];
    
    /// 加载数据
    [self loadGoodsList];
    
    [HLNotifyCenter addObserver:self selector:@selector(reloadListData) name:@"hotSekillListReloadData" object:nil];
}

- (void)reloadListData{
    self.page = 1;
    [self loadGoodsList];
}

/// 加载数据
- (void)loadGoodsList{
    
    NSString *api = self.selectBlock ? @"/MerchantSide/HotSeckillListPL.php" : @"/MerchantSide/HotSeckillList.php";
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = api;
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"page":@(_page)};
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
        [self.navigationController pushViewController:addGoods animated:YES];
    }
}

#pragma mark - HLHotSekillListViewCellDelegate

/// 点击更多按钮
- (void)listViewCell:(HLHotSekillListViewCell *)cell moreBtnClick:(HLHotSekillGoodModel *)goodModel{
    
    // 判断是否是上架还是
    BOOL showUp = goodModel.upOrDown == 2;
    NSString *upStateStr = showUp ? @"上架" : @"下架";
    [HLBottomControlView showControlViewWithItemTitles:@[@"微信朋友圈",@"微信好友",@"生成展架",@"二维码下载",upStateStr] callBack:^(HLControlType type) {
        if (type == HLControlTypeStateDown || type == HLControlTypeStateUp) {
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
            [self loadGoodsList];;
        }];
        
        [_tableView headerNormalRefreshingBlock:^{
            self.page = 1;
            [self loadGoodsList];
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

@end
