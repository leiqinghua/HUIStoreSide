//
//  HLEntryViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import "HLEntryViewController.h"
#import "HLFinanceTableViewCell.h"
#import "HLFinanceViewController.h"

@interface HLEntryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UILabel *money;

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *dataSource;

@property(strong,nonatomic)UILabel *balance;//可用余额

@property(strong,nonatomic)UILabel *tixianMoney;//已提现

@property(assign,nonatomic)NSInteger page;

@property(strong,nonatomic)NSMutableArray* priceViews;

@end

@implementation HLEntryViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"已结算" andTitleColor:UIColor.whiteColor];
    [self hl_setBackImage:@"back_white"];
    [self hl_setTransparentNavtion];
    [self hl_interactivePopGestureRecognizerUseable];
    
}


-(void)hl_goback{
    for (HLBaseViewController * vc  in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"HLFinanceViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF6F6F6);
    
    _page = 1;
    
    [self loadDataWithLoading:YES];
}

-(void)initSubView{
    
    if (_tableView) return;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(250) + HIGHT_NavBar_MARGIN)];
    imageView.image = [UIImage imageNamed:@"bag_tx_header"];
    [self.view addSubview:imageView];
    
    _money = [[UILabel alloc]init];
    _money.textAlignment = NSTextAlignmentCenter;
    _money.font = [UIFont systemFontOfSize:FitPTScreen(30)];
    _money.textColor = UIColorFromRGB(0xFFFFFF);
    [imageView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(FitPTScreen(102) + HIGHT_NavBar_MARGIN);
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = FitPTScreen(75);
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[HLFinanceTableViewCell class] forCellReuseIdentifier:@"HLFinanceTableViewCell"];
    _tableView.tableHeaderView = imageView;
    AdjustsScrollViewInsetNever(self,_tableView);

    _priceViews = [NSMutableArray array];
    NSArray * titles = @[@"待提现",@"提现结算",@"签约银行卡结算"];
    CGFloat width = ScreenW / 3;
    for (int i =0 ; i<titles.count; i++) {
        UIView * tapView = [self viewWithTitle:titles[i]];
        [imageView addSubview:tapView];
        [tapView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(width * i);
            make.top.equalTo(_money.bottom).offset(FitPTScreen(30));
            make.width.equalTo(width);
            make.height.equalTo(FitPTScreen(50));
        }];
        
        if (i < titles.count-1) {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = UIColor.whiteColor;
            [tapView addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.height.equalTo(tapView);
                make.width.equalTo(FitPTScreen(0.7));
            }];
        }
        [_priceViews addObject:tapView];
    }
    
    
    //添加header
    [_tableView headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadDataWithLoading:false];
    }];
    

    [_tableView footerWithEndText:@"没有更多数据" refreshingBlock:^{
        self.page ++;
        [self loadDataWithLoading:false];
    }];
    
    
    [HLEmptyDataView emptyViewWithFrame:CGRectMake(0, FitPTScreenH(250), ScreenW, ScreenH-FitPTScreenH(250)) superView:_tableView type:@"0" balock:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLFinanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLFinanceTableViewCell" forIndexPath:indexPath];
    cell.entriedModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(UIView *)viewWithTitle:(NSString *)title{
    UIView * view = [[UIView alloc]init];
    
    UILabel *topLb = [[UILabel alloc]init];
    topLb.text = title;
    topLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    topLb.textColor = UIColor.whiteColor;
    [view addSubview:topLb];
    [topLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(6));
        make.centerX.equalTo(view);
    }];
    
    UILabel * moneyLb = [[UILabel alloc]init];
    moneyLb.tag = 1000;
    moneyLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    moneyLb.textColor = UIColor.whiteColor;
    [view addSubview:moneyLb];
    [moneyLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(topLb.bottom).offset(FitPTScreen(10));
    }];
    
    return view;
}

#pragma mark -request
-(void)loadDataWithLoading:(BOOL)loading{
    
    if (loading)HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/MerchantWiths.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"page":@(self.page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleDataWithModel:result.data];
            return;
        }
        if (self.page > 1) self.page -- ;
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        if (self.page > 1) self.page -- ;
    }];
}

-(void)handleDataWithModel:(NSArray *)datas{
 
    [self initSubView];
    
    NSDictionary * dict = datas.firstObject;
    
//    已结算
    _money.text = dict[@"yrz_money"];
    
    
//    待提现
    NSString * dtxPrince = dict[@"ktx_money"];
    
    UIView * first = self.priceViews.firstObject;
    UILabel * moneyLb = [first viewWithTag:1000];
    moneyLb.text = dtxPrince;
    
    
//    提现结算(待接口修改)
    NSString * jsPrince = dict[@"finish_money"];
    UIView * jsView = self.priceViews[1];
    UILabel * jsLb = [jsView viewWithTag:1000];
    jsLb.text = jsPrince;
    
//签约银行卡
    NSString * cardPrince = dict[@"settlement"];
    UIView * cardView = self.priceViews.lastObject;
    UILabel * cardLb = [cardView viewWithTag:1000];
    cardLb.text = cardPrince;
    
    if (_page == 1) {
        [self.dataSource removeAllObjects];
    }
    
    NSArray * models = [HLEntriedModel mj_objectArrayWithKeyValuesArray:dict[@"info"]];
    [self.dataSource addObjectsFromArray:models];
    
    if (models.count==0) {
        [self.tableView endNomorData];
    }
    if (self.dataSource.count > 0) {
        [self.tableView removeEmptyView];
    }
    [self.tableView reloadData];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    UIColor * color = [UIColor hl_StringToColor:@"#FF8D26"];
    if (offset<0) {
        [self hl_GradientColor:[color colorWithAlphaComponent:0]];
        CGFloat alpha = 1+offset/Height_NavBar;
        [self hl_setTitle:@"已结算" andTitleColor:[UIColor.whiteColor colorWithAlphaComponent:alpha]];
    }else{
        CGFloat alpha=1-((Height_NavBar-offset)/Height_NavBar);
        [self hl_GradientColor:[color colorWithAlphaComponent:alpha]];
        [self hl_setTitle:@"已结算" andTitleColor:[UIColor.whiteColor colorWithAlphaComponent:1]];
    }
}


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
