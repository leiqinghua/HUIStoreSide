//
//  HLHotSekillDetailController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLHotSekillDetailController.h"
#import "HLHotSekillDetailViewCell.h"
#import "HLDownSelectView.h"
#import "HLHotSekillImageController.h"
#import "HLHotSekillPickImageController.h"

@interface HLHotSekillDetailController () <UITableViewDelegate,UITableViewDataSource,HLHotSekillDetailViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

// 缓存的单位数据
@property (nonatomic, copy) NSArray *cacheUnitArr;

// 提供下拉选择的单位数据
@property (nonatomic, copy) NSArray *unitTitles;

@end

@implementation HLHotSekillDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"套餐详细";
    AdjustsScrollViewInsetNever(self, self.tableView);
    [self creatFootViewWithButtonTitle:@"下一步 上传图册"];
    
    [self loadUnitArr];
}

/// 加载数据
- (void)loadUnitArr{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSide/SetMealUnit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *models = [HLHotSekillDetailUnitModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            self.cacheUnitArr = models;
        }
        [self buildDataSource];
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
        [self buildDataSource];
    }];
}

/// 初始化dataSource的数据
- (void)buildDataSource{
    
    if([HLHotSekillTransporter sharedTransporter].isEdit){
        // 获取编辑时回显的数据
        NSString *detailJSON = [HLHotSekillTransporter sharedTransporter].editModelData[@"setMealDetails"];
        detailJSON = [detailJSON stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSArray *details = [detailJSON mj_JSONObject];
        for (NSDictionary *dict in details) {
            HLHotSekillDetailInputModel *inputModel = [[HLHotSekillDetailInputModel alloc] init];
            inputModel.remark = dict[@"remarks"];
            inputModel.num = [HLTools safeStringObject:dict[@"num"]];
            inputModel.orinalPrice = [HLTools safeStringObject:dict[@"price"]];
            inputModel.contentName = [HLTools safeStringObject:dict[@"name"]];
            inputModel.selectUnit = [self buildNewUnitModelFromCacheWithUnitName:dict[@"unit"]];
            [self.dataSource addObject:inputModel];
        }
    }else{
        HLHotSekillDetailInputModel *inputModel = [[HLHotSekillDetailInputModel alloc] init];
        inputModel.selectUnit = [self buildNewUnitModelFromCacheWithIndex:0];
        [self.dataSource addObject:inputModel];
    }
    
    [self.tableView reloadData];
}


/// 构建一个新的model
- (HLHotSekillDetailUnitModel *)buildNewUnitModelFromCacheWithUnitName:(NSString *)name{
    __block HLHotSekillDetailUnitModel *selectUnitModel = nil;
    [self.cacheUnitArr enumerateObjectsUsingBlock:^(HLHotSekillDetailUnitModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:name]) {
            selectUnitModel = obj;
            *stop = YES;
        }
    }];
    
    if (!selectUnitModel) {
        selectUnitModel = [self buildNewUnitModelFromCacheWithIndex:0];
    }
    
    return selectUnitModel;
}

/// 构建一个新的model
- (HLHotSekillDetailUnitModel *)buildNewUnitModelFromCacheWithIndex:(NSInteger)index{
    if (index >= self.cacheUnitArr.count) {
        index = 0;
    }
    HLHotSekillDetailUnitModel *newUnitModel = [HLHotSekillDetailUnitModel new];
    HLHotSekillDetailUnitModel *cacheUnitModel = self.cacheUnitArr[index];
    newUnitModel.Id = cacheUnitModel.Id;
    newUnitModel.name = cacheUnitModel.name;
    return newUnitModel;
}

/// 添加一个新的
- (void)addButtonClick{
    // 默认有一个
    HLHotSekillDetailInputModel *inputModel = [[HLHotSekillDetailInputModel alloc] init];
    inputModel.selectUnit = [self buildNewUnitModelFromCacheWithIndex:0];
    [self.dataSource addObject:inputModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    // 滚动到这个
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

/// 保存
- (void)saveButtonClick{
    
    // 如果此时没有数据，就提示
    if (self.dataSource.count == 0) {
        HLShowHint(@"请添加秒杀套餐", self.view);
        return;
    }
    
    // 提出数据
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        HLHotSekillDetailInputModel *inputModel = self.dataSource[i];
        NSDictionary *params = [inputModel buildParams];
        
        if (inputModel.contentName.length == 0) {
            NSString *tip = [NSString stringWithFormat:@"第%ld条信息，请输入名称",i + 1];
            HLShowHint(tip, self.view);
            return;
        }
        
        if (inputModel.num.length == 0) {
            NSString *tip = [NSString stringWithFormat:@"第%ld条信息，请输入数量",i + 1];
            HLShowHint(tip, self.view);
            return;
        }
        
        if (inputModel.num.integerValue == 0) {
            NSString *tip = [NSString stringWithFormat:@"第%ld条信息，数量应大于0",i + 1];
            HLShowHint(tip, self.view);
            return;
        }
        
        if (inputModel.orinalPrice.length == 0) {
            NSString *tip = [NSString stringWithFormat:@"第%ld条信息，请输入价格",i + 1];
            HLShowHint(tip, self.view);
            return;
        }
        
        if (inputModel.orinalPrice.doubleValue <= 0) {
            NSString *tip = [NSString stringWithFormat:@"第%ld条信息，价格应大于0",i + 1];
            HLShowHint(tip, self.view);
            return;
        }
        
        if (!params) {
            HLShowHint(@"填写信息不完整", self.view);
            return;
        }
        
        [mArr addObject:params];
    }
    
    // 设置参数
    [[HLHotSekillTransporter sharedTransporter] appendParams:@{@"setMealDetails":[mArr mj_JSONString]}];
    HLHotSekillPickImageController *imageVC = [[HLHotSekillPickImageController alloc]init];
    [self.navigationController pushViewController:imageVC animated:YES];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(110), ScreenW, FitPTScreen(110))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(110));
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(FitPTScreen(-4));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButton = [[UIButton alloc] init];
    [footView addSubview:addButton];
    [addButton setBackgroundImage:[UIImage imageNamed:@"buygoods_bottom_add"] forState:UIControlStateNormal];
    [addButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(saveButton.top).offset(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(157));
        make.height.equalTo(FitPTScreen(34));
    }];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - HLHotSekillDetailViewCellDelegate

/// 删除
-(void)detailViewCell:(HLHotSekillDetailViewCell *)cell deleteInputModel:(HLHotSekillDetailInputModel *)inputModel{
    
    // 如果此时只有一个就不能删除了
    if (self.dataSource.count == 1) {
        HLShowHint(@"最少保留一个套餐", self.view);
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

/// 下拉框
-(void)detailViewCell:(HLHotSekillDetailViewCell *)cell showSelectDownView:(UIView *)dependView{
    [self.view endEditing:YES];
    HLHotSekillDetailInputModel *inputModel = cell.inputModel;
    [HLDownSelectView showSelectViewWithTitles:self.unitTitles itemHeight:FitPTScreen(35) dependView:dependView showType:HLDownSelectTypeAuto maxNum:5 callBack:^(NSInteger index) {
        HLHotSekillDetailUnitModel *unitModel = [self buildNewUnitModelFromCacheWithIndex:index];
        inputModel.selectUnit = unitModel;
        [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLHotSekillDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHotSekillDetailViewCell" forIndexPath:indexPath];
    cell.inputModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = FitPTScreen(255);
        [_tableView registerClass:[HLHotSekillDetailViewCell class] forCellReuseIdentifier:@"HLHotSekillDetailViewCell"];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSArray *)cacheUnitArr{
    if (!_cacheUnitArr) {
        NSArray *unitDicts = @[@{@"Id":@"1",@"name":@"份"},@{@"Id":@"2",@"name":@"斤"},@{@"Id":@"3",@"name":@"杯"},@{@"Id":@"4",@"name":@"只"}];
        NSArray *models = [HLHotSekillDetailUnitModel mj_objectArrayWithKeyValuesArray:unitDicts];
        _cacheUnitArr = models;
    }
    return _cacheUnitArr;
}

-(NSArray *)unitTitles{
    if (!_unitTitles) {
        
        NSMutableArray *titles = [NSMutableArray array];
        for (HLHotSekillDetailUnitModel *unitModel in self.cacheUnitArr) {
            [titles addObject:unitModel.name];
        }
        
        _unitTitles = [titles copy];
    }
    return _unitTitles;
}

@end
