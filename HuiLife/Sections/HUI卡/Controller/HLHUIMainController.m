//
//  HLHUIMainController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/22.
//

#import "HLHUIMainController.h"
#import "HLHUIMainTableCell.h"
#import "HLBottomControlView.h"
#import "HLHUIMainInfo.h"
#import "HLCardSecretController.h"
#import "HLHUIAddController.h"
#import "HLBuyCardViewController.h"

@interface HLHUIMainController ()<UITableViewDelegate, UITableViewDataSource, HLHUIMainTableCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) UIView *noDataView;
@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, strong) UIView *tipView;
@property(nonatomic, strong) UIView *bottomView ;
@property (nonatomic, copy) NSString *tips; // 用来标记是否可以进入购卡
@end

@implementation HLHUIMainController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"锁客会员卡"];
    [self hl_setBackImage:@"back_black"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购卡" style:UIBarButtonItemStyleDone target:self action:@selector(buyCard)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    _page = 1;
    [self loadListWithHud:YES];
    [HLNotifyCenter addObserver:self selector:@selector(reloadPageData) name:HLReloadHUIMainListNotifi object:nil];
}

#pragma mark - Request
- (void)loadListWithHud:(BOOL)hud {
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/ListCard.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"pageNo":@(_page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            self.tips = result.data[@"tips"];
            [self handleList:result.data[@"cards"]];
            return;
        }
        if (self.page > 1) self.page--;
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        if (self.page > 1) self.page--;
    }];
}

- (void)handleList:(NSArray *)list {
    NSArray *datas = [HLHUIMainInfo mj_objectArrayWithKeyValuesArray:list];
    if (_page == 1) [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:datas];
    [self showNodataView:!self.datasource.count];
    [self.tableView reloadData];
    [self showTipView:self.datasource.count >=1];
    [self showBottomView:!self.datasource.count];
    
}

//上架，下架，删除
/**
 1,要上架
 2,要下架
 10,要删除
 */
- (void)modifyStatuWithType:(NSInteger)type cardInfo:(HLHUIMainInfo *)cardInfo{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/CardState.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"cardId":cardInfo.cardId,@"action":@(type)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleStatuWithInfo:cardInfo type:type];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleStatuWithInfo:(HLHUIMainInfo *)cardInfo type:(NSInteger)type{
    if (type == 1) cardInfo.state = 0;
    if (type == 2) cardInfo.state = 1;
    if (type == 10) {
        [self.datasource removeObject:cardInfo];
        [self showTipView:self.datasource.count >=1];
        [self showBottomView:!self.datasource.count];
        [self showNodataView:!self.datasource.count];
    }
    [self.tableView reloadData];
}

#pragma mark - Event
- (void)reloadPageData {
    self.page = 1;
    [self loadListWithHud:NO];
}

// 购卡按钮
- (void)buyCard{
    if (self.tips && self.tips.length > 0) {
        [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:self.tips buttonTitles:@[@"知道了"] buttonColors:@[UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {

        }];
        return;
    }
    
    HLBuyCardViewController *buyCard = [[HLBuyCardViewController alloc] init];
    buyCard.buySuccessBlock = ^{
        [self reloadPageData];
    };
    [self hl_pushToController:buyCard];
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show{
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.backgroundColor = UIColor.whiteColor;
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_hui_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(228));
            make.centerX.equalTo(self.noDataView);
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"暂无进行中的HUI卡";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    _noDataView.hidden = !show;
}

- (void)showTipView:(BOOL)show {
    if (show && !_tipView) {
        _tipView = [[UIView alloc]init];
        _tipView.backgroundColor = UIColorFromRGB(0xFFFEF8);
        _tipView.layer.borderColor = UIColorFromRGB(0xFADBAE).CGColor;
        _tipView.layer.borderWidth = 0.5;
        _tipView.layer.cornerRadius = FitPTScreen(8);
        [self.view addSubview:_tipView];
        [_tipView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(12));
            make.right.equalTo(FitPTScreen(-12));
            make.bottom.equalTo(-FitPTScreen(11)-Height_Bottom_Margn);
            make.height.equalTo(FitPTScreen(131));
        }];
        
        UILabel *tipLb = [[UILabel alloc]init];
        tipLb.numberOfLines = 0;
        tipLb.textColor = UIColorFromRGB(0xFF9900);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [_tipView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(20));
            make.centerX.equalTo(_tipView);
        }];
        
        NSString *tipText = @"温馨提示：仅限开启一张锁客卡，商家可不定期修改卡权\n益，修改权益后仅新用户尊享，老用户权益不变。";
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5;
        NSAttributedString *tipAttr = [[NSAttributedString alloc]initWithString:tipText attributes:@{NSParagraphStyleAttributeName:style}];
        tipLb.attributedText = tipAttr;
        
        UIButton *bottomBtn = [[UIButton alloc]init];
        bottomBtn.layer.cornerRadius = FitPTScreen(10);
        bottomBtn.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [bottomBtn setTitle:@"仅限商家开启一张锁客会员卡" forState:UIControlStateNormal];
        [bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [_tipView addSubview:bottomBtn];
        [bottomBtn makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(FitPTScreen(-15));
            make.centerX.equalTo(_tipView);
            make.size.equalTo(CGSizeMake(FitPTScreen(260), FitPTScreen(41)));
        }];
    }
    _tipView.hidden = !show;
}


- (void)showBottomView:(BOOL)show {
    if (!_bottomView && show) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), ScreenW, FitPTScreen(100))];
        _bottomView.backgroundColor = UIColor.clearColor;
        [self.view addSubview:_bottomView];
        UIButton *addBtn = [[UIButton alloc] init];
        [_bottomView addSubview:addBtn];
        [addBtn setTitle:@"添加会员卡" forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"button_bag"] forState:UIControlStateNormal];
        [addBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(FitPTScreen(-25));
        }];
        [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _bottomView.hidden = !show;
}

/// 分享到朋友圈还是好友
- (void)loadWXShareDataWithProId:(NSString *)proId isChat:(BOOL)isChat{
    if (isChat) {
        [HLTools shareWXWithId:proId controller:self completion:^(NSDictionary * _Nonnull dict) {
            NSDictionary *dataDict = dict[@"share"];
            [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dataDict[@"icon"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                dispatch_main_async_safe(^{
                    [HLWXManage shareToWXWithTitle:dataDict[@"title"] description:dataDict[@"desc"] image:image link:dataDict[@"url"] scene:HLSceneSession];
                });
            }];
        }];
        
        return;
    }
    
    [HLTools shareWXWithId:proId controller:self completion:^(NSDictionary * _Nonnull dict) {
        NSDictionary *dataDict = dict[@"share"];
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dataDict[@"icon"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            dispatch_main_async_safe(^{
                [HLWXManage shareToWXWithTitle:dataDict[@"title"] description:dataDict[@"desc"] image:image link:dataDict[@"url"] scene:HLSceneTimeline];
            });
        }];
    }];
}

//生成卡密
- (void)createSceretWithInfo:(HLHUIMainInfo *)info {
    HLCardSecretController *secretVC = [[HLCardSecretController alloc]init];
    secretVC.cardId = info.cardId;
    [self hl_pushToController:secretVC];
}

//修改HUI卡
- (void)modifyCardWithInfo:(HLHUIMainInfo *)info {
    HLHUIAddController *addVC = [[HLHUIAddController alloc]init];
    addVC.cardId = info.cardId;
    [self hl_pushToController:addVC];
}

//删除HUI卡
- (void)deleteCardWithInfo:(HLHUIMainInfo *)info {
    [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:@"是否确定删除HUI卡" buttonTitles:@[@"取消",@"确定"] buttonColors:@[UIColorFromRGB(0x9A9A9A),UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
        if (index == 1) {
            [self modifyStatuWithType:10 cardInfo:info];
        }
    }];
}
//上下架HUI卡
- (void)downOrUpCardWithInfo:(HLHUIMainInfo *)info {
    NSInteger type = info.state == 0?2:1;
    [self modifyStatuWithType:type cardInfo:info];
}

#pragma mark - Event
//添加会员卡
- (void)addClick {
    [HLTools pushAppPageLink:@"HLHUIAddController" params:@{} needBack:NO];
}

#pragma mark - HLHUIMainTableCellDelegate
//点击更多
- (void)mainCell:(HLHUIMainTableCell *)cell moreWithInfo:(HLHUIMainInfo *)info {
    NSString *upDownStr = info.state == 0?@"下架":@"上架";
    [HLBottomControlView showControlViewWithItemTitles:@[@"删除",@"修改",@"生成卡密",upDownStr] callBack:^(HLControlType type) {
        switch (type) {
            case HLControlTypeWXCycle:case HLControlTypeWXChat: //朋友圈
            {
                if (![[HLPayManage shareManage].wxManage wxAppIsInstalled]) {
                    HLShowText(@"请安装微信客户端");
                    return;
                }
                [self loadWXShareDataWithProId:info.cardId isChat:type == HLControlTypeWXChat];
            }break;
            case HLControlTypeDeleteCard: //删除HUI卡
                [self deleteCardWithInfo:info];
                break;
            case HLControlTypeEditCard: //修改HUI卡
                [self modifyCardWithInfo:info];
                break;
            case HLControlTypeCreateCard: //生成卡密
                [self createSceretWithInfo:info];
                break;
            case HLControlTypeStateDown:case HLControlTypeStateUp: //下架HUI卡
                [self downOrUpCardWithInfo:info];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLHUIMainTableCell *cell = (HLHUIMainTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLHUIMainTableCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.info = self.datasource[indexPath.row];
    return cell;
}

#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(100))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = FitPTScreen(108);
    _tableView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
//    [_tableView footerWithEndText:@"暂无更多数据" refreshingBlock:^{
//        self.page ++;
//        [self loadListWithHud:NO];
//    }];
    [_tableView hideFooter:YES];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)dealloc {
    [HLNotifyCenter removeObserver:self];
}
@end
