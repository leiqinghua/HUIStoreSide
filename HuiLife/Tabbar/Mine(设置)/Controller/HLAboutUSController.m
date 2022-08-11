//
//  HLAboutUSController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/24.
//

#import "HLAboutUSController.h"
#import "HLAboutUsHeaderView.h"
#import "HLAboutUsTableViewCell.h"

@interface HLAboutUSController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _phoneNum;
}

@property(strong,nonatomic)UITableView * tableView;

@property (strong,nonatomic)NSMutableArray * dataSource;

@end

@implementation HLAboutUSController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"关于"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self loadData];
}

-(void)initSubView{
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor hl_StringToColor:@"#FAFAFA"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[HLAboutUsTableViewCell class] forCellReuseIdentifier:@"HLAboutUsTableViewCell"];
    
    HLAboutUsHeaderView *headerView = [[HLAboutUsHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(210))];
    _tableView.tableHeaderView = headerView;
    
    UILabel * companyName = [[UILabel alloc]init];
    companyName.text = @"北京智优惠生活科技有限公司";
    companyName.textColor = UIColorFromRGB(0x656565);
    companyName.font = [UIFont systemFontOfSize:FitPTScreenH(12)];
    [self.view addSubview:companyName];
    [companyName makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(FitPTScreen(-26));
    }];
    
    UIView * lineLeft = [[UIView alloc]init];
    lineLeft.backgroundColor = UIColorFromRGB(0x656565);
    [self.view addSubview:lineLeft];
    [lineLeft makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(companyName.mas_left).offset(FitPTScreen(-10));
        make.centerY.equalTo(companyName);
        make.width.equalTo(FitPTScreen(30));
        make.height.equalTo(FitPTScreen(1));
    }];
    
    UIView * lineRight = [[UIView alloc]init];
    lineRight.backgroundColor = UIColorFromRGB(0x656565);
    [self.view addSubview:lineRight];
    [lineRight makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyName.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(companyName);
        make.width.equalTo(FitPTScreen(30));
        make.height.equalTo(FitPTScreen(1));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLAboutUsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLAboutUsTableViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.info = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitPTScreenH(50);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = self.dataSource[indexPath.row];
    if ([dict[@"title"] isEqualToString:@"咨询电话"] && _phoneNum.length) {
       [HLTools callPhone:_phoneNum?:@"010-52579239"];
        return;
    }
    
    if ([dict[@"title"] isEqualToString:@"版本更新"]&& [HLAccount shared].isUpdate) {
        [HLTools gotoAppstore];
    }
    
}


-(void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/shopplus/Customerservice/index";
        request.serverType = HLServerTypeStoreService;
        request.parameters =@{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleData:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
    
}

-(void)handleData:(NSDictionary *)dict{
    
    NSString * qq = dict[@"qq"];
    NSString * tel = dict[@"tel"];
//    NSString * time = dict[@"time"];
    
    _phoneNum = tel;
    
    if (tel.length) {
        NSDictionary * phone = @{@"title":@"咨询电话",@"value":tel};
        [self.dataSource addObject:phone];
    }
    
    if (qq.length) {
       NSDictionary * qqData = @{@"title":@"企业QQ",@"value":qq};
       [self.dataSource addObject:qqData];
    }
    NSDictionary * update = @{@"title":@"版本更新",@"value":[HLAccount shared].isUpdate?@"去更新":@"无新版本"};
    [self.dataSource addObject:update];
    
    [self.tableView reloadData];
}


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
