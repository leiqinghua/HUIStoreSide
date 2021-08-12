//
//  HLFunctionController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/30.
//

#import "HLFunctionController.h"
#import "HLFunctionViewCell.h"

@interface HLFunctionController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;

@property(nonatomic,strong) UILabel * tipLb;

@property(nonatomic,strong) NSArray * datasource;

@property(nonatomic,strong) UIView *section1Header;


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



#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.datasource[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLFunctionViewCell * cell = [HLFunctionViewCell dequeueReusableCell:tableView];
    cell.model = self.datasource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLFunctionModel * model = self.datasource[indexPath.row];
    if (!model.iosArdess.length) {
        HLShowHint(@"敬请期待", self.view);
        return;
    }
#if DEBUG
    [HLTools pushAppPageLink:model.iosArdess params:model.androidParam needBack:false];
#else
    [HLTools pushAppPageLink:model.iosArdess params:model.iosParam needBack:false];
#endif
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.datasource.count > 1 && section == 1) {
        return FitPTScreen(47);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    return self.section1Header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
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
    
    NSMutableArray *mArr = [HLFunctionModel mj_objectArrayWithKeyValuesArray:dict[@"items"]];
    NSMutableArray *mDataSource = [NSMutableArray array];
    if (mArr.count > 0) {
        [mDataSource addObject:@[mArr.firstObject]];
        [mArr removeObjectAtIndex:0];
        [mDataSource addObject:mArr];
        self.datasource = [mDataSource copy];
    }
    [self.tableView reloadData];
}
    
#pragma mark - Getter
    
- (UIView *)section1Header{
    if (!_section1Header) {
        _section1Header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(47))];
        
        UILabel *centerTipLab = [[UILabel alloc] init];
        centerTipLab.text = @"超级获客推广";
        centerTipLab.textColor = UIColorFromRGB(0x888888);
        centerTipLab.textAlignment = NSTextAlignmentCenter;
        centerTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [_section1Header addSubview:centerTipLab];
        [centerTipLab makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_section1Header);
            make.width.equalTo(FitPTScreen(85));
            make.height.equalTo(_section1Header);
        }];
        
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [_section1Header addSubview:leftLine];
        [leftLine makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_section1Header);
            make.width.equalTo(FitPTScreen(32.5));
            make.height.equalTo(FitPTScreen(0.5));
            make.right.equalTo(centerTipLab.left).offset(FitPTScreen(-7));
        }];
        
        UIView *rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [_section1Header addSubview:rightLine];
        [rightLine makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_section1Header);
            make.width.equalTo(FitPTScreen(32.5));
            make.height.equalTo(FitPTScreen(0.5));
            make.left.equalTo(centerTipLab.right).offset(FitPTScreen(7));
        }];
    }
    return _section1Header;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStylePlain];
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
    


@end
