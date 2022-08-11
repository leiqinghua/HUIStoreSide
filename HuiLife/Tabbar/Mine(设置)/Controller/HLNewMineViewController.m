//
//  HLNewMineViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/21.
//

#import "HLNewMineViewController.h"
#import "HLSettingViewController.h"
#import "HLMineHeaderView.h"
#import "HLNewMineTableViewCell.h"
#import "HLLoginController.h"
#import "HLAboutUSController.h"
#import "HLModifyPasswordController.h"
#import "HLBLEManager.h"
#import "HLMineFooterView.h"
#import "HLActionSheet.h"
#import "HLMineShareView.h"

/**
 在账户有效期前修改数据一定要修改这两个索引值
 */
const NSInteger kTimeModelIndex = 3;
const NSInteger kPrinterModelIndex = 4;

@interface HLNewMineViewController ()<UITableViewDelegate,UITableViewDataSource,HLMineFooterViewDelegate>

@property(strong,nonatomic)UITableView *tableView;

@property (strong,nonatomic)NSMutableArray * dataSource;

@property (strong,nonatomic)UIView * navBarView;
@end

@implementation HLNewMineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTransparentNavtion];
    [self hl_setTitle:@"" andTitleColor:UIColor.whiteColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadMineList];
}

- (void)hl_resetNetworkForAction{
    [super hl_resetNetworkForAction];
    [self loadMineList];
}

- (void)initNavi{
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(40))];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn setTitleColor: UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [setBtn addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initNavBarView{
    _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, Height_NavBar)];
    [self.view addSubview:_navBarView];
    UIImageView * navBagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_nav_bg"]];
    [_navBarView addSubview:navBagView];
    [navBagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navBarView);
    }];
    _navBarView.alpha = 0.0;
}

- (void)initSubViews{
    if (_tableView) return;
    self.view.backgroundColor = UIColor.whiteColor;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - Height_TabBar) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = FitPTScreen(86);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionFooterHeight = 0.01;
    _tableView.sectionHeaderHeight = 0.01;
    AdjustsScrollViewInsetNever(self,_tableView);
    
    HLMineHeaderView *headerView = [[HLMineHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(176)+HIGHT_NavBar_MARGIN)];
    _tableView.tableHeaderView = headerView;
    
    HLMineFooterView * footerView = [[HLMineFooterView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(88))];
    footerView.delegate = self;
    _tableView.tableFooterView = footerView;
    [self.view addSubview:_tableView];
    [self.view bringSubviewToFront:_navBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initNavBarView];

    [self loadMineList];
    //注册刷新界面的通知
    [HLNotifyCenter addObserver:self selector:@selector(reloadUI:) name:HLReloadMineDataNotifi object:nil];
}

#pragma mark -HLMineHeaderViewDelegate
//点击完善资料 去设置页
-(void)headerView:(HLMineHeaderView *)headerView clickCompleteBtn:(UIButton *)button{
    [self settingClick:button];
}

#pragma mark - HLMineFooterViewDelegate
-(void)exitLoginWithButtonClick:(UIButton *)sender{
    [self exitLogin];
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLNewMineTableViewCell * cell = [HLNewMineTableViewCell dequeueReusableCell:tableView];
    cell.mineModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLMineModel *model = self.dataSource[indexPath.row];
    if (!model.iosAddress.length) {
        HLShowHint(@"敬请期待", self.view);
        return;
    }
    
    if ([model.iosAddress isEqualToString:@"share"]) {
        [self share];
        return;
    }
    [HLTools pushAppPageLink:model.iosAddress params:model.iosParam needBack:false];
    
}

#pragma mark - Method
-(void)settingClick:(UIButton *)sender{
    HLSettingViewController * settingVC = [[HLSettingViewController alloc]init];
    [self hl_pushToController:settingVC];
}

-(void)reloadUI:(NSNotification *)sender{
    [self loadMineList];
}

//退出登录
- (void)exitLogin{
    //退出登录
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"退出登录后不会删除任何历史数据，下次登录依然可以使用本账号" preferredStyle:isPad? UIAlertControllerStyleAlert:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancel setValue:UIColorFromRGB(0x999999) forKey:@"titleTextColor"];
    
    UIAlertAction * concern = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[HLAccount shared] exitLogin];
        [HLNotifyCenter postNotificationName:NOTIFY_LOGIN_STATE object:@(NO)];
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:concern];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)share {
    [self shareWithCompletion:^(NSDictionary * dict) {
        [HLMineShareView showShareViewWithCallBack:^(NSInteger type) {
            
            if (![[HLPayManage shareManage].wxManage wxAppIsInstalled]) {
                HLShowText(@"请安装微信客户端");
                return;
            }
            [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"icon"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
               [HLWXManage shareToWXWithTitle:dict[@"title"] description:dict[@"describe"] image:image link:dict[@"url"] scene:type];
            }];
        }];
    }];
}

#pragma mark - 列表
- (void)loadMineList {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/SettingList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        dispatch_main_async_safe(^{
          HLHideLoading(self.view);
        });
        [self initSubViews];
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self hl_hideNetFail];
            [self handleListData:result.data];
            return;
        }
        dispatch_main_async_safe(^{
            [self hl_showNetFail:self.view.bounds callBack:^{
                [self loadMineList];
            }];
        });
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        dispatch_main_async_safe(^{
            [self hl_showNetFail:self.view.bounds callBack:^{
                [self loadMineList];
            }];
        });
    }];
}

- (void)handleListData:(NSDictionary *)data {
    [self.dataSource removeAllObjects];
    
    NSArray *list = [HLMineModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
    [self.dataSource addObjectsFromArray:list];
    [self.tableView reloadData];
    
    
    HLAccount * account = [HLAccount shared];
    [account mj_setKeyValues:data[@"top"]];
    //存本地
    [HLAccount saveAcount];
    
    HLMineHeaderView * headerView = (HLMineHeaderView *)[_tableView tableHeaderView];
    [headerView updateData];
    [headerView configUserTimeTipString:data[@"useTips"]];
}

#pragma mark - share
- (void)shareWithCompletion:(void(^)(NSDictionary *))completion{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/ShopPlus/ShareInfo.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 404) {
            return ;
        }
        if(result.code == 200){
            if (completion)completion(result.data);
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - SET & GET
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     CGFloat offset = self.tableView.contentOffset.y;
       if (offset<=0) {
           _navBarView.alpha = 0.0;
           CGFloat alpha = 1+offset/Height_NavBar;
           [self hl_setTitle:@"" andTitleColor:[UIColor.whiteColor colorWithAlphaComponent:alpha]];
           [self.tableView setContentOffset:CGPointMake(0, 0)];
       }else{
           CGFloat alpha=1-((Height_NavBar-offset)/Height_NavBar);
           _navBarView.alpha = alpha;
           [self hl_setTitle:@"商+号" andTitleColor:[UIColor.whiteColor colorWithAlphaComponent:alpha]];
       }
}

@end
