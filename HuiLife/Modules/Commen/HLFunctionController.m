//
//  HLFunctionController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/30.
//

#import "HLFunctionController.h"
#import "HLFunctionViewCell.h"

@interface HLFunctionController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UILabel * tipLb;

@property(nonatomic,strong)NSArray * datasource;

@end

@implementation HLFunctionController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self loadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.rowHeight = FitPTScreen(96);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        AdjustsScrollViewInsetNever(self, _tableView);
        
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(110))];
        _tableView.tableHeaderView = headerView;
        
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.textColor = UIColorFromRGB(0x666666);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [headerView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(headerView);
        }];
        _tipLb = tipLb;
        
        UIView * leftLine = [[UIView alloc]init];
        leftLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [headerView addSubview:leftLine];
        [leftLine makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tipLb.left).offset(FitPTScreen(-10));
            make.centerY.equalTo(tipLb);
            make.width.equalTo(FitPTScreen(39));
            make.height.equalTo(1);
        }];
        
        UIView * rightLine = [[UIView alloc]init];
        rightLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [headerView addSubview:rightLine];
        [rightLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLb.right).offset(FitPTScreen(10));
            make.centerY.equalTo(tipLb);
            make.width.equalTo(FitPTScreen(39));
            make.height.equalTo(1);
        }];
        
    }
    return _tableView;
}




#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLFunctionViewCell * cell = [HLFunctionViewCell dequeueReusableCell:tableView];
    cell.model = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLFunctionModel * model = self.datasource[indexPath.row];
    if (!model.iosArdess.length) {
        HLShowHint(@"敬请期待", self.view);
        return;
    }
    
    [HLTools pushAppPageLink:model.iosArdess params:model.iosParam needBack:false];
}

-(void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Menulist/MenuList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"type":@(_type)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self.view addSubview:self.tableView];
            [self handleDataWithDict:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)handleDataWithDict:(NSDictionary *)dict{
    _tipLb.text = dict[@"title"];
    [self hl_setTitle:dict[@"index"] andTitleColor:UIColorFromRGB(0x333333)];
    
    self.datasource = [HLFunctionModel mj_objectArrayWithKeyValuesArray:dict[@"items"]];
    [self.tableView reloadData];
}

@end
