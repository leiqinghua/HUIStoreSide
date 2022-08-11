//
//  HLSelectMDViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/24.
//

#import "HLSelectMDViewController.h"
#import "HLCustomField.h"

#import "HLStoreSelectViewCell.h"

@interface HLSelectMDViewController ()<UITableViewDelegate,UITableViewDataSource,HLCustomFieldDelegate>

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *selectItems;

@property(strong,nonatomic)NSMutableArray *dataSource;

@property(copy,nonatomic)NSString *keyword;

@property(strong,nonatomic)NSMutableArray *searchArr;

@property(strong,nonatomic)NSIndexPath * defaultIndex;

@end

@implementation HLSelectMDViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"选择所属门店" ];
}


-(void)cancelClick:(UIButton *)sender{
    [self hl_goback];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCancelBtn];
    
    [self createUI];
    
    [self requestMDListWithType:1 success:nil fail:nil];
}


-(void)createCancelBtn{
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBar;
}

-(void)createUI{
    self.view.backgroundColor = UIColor.whiteColor;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, ScreenW, ScreenH-Height_NavBar) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.estimatedRowHeight = 45;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    AdjustsScrollViewInsetNever(self,_tableView);

    [_tableView registerClass:[HLStoreSelectViewCell class] forCellReuseIdentifier:@"HLStoreSelectViewCell"];
    
    UIView * bagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(70))];
    bagView.backgroundColor = UIColor.whiteColor;
    _tableView.tableHeaderView = bagView;

    HLCustomField * searchField = [[HLCustomField alloc]initWithFrame:CGRectMake(FitPTScreen(29), FitPTScreen(16), ScreenW-FitPTScreen(29*2), FitPTScreen(37))];
    searchField.delegate = self;
    searchField.backgroundColor = UIColorFromRGB(0xF7F7F7);
    searchField.layer.cornerRadius = FitPTScreen(19);
    [bagView addSubview:searchField];

}
#pragma UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArr.count>0?self.searchArr.count:self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLStoreModel * model = self.searchArr.count>0?self.searchArr[indexPath.row]:self.dataSource[indexPath.row];
    HLStoreSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLStoreSelectViewCell" forIndexPath:indexPath];
//    cell.select = YES;
    cell.model = model;
    if (_storeId && [_storeId isEqual:model.storeID]) {
        _defaultIndex = indexPath;
        cell.select = YES;
    }else{
        cell.select = false;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (self.selectMD) {
            self.selectMD(self.searchArr.count >0?self.searchArr[indexPath.row]: self.dataSource[indexPath.row]);
        }
        [self hl_goback];
}


#pragma mark - HLCustomFieldDelegate
//点搜索按钮
-(void)customField:(HLCustomField *)field searchWithText:(NSString *)text{
    _keyword = text;
    [self requestMDListWithType:1 success:nil fail:nil];
}


-(void)customField:(HLCustomField *)field searchDidChangeText:(NSString *)text{
    if (![text hl_isAvailable]) {
        [self.searchArr removeAllObjects];
        [self.tableView reloadData];
    }
}

-(void)customFieldShouldBeginEditing{
    _keyword = @"";
}


#pragma mark - request
-(void)dealWithDatasWithData:(NSArray *)datas{
    NSArray * models = [HLStoreModel mj_objectArrayWithKeyValuesArray:datas];
    if (datas.count == 0) {
        [HLTools showWithText:@"门店不存在"];
    }else{
        if ([self.keyword hl_isAvailable]) {
            [self.searchArr addObjectsFromArray:models];
        }else{
          [self.dataSource addObjectsFromArray:models];
        }
    }
    [self.tableView reloadData];
}

-(void)requestMDListWithType:(NSInteger)type success:(void(^)(void))success fail:(void(^)(void))fail{
    [self.searchArr removeAllObjects];
    NSDictionary * pargram = @{
                               @"type":@(type),
                               @"keyword":_keyword?:@"",
                               };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StoreManagement.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray * datas = result.data;
            [self dealWithDatasWithData:datas];
            if (success) success();
            return ;
        }
        if (fail) fail();
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}



-(NSMutableArray *)selectItems{
    if (!_selectItems) {
        _selectItems = [NSMutableArray array];
    }
    return _selectItems;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

@end
