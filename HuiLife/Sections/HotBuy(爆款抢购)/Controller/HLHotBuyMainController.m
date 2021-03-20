//
//  HLHotBuyMainController.m
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import "HLHotBuyMainController.h"
#import "HLBottomControlView.h"
#import "HLHotBuyListViewCell.h"
#import "HLHotBuyAddController.h"

@interface HLHotBuyMainController () <UITableViewDelegate,UITableViewDataSource,HLHotBuyListViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *placeView; // 占位图

@property (nonatomic, assign) NSInteger page; // page， 默认为1
@property (nonatomic, assign) NSInteger pageSize; // 默认为10

@end

@implementation HLHotBuyMainController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _pageSize = 10;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.view addSubview:self.placeView];
    
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"爆款抢购";
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"添加爆款抢购商品"];
    
    /// 加载数据
    [self loadGoodsList];
    
}

#pragma mark - Private Method

// 重新加载页面数据，page置为1
- (void)reloadListData{
    self.page = 1;
    [self loadGoodsList];
}

// 加载数据
- (void)loadGoodsList{
        
    HLLoading(self.view);
    
    NSDictionary *params = @{
            @"page":@(_page),
        @"pageSize":@(_pageSize)
    };
    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/shopplus/hotgoods/lists";
        request.serverType = HLServerTypeStoreService;
        request.parameters = params;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *models = [HLHotBuyListModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"list"]];
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
    HLHotBuyAddController *addVC = [[HLHotBuyAddController alloc] init];
    addVC.callBack = ^{
        [self reloadListData];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - HLHotBuyListViewCellDelegate

/// 点击更多按钮
- (void)listViewCell:(HLHotBuyListViewCell *)cell moreBtnClick:(HLHotBuyListModel *)goodModel{
    // 判断是否是上架还是
    BOOL showUp = goodModel.on_line == 0;
    NSString *upStateStr = showUp ? @"上架" : @"下架";
    [HLBottomControlView showControlViewWithItemTitles:@[@"微信好友",@"微信朋友圈",@"二维码下载",upStateStr] callBack:^(HLControlType type) {
        if (type == HLControlTypeStateDown || type == HLControlTypeStateUp) {
            [self changeUpStatesWithGoodModel:goodModel cell:cell];
            return;
        }
        if(type == HLControlTypeWXChat || type == HLControlTypeWXCycle){
            
            if (![[HLPayManage shareManage].wxManage wxAppIsInstalled]) {
                HLShowText(@"请安装微信客户端");
                return;
            }
            
            [self loadWXShareDataWithProId:goodModel.pid isChat:type == HLControlTypeWXChat];
            return;
        }
        if (type == HLControlTypeQRCode) {
            [self dowonLoadQRCodeWithId:goodModel.pid];
        }
    }];
}

//下载二维码
- (void)dowonLoadQRCodeWithId:(NSString *)Id {
    [HLTools saveQRCodeWithId:Id type:5 controller:self completion:^(NSDictionary *data) {
        NSDictionary *pargram = @{
            @"codeImgUrl": data[@"erweimaUrl"]?:@"",
              @"navTitle": @"二维码下载",
        };
        [HLTools pushAppPageLink:@"HLMatterCodeController" params:pargram needBack:false];
    }];
}

/// 分享到朋友圈还是好友
- (void)loadWXShareDataWithProId:(NSString *)proId isChat:(BOOL)isChat{
    if (isChat) {
        [HLTools shareWithId:proId type:5 controller:self completion:^(NSDictionary *dict) {
            [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"pic"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                dispatch_main_async_safe(^{
                    [HLWXManage shareToWXWithMiniProgramUserName:WX_MINIPAGRAM_USERNAME title:dict[@"title"] description:@"" image:image webpageUrl:dict[@"link"] path:dict[@"path"]];
                });
            }];
        }];
        return;
    }
    
    [HLTools shareImageWithId:proId type:5 controller:self completion:^(NSDictionary * dict) {
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"imgUrl"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            dispatch_main_async_safe(^{
                [HLWXManage shareToWXWithImage:image scene:HLSceneTimeline];
            });
        }];
    }];
}

/// 改变上下架的状态
- (void)changeUpStatesWithGoodModel:(HLHotBuyListModel *)goodModel cell:(HLHotBuyListViewCell *)cell {
    BOOL showUp = goodModel.on_line == 0;
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/shopplus/hotgoods/saveGoodsStatus";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"pid":goodModel.pid,@"status":@(showUp ? 1 : 0)};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            goodModel.on_line = [responseObject.data[@"on_line"] integerValue];
            goodModel.state = responseObject.data[@"state"];;
            [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLHotBuyListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHotBuyListViewCell" forIndexPath:indexPath];
    cell.listModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

// 构建底部的view
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
        _tableView.rowHeight = FitPTScreen(130);
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(10))];
        [_tableView registerClass:[HLHotBuyListViewCell class] forCellReuseIdentifier:@"HLHotBuyListViewCell"];
        weakify(self);
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.page = 1;
            [weak_self loadGoodsList];
        }];
        mj_header.lastUpdatedTimeLabel.hidden = YES;
        
        _tableView.mj_header = mj_header;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.page++;
            [weak_self loadGoodsList];
        }];
        _tableView.mj_footer.hidden = YES;
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
        tipLab.text = @"暂无爆款抢购数据";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(13));
            make.centerX.equalTo(_placeView);
        }];
    }
    return _placeView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

