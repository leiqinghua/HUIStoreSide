//
//  HLAddMDViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import "HLAddMDViewController.h"
#import "HLServiceDescripController.h"
#import "HLSelectShowView.h"
#import "HLLBManagerController.h"
#import "QFTimePickerView.h"
#import "HLSelectArea.h"
#import "HLStoreDetailModel.h"
#import "HLStoreDetailTableViewCell.h"

@interface HLAddMDViewController ()<UITableViewDelegate,UITableViewDataSource,HLSelectShowViewDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UIButton *addBtn;
    UIView *selectBagView;
    HLSelectShowView *showView;
}
@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *defaultItems;

//放所有参数
@property(strong,nonatomic)NSMutableDictionary *pargram;

@property(strong,nonatomic)NSDictionary * defaultInfo;

@property(strong,nonatomic)NSMutableArray * first ;

@property(strong,nonatomic)NSMutableArray * second;
//显示日期
@property(copy,nonatomic)NSArray * shop_hours;

@property(copy,nonatomic)NSMutableArray * shop_date;
//筛选的数组
@property(strong,nonatomic)NSArray *showViewdatas;

//选择的类别
@property(copy,nonatomic)NSString *selectClass_id;

@property(strong,nonatomic)NSArray *areas;
//请求的默认值
@property (strong,nonatomic)HLStoreDefaultModel * defaultModel;
//数据源
@property (strong,nonatomic)NSMutableArray * dataSource;

@property (strong,nonatomic)NSIndexPath * showTimeIndex;
@end

@implementation HLAddMDViewController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setBackgroundColor:UIColorFromRGB(0xFF8D26)];
    [self hl_setTitle:@"门店信息设置" andTitleColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;
}

- (void)dealWithDefaultData:(NSArray *)datas{
    NSDictionary * dict = datas.firstObject;
    self.defaultModel = [HLStoreDefaultModel mj_objectWithKeyValues:dict];
    [self createDataSource];
}

- (void)createDataSource{
    HLStoreDetailModel * storeName = [[HLStoreDetailModel alloc]initWithText:@"门店名称" holder:@"请输入门店名称" type:HLStoreDetailDefault];
    storeName.showText = self.defaultModel.name;
    storeName.value = self.defaultModel.name;
    storeName.canEdit =[HLAccount shared].isDZ?NO:YES;
    storeName.pargram = @{@"name":storeName.value};
    [self.pargram addEntriesFromDictionary:storeName.pargram];
    
    HLStoreDetailModel * classes = [[HLStoreDetailModel alloc]initWithText:@"门店类别" holder:@"请选择门店类别" type:HLStoreDetailDefault];
    classes.showText = self.defaultModel.classname;
    classes.value = self.defaultModel.class_id;
    classes.canEdit =NO;
    classes.showGoImg = YES;
    classes.pargram = @{@"class_id":storeName.value};
    [self.pargram addEntriesFromDictionary:classes.pargram];
    
    HLStoreDetailModel * date = [[HLStoreDetailModel alloc]initWithText:@"营业时间" holder:@"请选择营业时间" type:HLStoreDetailDefault];
    date.showText = self.defaultModel.businessHours;
    date.date = self.defaultModel.shop_date;
    date.hours = self.defaultModel.shop_hours;
    date.showGoImg = YES;
    date.pargram = @{@"shop_date":[date.date mj_JSONString],@"shop_hours":[date.hours mj_JSONString]};
    [self.pargram addEntriesFromDictionary:date.pargram];
    
    HLStoreDetailModel * phone = [[HLStoreDetailModel alloc]initWithText:@"联系方式" holder:@"请输入门店联系电话" type:HLStoreDetailDefault];
    phone.showText = self.defaultModel.tel;
    phone.value = self.defaultModel.tel;
    phone.canEdit = [HLAccount shared].isDZ?NO:YES;
    phone.pargram = @{@"tel":phone.value};
    [self.pargram addEntriesFromDictionary:phone.pargram];
    
     HLStoreDetailModel * area = [[HLStoreDetailModel alloc]initWithText:@"所在地区" holder:@"请选择门店地址" type:HLStoreDetailDefault];
    area.showText = self.defaultModel.areaText;
    area.area = self.defaultModel.area_code;
    area.showGoImg = YES;
    area.pargram = @{@"area":[area.area mj_JSONString]};
    [self.pargram addEntriesFromDictionary:area.pargram];
    
    HLStoreDetailModel * address = [[HLStoreDetailModel alloc]initWithText:@"详细地址" holder:@"请输入门店详细地址" type:HLStoreDetailTextView];
    address.showText = self.defaultModel.address;
    address.value = self.defaultModel.address;
    address.canEdit = [HLAccount shared].isDZ?NO:YES;;
    address.pargram = @{@"address":address.value};
    [self.pargram addEntriesFromDictionary:address.pargram];
    
    HLStoreDetailModel * service = [[HLStoreDetailModel alloc]initWithText:@"服务说明" holder:@"请输入服务说明" type:HLStoreDetailDefault];
    service.showText = self.defaultModel.service_des;
    service.value = self.defaultModel.service_des;
    service.showGoImg = YES;
    service.pargram = @{@"service_des":service.value};
    [self.pargram addEntriesFromDictionary:service.pargram];
    
     HLStoreDetailModel * isShow = [[HLStoreDetailModel alloc]initWithText:@"是否对用户显示" holder:@"" type:HLStoreDetailSwitch];
    isShow.value = self.defaultModel.is_show;
    isShow.pargram = @{@"is_show":isShow.value};
    
    
    NSArray * first = @[storeName,classes,date,phone,area,address,service];
    NSArray *second = @[isShow];
    [self.dataSource addObject:first];
    if (![HLAccount shared].isDZ) {
       [self.dataSource addObject:second];
       [self.pargram addEntriesFromDictionary:isShow.pargram];
    }
    [self.tableView reloadData];
}

-(void)requestDZInfo{
    MJWeakSelf;
    [self loadDZData:@"8" success:^(NSArray * datas) {
        [weakSelf dealWithDefaultData:datas];
    } fail:nil];
}


-(void)requestYGInfo{
    MJWeakSelf;
    [self loadData:@"4" success:^(NSArray * datas) {
        [weakSelf dealWithDefaultData:datas];
    } fail:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    if ([self.storeModel hl_isAvailable] ) {
        //请求默认信息
        [self requestYGInfo];
    }
    if (![HLAccount shared].admin) {
        [self requestDZInfo];
    }
}



#pragma mark - UI
-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, ScreenW, ScreenH-Height_NavBar -FitPTScreenH(44)) style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 45;
    AdjustsScrollViewInsetNever(self,_tableView);
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    [_tableView registerClass:[HLStoreDetailTableViewCell class] forCellReuseIdentifier:@"HLStoreDetailTableViewCell"];
    
    addBtn = [[UIButton alloc]init];
    [addBtn setTitle:@"提交" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    addBtn.backgroundColor = UIColorFromRGB(0xFF8D26);
    addBtn.titleLabel.font=[UIFont systemFontOfSize:FitPTScreenH(15)];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addYG) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(FitPTScreenH(44) + Height_Bottom_Margn);
    }];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    AdjustsScrollViewInsetNever(self, self.tableView);
    
}

-(void)addYG{
    [self.view endEditing:YES];
    MJWeakSelf;
    NSString * type = @"2";
    if (_storeModel || ![HLAccount shared].admin) {
        type = @"3";
    }
    if (![self checkInput]) {
        return;
    }
    [self loadData:type success:^(NSArray * datas) {
        if (weakSelf.storeModel || ![HLAccount shared].admin) {
            [HLTools showWithText:@"修改成功"];
        }else{
            [HLTools showWithText:@"添加成功"];
        }
        [weakSelf hl_goback];
        [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadStoreDataNotifi object:nil];
    } fail:nil];
}

-(void)cancelClick:(UIButton *)sender{
    [self hl_goback];
    [self.tableView endEditing:YES];
}
//校验输入的内容是否为空
-(BOOL)checkInput{
    if (![[self.pargram valueForKey:@"name"] hl_isAvailable]) {
        [HLTools showWithText:@"请输入门店名称"];
        return NO;
    }if (![[self.pargram valueForKey:@"shop_hours"] hl_isAvailable] || ![[self.pargram valueForKey:@"shop_date"] hl_isAvailable]) {
        [HLTools showWithText:@"请输入营业时间"];
        return NO;
    }if (![[self.pargram valueForKey:@"tel"] hl_isAvailable]) {
        [HLTools showWithText:@"请输入联系方式"];
        return NO;
    }if (![[self.pargram valueForKey:@"area"] hl_isAvailable]) {
        [HLTools showWithText:@"请选择所在地区"];
        return NO;
    }if (![[self.pargram valueForKey:@"address"] hl_isAvailable]) {
        [HLTools showWithText:@"请输入详细地址"];
        return NO;
    }
    return YES;
}
#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = self.dataSource[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     HLStoreDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLStoreDetailTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    cell.indexPath = indexPath;
    cell.pargram = self.pargram;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return FitPTScreenH(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 5) {
        return FitPTScreenH(69);
    }
    return FitPTScreenH(45);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreenH(10))];
    return footer;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView endEditing:YES];
    MJWeakSelf;
    HLStoreDetailModel * model = self.dataSource[indexPath.section][indexPath.row];
    if ([model.text isEqualToString:@"服务说明"]) {
        HLServiceDescripController * serviceVC= [[HLServiceDescripController alloc]init];
        serviceVC.isService = YES;
        serviceVC.model = model;
        serviceVC.descBlock = ^(NSString *totleText, NSString *showText) {
            model.showText = showText;
            model.value = totleText;
            model.pargram = [NSDictionary dictionaryWithObject:model.value forKey:model.pargram.allKeys.firstObject];
            [weakSelf.pargram addEntriesFromDictionary:model.pargram];
            //刷新某一个cell
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self hl_pushToController:serviceVC];
    }else if ([model.text isEqualToString:@"营业时间"]){
        [self showTimeWithIndex:(indexPath)];
    }else if ([model.text isEqualToString:@"所在地区"]){
        if ([HLAccount shared].isDZ ) {
            return;
        }
        [HLAreaCache loadAreaDataWithCallBack:^(NSArray *areaArr) {
            weakSelf.areas = areaArr;
            HLSelectArea *selectArea = [[HLSelectArea alloc] initWithArr:weakSelf.areas];
            selectArea.block = ^(NSString *timeStr,NSArray*areas) {
                if (timeStr && areas) {
                    model.showText = timeStr;
                    model.area = areas;
                    model.pargram = [NSDictionary dictionaryWithObject:[model.area mj_JSONString] forKey:model.pargram.allKeys.firstObject];
                    [weakSelf.pargram addEntriesFromDictionary:model.pargram];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            };
            [KEY_WINDOW addSubview:selectArea];
        }];
        
    }else if ([model.text isEqualToString:@"门店类别"]){
        if ([HLAccount shared].isDZ) {
            return;
        }
        HLLBManagerController * selectVC = [[HLLBManagerController alloc]init];
        selectVC.isSelect = YES;
        selectVC.class_id = model.value;
        selectVC.selectBlock = ^(NSDictionary *bigClass, NSDictionary *samallClass) {
            NSMutableString * text = [NSMutableString stringWithFormat:@"%@",bigClass[@"classname"]];
            NSString * class_id = bigClass[@"id"];
            if (samallClass) {
                [text appendFormat:@"-%@",samallClass[@"classname"]];
                class_id = samallClass[@"id"];
            }
            model.showText = text;
            model.value = class_id;
            model.pargram = [NSDictionary dictionaryWithObject:model.value forKey:model.pargram.allKeys.firstObject];
            [weakSelf.pargram addEntriesFromDictionary:model.pargram];
            //刷新某一个cell
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self hl_pushToController:selectVC];
    }
    
}

-(void)showTimeWithIndex:(NSIndexPath *)index{
    if (!showView) {
        self.showTimeIndex = index;
        HLStoreDetailModel * model = self.dataSource[index.section][index.row];
        
        selectBagView = [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.frame.origin.y, ScreenW, self.tableView.bounds.size.height)];
        selectBagView.backgroundColor = [UIColor blackColor];
        selectBagView.alpha = 0.5;
        [self.view addSubview:selectBagView];
        
        showView = [[HLSelectShowView alloc]initWithFrame:CGRectMake(0,ScreenH-FitPTScreenH(309), ScreenW, FitPTScreenH(309))];
        [self.view addSubview:showView];
        showView.delegate = self;
        showView.type = HLMDInfoSettingType;
        NSIndexPath *first = [NSIndexPath indexPathForItem:0 inSection:0];
        if (model.date.count > 0) {
            for (NSString * index in model.date) {
                if ([index integerValue] == 8) {
                    [showView.selectItems addObject:first];
                }else{
                    NSIndexPath *path = [NSIndexPath indexPathForItem:[index integerValue] inSection:0];
                    [showView.selectItems addObject:path];
                }
            }
        }else{
            [showView.selectItems addObject:first];
        }
        showView.timeAtSection = 1;
        showView.isDate = NO;
        showView.timetitles = @[@"开店时间",@"闭店时间"];
        if (model.hours.count > 0) {
            showView.beginAndEnd = model.hours;
        }
        showView.dataSource = [NSMutableArray arrayWithArray:self.showViewdatas];
    }
}

#pragma HLSelectShowViewDelegate

-(void)cancelBtn:(UIButton *)sender{
    [self removeSubview];
}

-(void)concernBtn:(UIButton *)sender selectItems:(NSMutableArray *)items begin:(NSString *)begin end:(NSString *)end{
    
    if (![begin hl_isAvailable]) {
        [HLTools showWithText:@"请选择开店时间"];
        return;
    }else if(![end hl_isAvailable]){
        [HLTools showWithText:@"请选择闭店时间"];
        return;
    }
    
    [self.shop_date removeAllObjects];
    
    HLStoreDetailModel * model = self.dataSource[self.showTimeIndex.section][self.showTimeIndex.row];
    
    NSDictionary * dict =  showView.dataSource[0];
    NSArray * datas = dict[@"datas"];
    //显示的字符串
    NSMutableString * timeText = [NSMutableString string];
    
    for (NSIndexPath * indexpath in items) {
        [timeText appendFormat:@"%@",(NSString *)datas[indexpath.row]];
        if (indexpath.section == 0) {
            if (indexpath.row == 0) {
                [self.shop_date addObject:@"8"];
            }else{
                [self.shop_date addObject:[NSString stringWithFormat:@"%ld",indexpath.row]];
            }
        }
    }

    if ([begin hl_isAvailable] && [end hl_isAvailable]) {
        [timeText appendFormat:@" %@-%@",begin,end];
        _shop_hours = @[begin,end];
    }
    
    model.showText = timeText;
    model.date = self.shop_date;
    model.hours = _shop_hours;
    model.pargram = @{@"shop_date":[model.date  mj_JSONString],@"shop_hours":[model.hours mj_JSONString]};
    [self.pargram addEntriesFromDictionary:model.pargram];

    //刷新某一个cell
    [self.tableView reloadRowsAtIndexPaths:@[self.showTimeIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self removeSubview];
}

-(void)didSelectTimeWithTag:(NSInteger)tag{
    QFTimePickerView *pickerView = [[QFTimePickerView alloc]initDatePackerWithStartHour:@"00" endHour:@"24" period:1 response:^(NSString *str) {
        NSString *string = str;
        NSDictionary * timedic = @{[NSString stringWithFormat:@"%ld",tag]:string};
        [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadShowTimeNotifi object:timedic];
        NSLog(@"str = %@",string);
    }];
    [pickerView show];
}

-(void)removeSubview{
    [showView removeFromSuperview];
    [selectBagView removeFromSuperview];
    showView = nil;
    selectBagView = nil;
    self.tableView.scrollEnabled = YES;
}

-(void)concernBtn:(UIButton *)sender{
    
}

#pragma Request

-(void)loadData:(NSString *)type success:(void(^)(NSArray *))success fail:(void(^)(NSArray *))fail{
    [self.pargram setObject:type forKey:@"type"];
    if (![type isEqualToString:@"2"]) {
        [self.pargram setObject:([HLAccount shared].admin?_storeModel.storeID: _defaultInfo[@"id"]) forKey:@"sid"];
    }
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StoreEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            if (success) success(result.data);
            return;
        }
        if (fail) fail(result.data);
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
    
    
}


-(void)loadDZData:(NSString *)type success:(void(^)(NSArray *))success fail:(void(^)(NSArray *))fail{
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StoreManagement.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"type":type};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            if (success)  success(result.data);
            return;
        }
        
        if (fail) fail(result.data);
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - SET && GET
-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}

-(NSMutableArray *)shop_date{
    if (!_shop_date) {
        _shop_date = [NSMutableArray array];
    }
    return _shop_date;
}


-(NSArray *)showViewdatas{
    if (!_showViewdatas) {
        _showViewdatas = @[@{@"title":@"营业时间",@"datas":@[@"周一至周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]},@{@"title":@"",@"datas":@[@""]}];
    }
    return _showViewdatas;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
