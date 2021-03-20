//
//  HLYGManagerController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/20.
//

#import "HLYGManagerController.h"
#import "HLYGManagerCell.h"
#import "HLSelectShowView.h"
#import "HLAddYGViewController.h"
#import "HLEmptyDataView.h"
#import "HLStaffModel.h"

@interface HLYGManagerController ()<UITableViewDelegate,UITableViewDataSource,HLSelectShowViewDelegate,UITextFieldDelegate>{

    UIView *selectBagView;
    HLSelectShowView *showView;
    UIButton *mendianSelect;
    NSDictionary * defaultDict;
    //全选按钮
    UIButton * allSelectBtn;
}

@property (strong,nonatomic)UIButton * rightBtn;

@property (strong,nonatomic)UIButton * addBtn;

@property (strong,nonatomic)UIView *bottomBagView;
  //全选按钮的图标
@property (strong,nonatomic)UIImageView * selectAllBtnView;

@property(strong,nonatomic)UITableView *tableView;

//存储的要删除的数据
@property(strong,nonatomic)NSMutableArray *selectItems;

@property(strong,nonatomic)NSMutableArray *dataSource;

@property(strong,nonatomic)UITextField *searchBar;

//搜索关键词
@property(copy,nonatomic)NSString * keyWord;
//选择的门店
@property(copy,nonatomic)NSMutableArray * source;
//搜索到的内容
@property(strong,nonatomic)NSMutableArray * searchArr;
//获取到的全部门店
@property(strong,nonatomic)NSMutableArray * allStores;
//选择的门店
@property(copy,nonatomic)NSString * selectSource;

//记录上次选择的门店
@property(strong,nonatomic)NSMutableArray * lastSelectStores;

@property(assign,nonatomic)BOOL isReload;

@end

@implementation HLYGManagerController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"员工管理" ];
    _addBtn.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    _addBtn.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self hl_hideBack:false];
    
    [self createRightButton];
    
    [self createUI];
    
    [self createDeleteBtn];
    
    [self requestList];
    
    //注册刷新列表的通知（修改或添加员工之后）
    [HLNotifyCenter addObserver:self selector:@selector(reloadYGList:) name:HLReloadStaffDataNotifi object:nil];
}

- (void)requestList{
    [self requestYGListWithType:@"1" success:nil fail:nil];
}

-(void)reloadYGList:(NSNotification *)sender{
    _keyWord = @"";
    [self requestList];
}

#pragma mark - UI

- (void)createRightButton{
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(20))];
    [_rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_rightBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [_rightBtn addTarget:self action:@selector(ManagerDelete:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, ScreenW, ScreenH-Height_NavBar -FitPTScreen(44)) style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 45;
    AdjustsScrollViewInsetNever(self,_tableView);
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[HLYGManagerCell class] forCellReuseIdentifier:@"cellID"];
    
    
    UIView * bagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(44))];
    bagView.backgroundColor = UIColorFromRGB(0xFBFBFB);
    _tableView.tableHeaderView = bagView;
    
    UIView * imgBgV = [[UIView alloc]init];
    imgBgV.layer.cornerRadius = 3;
    imgBgV.backgroundColor = UIColorFromRGB(0xEDEBEB);
    [bagView addSubview:imgBgV];
    [imgBgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bagView);
        make.left.equalTo(FitPTScreen(20));
        make.width.equalTo(FitPTScreen(30));
        make.height.equalTo(FitPTScreen(29));
    }];
    
    UIImageView * searchImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_grey"]];
    [imgBgV addSubview:searchImgV];
    [searchImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(imgBgV);
    }];
       
    _searchBar = [[UITextField alloc]init];
    _searchBar.placeholder = @"搜索工号/姓名";
    _searchBar.layer.cornerRadius = 3;
    _searchBar.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor hl_StringToColor:@"#FF8D26"];
    _searchBar.font = [UIFont boldSystemFontOfSize:13];
    _searchBar.backgroundColor = UIColorFromRGB(0xEDEBEB);
    [_searchBar addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    [bagView addSubview:_searchBar];
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgBgV.right).offset(-2);
        make.centerY.equalTo(bagView);
        make.width.equalTo(FitPTScreen([HLAccount shared].admin?FitPTScreen(213):FitPTScreen(305)));
        make.height.equalTo(FitPTScreen(29));
    }];

    mendianSelect = [[UIButton alloc]init];
    [mendianSelect setTitle:@"全部门店" forState:UIControlStateNormal];
    [mendianSelect setTitleColor:UIColorFromRGB(0x656565) forState:UIControlStateNormal];
    mendianSelect.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    mendianSelect.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [bagView addSubview:mendianSelect];
    [mendianSelect makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBar.mas_right).offset(15);
        make.centerY.equalTo(bagView);
        make.height.equalTo(FitPTScreen(39));
    }];
    
    UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_grey_light"]];
    [bagView addSubview:img];
    [img makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->mendianSelect.right).offset(5);
        make.centerY.equalTo(self->mendianSelect);
    }];
    [mendianSelect addTarget:self action:@selector(mendianSelect:) forControlEvents:UIControlEventTouchUpInside];
    //管理员就不隐藏，店长隐藏
    mendianSelect.hidden= ![HLAccount shared].admin;
    img.hidden = ![HLAccount shared].admin;
    
}

-(void)createDeleteBtn{
    _addBtn = [[UIButton alloc]init];
    [_addBtn setTitle:@"添加员工" forState:UIControlStateNormal];
    [_addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _addBtn.backgroundColor = UIColorFromRGB(0xFF8604);
    _addBtn.titleLabel.font=[UIFont systemFontOfSize:FitPTScreen(15)];
    [self.view addSubview:_addBtn];
    [_addBtn addTarget:self action:@selector(addYG:) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(FitPTScreen(44) + Height_Bottom_Margn);
    }];
    
    _bottomBagView = [[UIView alloc]init];
    [self.view addSubview:_bottomBagView];
    [_bottomBagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(FitPTScreen(44) + Height_Bottom_Margn );
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [_bottomBagView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.top.equalTo(self.bottomBagView);
        make.height.equalTo(FitPTScreen(1));
    }];
    _bottomBagView.hidden = YES;
    
    allSelectBtn = [[UIButton alloc]init];
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn setTitleColor:UIColorFromRGB(0x656565) forState:UIControlStateNormal];
    allSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(15, -245/2 +10, 15, 0);
    allSelectBtn.titleLabel.font=[UIFont systemFontOfSize:FitPTScreen(15)];
    [_bottomBagView addSubview:allSelectBtn];
    [allSelectBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.height.equalTo(self.bottomBagView);
        make.width.equalTo(FitPTScreen(245));
    }];
    
    _selectAllBtnView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success_grey"]];
    [_bottomBagView addSubview:_selectAllBtnView];
    [_selectAllBtnView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBagView).offset(FitPTScreen(17));
        make.centerY.equalTo(self.bottomBagView);
    }];
    
    UIButton * delete = [[UIButton alloc]init];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    delete.backgroundColor = UIColorFromRGB(0xFF8D26);
    delete.titleLabel.font=[UIFont systemFontOfSize:FitPTScreen(15)];
    [_bottomBagView addSubview:delete];
    [delete addTarget:self action:@selector(deleteSelect:) forControlEvents:UIControlEventTouchUpInside];
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.height.equalTo(self.bottomBagView);
        make.width.equalTo(FitPTScreen(130));
    }];
    
}

#pragma mark - Method
-(void)mendianSelect:(UIButton *)sender{
    if (!_isReload) return;
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self removeSubview];
        return;
    }
    weakify(self);
    [self requestYGListWithType:@"2" success:^(id data) {
        [self.allStores removeAllObjects];
        [self.allStores addObjectsFromArray:data];
        if (weak_self.allStores.count == 0) {
            [HLTools showWithText:@"没有门店信息"];
            return ;
        }
        [weak_self showAllStores:sender];
    } fail:^(id model) {
        
    }];
}

- (void)showAllStores:(UIButton *)sender {
//    sender.selected = !sender.selected;
    self.navigationItem.leftBarButtonItem.enabled = !sender.selected;
    [self.searchBar resignFirstResponder];
    if (!showView) {
        selectBagView = [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.frame.origin.y+FitPTScreen(44), ScreenW, self.tableView.bounds.size.height)];
        selectBagView.backgroundColor = [UIColor blackColor];
        selectBagView.alpha = 0.5;
        [KEY_WINDOW addSubview:selectBagView];
        showView = [[HLSelectShowView alloc]init];
        [KEY_WINDOW addSubview:showView];
        [showView makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(KEY_WINDOW);
            make.top.equalTo(self.tableView.frame.origin.y+FitPTScreen(44));

        }];
        NSIndexPath *first = [NSIndexPath indexPathForItem:0 inSection:0];
        showView.delegate = self;
        showView.type = HLYGManagerListType;
        showView.max_hight = self.tableView.frame.size.height - FitPTScreen(44);
        if (self.allStores.count>0) {
            if (!defaultDict) {
                defaultDict = @{@"id":@"",@"name":@"不限"};
                [self.allStores insertObject:defaultDict atIndex:0];
            }
            if (self.lastSelectStores.count > 0) {
                showView.selectItems = [self getAllSelectStores];;
            }else{
                [showView.selectItems addObject:first];
            }
            NSArray *datas = @[@{@"title":@"门店",@"datas":self.allStores
                                 }];

            showView.dataSource = [NSMutableArray arrayWithArray:datas];
        }
    }
    self.tableView.scrollEnabled = !sender.selected;
    if (!sender.selected) {
        [self removeSubview];
    }
}

-(void)ManagerDelete:(UIButton *)sender{
    if (self.dataSource.count == 0 || showView) {
        return ;
    }
    sender.selected = !sender.selected;
    [_tableView setEditing:sender.selected];
    _addBtn.hidden = sender.selected;
    _bottomBagView.hidden = !sender.selected;
    if (!sender.selected && !_tableView.editing) {
        [self.selectItems removeAllObjects];
        _selectAllBtnView.image = [UIImage imageNamed:@"success_grey"];
    }
}

-(void)addYG:(UIButton *)sender{
    HLAddYGViewController * addVC = [[HLAddYGViewController alloc]init];
    addVC.isAdd = YES;
    [self hl_pushToController:addVC];
}

-(void)selectAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    _selectAllBtnView.image = [UIImage imageNamed:sender.selected?@"success_oriange":@"success_grey"];
    [self.selectItems removeAllObjects];
    if (sender.selected && self.tableView.editing) {
       [self.selectItems addObjectsFromArray:self.searchArr.count>0?self.searchArr:self.dataSource];
    }else if (!sender.selected){
        [self.selectItems removeAllObjects];
    }
    [self.tableView reloadData];
}

-(void)deleteSelect:(UIButton *)sender{
    if (_tableView.editing && self.selectItems.count > 0) {
        [HLCustomAlert showNormalStyleTitle:@"" message:@"确认删除所选员工" buttonTitles:@[@"取消",@"确认"] buttonColors:@[UIColorFromRGB(0x666666),UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
            if (index == 1) {//确定
                [self deleteSelectYGWithSuccess:^{
                    if (self.searchArr.count > 0) {//搜索的情况下
                        [self.searchArr removeObjectsInArray:self.selectItems];
                        self.keyWord = self.searchArr.count == 0?@"":self.keyWord;
                        self.searchBar.text = self.searchArr.count == 0?@"":self.searchBar.text;
                    }
                    [self.dataSource removeObjectsInArray:self.selectItems];
                    [self.tableView reloadData];
                    [self showNoDatasView];
                    [self changeUIAfterDeleteWithSuccess:NO];
                }];
            }else{
                [self changeUIAfterDeleteWithSuccess:NO];
            }
        }];
    }
}

//删除成功或者取消
-(void)changeUIAfterDeleteWithSuccess:(BOOL)success{
    [self.tableView setEditing:false];
    self.rightBtn.selected = false;
    self.bottomBagView.hidden = YES;
    self.addBtn.hidden = NO;
    self.selectAllBtnView.image = [UIImage imageNamed:@"success_grey"];
    [self.selectItems removeAllObjects];
}

//当数据为空时，出现默认图
- (void)showNoDatasView{
    [self showEmptyViewWith:NO noData:self.dataSource.count == 0];
}

#pragma HLSelectShowViewDelegate
-(void)cancelBtn:(UIButton *)sender{
    [self removeSubview];
}

- (void)removeSubview {
    defaultDict = nil;
    mendianSelect.selected = false;
    [showView removeFromSuperview];
    [selectBagView removeFromSuperview];
    showView = nil;
    
    selectBagView = nil;
    self.tableView.scrollEnabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = !mendianSelect.selected;
}

-(void)concernBtn:(UIButton *)sender selectItems:(NSMutableArray *)items{
    self.searchBar.text = @"";
    _keyWord = @"";
    [self.searchArr removeAllObjects];
    [self.tableView reloadData];
    
    NSIndexPath * index = items.firstObject;
    [self.lastSelectStores removeAllObjects];
    for (int i = 0; i< items.count; i++) {
        NSIndexPath * path = items[i];
        [self.lastSelectStores addObject:self.allStores[path.row]];
    }
    [self.source removeAllObjects];
    if ((items.count == 1 && index.row == 0) || (items.count == 0)) {
        [self requestYGListWithType:@"1" success:nil fail:nil];
        [mendianSelect setTitle:@"全部门店" forState:UIControlStateNormal];
    }else{
        NSMutableString * title = [NSMutableString string];
        for (NSIndexPath * indexpath in items) {
            NSDictionary * dict = self.allStores[indexpath.row];
            [self.source addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
            [title appendFormat:@"%@",dict[@"name"]];
        }
        [mendianSelect setTitle:title forState:UIControlStateNormal];
        [self requestYGListWithType:@"1" success:nil fail:nil];
        
    }
}

-(NSMutableArray<NSIndexPath *>*)getAllSelectStores{
    NSMutableArray * selectStores = [NSMutableArray array];
    for (int i = 0 ; i< self.lastSelectStores.count; i++) {
        NSDictionary * dict = self.lastSelectStores[i];
        for (int j = 0; j< self.allStores.count; j++) {
            NSDictionary * store = self.allStores[j];
            if ([store[@"id"] isEqual:dict[@"id"]]) {
                NSIndexPath * index = [NSIndexPath indexPathForRow:j inSection:0];
                [selectStores addObject:index];
            }
        }
    }
    return selectStores;
}

#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArr.count == 0?self.dataSource.count:self.searchArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLYGManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.staffModel = self.searchArr.count == 0?self.dataSource[indexPath.row]:self.searchArr[indexPath.row];
    
    if (tableView.editing) {
        if (allSelectBtn.selected) {
           [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
           [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        [self.selectItems addObject:self.searchArr.count>0?self.searchArr[indexPath.row]:self.dataSource[indexPath.row]];
        if (self.selectItems.count == (self.searchArr.count>0?self.searchArr.count:self.dataSource.count)) {//全部已选
            allSelectBtn.selected = YES;
            _selectAllBtnView.image = [UIImage imageNamed:@"success_oriange"];
        }
    }else{
        HLStaffModel * model = self.searchArr.count == 0?self.dataSource[indexPath.row]:self.searchArr[indexPath.row];
        HLAddYGViewController * addvc = [[HLAddYGViewController alloc]init];
        addvc.isAdd = NO;
        addvc.staffModel = model;
        [self hl_pushToController:addvc];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        [self.selectItems removeObject:self.dataSource[indexPath.row]];
        if (allSelectBtn.selected) {
            allSelectBtn.selected = NO;
            _selectAllBtnView.image = [UIImage imageNamed:@"success_grey"];
        }
        NSLog(@"DeselectItems - %@",self.selectItems);
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//选择编辑的方式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //讲表中的cell删除
        //将本地的数组数据删除
        //最后将服务器的数据删除
    }
}

//选择你要对表进行处理的方式  默认是删除方式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (showView) {
        return NO;
    }
    _keyWord = @"";
    return YES;
}

- (void)textFieldEditing:(UITextField *)sender{
   if (![sender.text hl_isAvailable]) {
       [self.searchArr removeAllObjects];
       [self.tableView reloadData];
       [self showEmptyViewWith:NO noData:self.dataSource.count == 0];
   }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    _keyWord = textField.text;
    [textField resignFirstResponder];
    [self requestList];
    return YES;
}


#pragma Base Request

//出现无数据默认图
//isSearch:是否是搜索结果
//nodata:是否没有数据
- (void)showEmptyViewWith:(BOOL)isSearch noData:(BOOL)nodata{
    if (!nodata) {//有数据
       [self.tableView removeEmptyView];
        return;
    }
    NSString * type = isSearch?@"1":@"0";
    [HLEmptyDataView emptyViewWithFrame:CGRectMake(0, FitPTScreen(44), ScreenW,CGRectGetMaxY(self.tableView.bounds)-FitPTScreen(44)) superView:self.tableView type:type balock:^{
        
    }];
}

//处理请求回的列表
- (void)dealWithDatas:(id)data type:(NSString *)type{
    if ([type integerValue] == 1) {
        //model数组
        NSArray * models = [HLStaffModel mj_objectArrayWithKeyValuesArray:data];
        
        if ([self.keyWord hl_isAvailable]) {
            
            [self.searchArr removeAllObjects];
            
            [self.searchArr addObjectsFromArray:models];
            
            [self showEmptyViewWith:YES noData:models.count==0];
        }else{
            
            [self.dataSource removeAllObjects];
            
            [self.dataSource addObjectsFromArray:models];
            
            [self showEmptyViewWith:self.source.count > 0 noData:models.count==0];
            
            [self removeSubview];
        }
    }
}

//type:1 员工列表  2:门店
-(void)requestYGListWithType:(NSString *)type success:(void(^)(id))success fail:(void(^)(id))fail{
    //获取员工列表信息
    _isReload = YES;
    NSString * sourceStr = [self.source mj_JSONString];
    NSDictionary * pargram = @{
                               @"keyword":_keyWord?:@"",
                               @"type":type,
                               @"source":self.source.count == 0? @"":sourceStr,
                               };    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StaffManagement.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self dealWithDatas:result.data type:type];
            if (success)success(result.data);
            [self.tableView reloadData];
        }
        if (fail) fail(result.data);
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
    
}

- (void)deleteSelectYGWithSuccess:(void(^)(void))success{
    NSMutableArray * items = [NSMutableArray array];
    for (HLStaffModel *model in self.selectItems) {
        [items addObject:model.staffID];
    }
    NSString * str = [items mj_JSONString];
    NSDictionary * pargram = @{
                               @"type":@"5",
                               @"oids":str,
                               };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StaffEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            if (success) success();
            [self.selectItems removeAllObjects];
            [HLTools showWithText:@"删除成功"];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar endEditing:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - SET && GET
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

-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
    }
    return _source;
}

-(NSMutableArray *)allStores{
    if (!_allStores) {
        _allStores = [NSMutableArray array];
    }
    return _allStores;
}

-(NSMutableArray *)lastSelectStores{
    if (!_lastSelectStores) {
        _lastSelectStores = [NSMutableArray array];
    }
    return _lastSelectStores;
}


@end
