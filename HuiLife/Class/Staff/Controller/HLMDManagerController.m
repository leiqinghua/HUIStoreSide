//
//  HLMDManagerController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/22.
//

#import "HLMDManagerController.h"
#import "HLYGManagerCell.h"
#import "HLSelectShowView.h"
#import "HLAddYGViewController.h"
#import "HLAddMDViewController.h"
#import "HLLBManagerController.h"
#import "HLEmptyDataView.h"
#import <AFNetworking.h>
#import "HLLoginController.h"
#import "HLStoreModel.h"

@interface HLMDManagerController ()<UITableViewDelegate,UITableViewDataSource,HLSelectShowViewDelegate,UITextFieldDelegate>{
    UIButton * allSelect;

    UIButton * addBtn;
    
    UIView *selectBagView;
    HLSelectShowView *showView;
    UIButton *mendianSelect;

    NSDictionary * defaultDict;
    //全选按钮的图标
}

@property (strong,nonatomic)UIButton * rightBtn;

@property (strong,nonatomic)UIView *bottomBagView;

@property (strong,nonatomic)UIView * bottomAddView;

@property (strong,nonatomic)UIImageView * selectAllBtnView;

@property(strong,nonatomic)UITableView *tableView;

//存储的要删除的数据
@property(strong,nonatomic)NSMutableArray *selectItems;

@property(strong,nonatomic)NSMutableArray *dataSource;

@property(strong,nonatomic)UITextField *searchBar;

//用于搜索
@property(copy,nonatomic)NSString * keyword;
//搜索到的内容
@property(strong,nonatomic)NSMutableArray * searchArr;
//选择的大类
@property(copy,nonatomic)NSString * bigclass;
//选择的小类
@property(copy,nonatomic)NSMutableArray<NSString *> * smallcalss;
//获取到的所有大类
@property(strong,nonatomic)NSMutableArray * allBigStores;

//当前获取到的所有小类
@property(strong,nonatomic)NSMutableArray * currentSmallStores;

//要删除的所选门店
@property(strong,nonatomic)NSMutableArray * deleteIDs;

//用于获取当前的小类
@property(copy,nonatomic)NSString * classid;

//记录上次选择的门店
@property(strong,nonatomic)NSMutableArray * lastSelectStores;

@property(assign,nonatomic)BOOL isLoad;

//记录不能删除的数量
@property(strong,nonatomic)NSMutableArray * noDeleteCount;

@end

@implementation HLMDManagerController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setBackgroundColor:UIColorFromRGB(0xFF8D26)];
    [self hl_setTitle:@"门店管理" andTitleColor:[UIColor whiteColor]];
    [self hl_hideBack:false];
    [self hl_interactivePopGestureRecognizerUseable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(20))];
    [_rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_rightBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [_rightBtn addTarget:self action:@selector(ManagerDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createUI];
    [self createDeleteBtn];
    [self requestList];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadStoreInfo) name:HLReloadStoreDataNotifi object:nil];
    //删除类别的时候 通知更新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadStoreInfo) name:HLModefyStoreClassNotifi object:nil];
}

-(void)requestList{
    //获取门店列表
   [self loadMDListWithType:@"1" success:nil fail:nil];
}
#pragma mark- SET && GET
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
/*
 class = "\U4ed6\U7684\U95e8\U5e97";
 classname = "\U6d60\U682b\U6b91\U95c2\U3125\U7c35";
 id = 793;
 */
-(NSMutableArray *)allBigStores{
    if (!_allBigStores) {
        _allBigStores = [NSMutableArray array];
    }
    return _allBigStores;
}

-(NSMutableArray *)currentSmallStores{
    if (!_currentSmallStores) {
        _currentSmallStores = [NSMutableArray array];
    }
    return _currentSmallStores;
}

-(NSMutableArray *)lastSelectStores{
    if (!_lastSelectStores) {
        _lastSelectStores = [NSMutableArray array];
    }
    return _lastSelectStores;
}
-(NSMutableArray<NSString *> *)smallcalss{
    if (!_smallcalss) {
        _smallcalss = [NSMutableArray array];
    }
    return _smallcalss;
}

-(NSMutableArray *)deleteIDs{
    if (!_deleteIDs) {
        _deleteIDs = [NSMutableArray array];
    }
    return _deleteIDs;
}


-(NSMutableArray *)noDeleteCount{
    if (!_noDeleteCount) {
        _noDeleteCount = [NSMutableArray array];
    }
    return _noDeleteCount;
}

#pragma -------UI---------
-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, ScreenW, ScreenH-Height_NavBar -FitPTScreen(44)) style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 45;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
     AdjustsScrollViewInsetNever(self,_tableView);
    
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
    [mendianSelect setTitle:@"全部类别" forState:UIControlStateNormal];
    [mendianSelect setTitleColor:UIColorFromRGB(0x656565) forState:UIControlStateNormal];
    mendianSelect.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    mendianSelect.titleLabel.font = [UIFont systemFontOfSize:13];
    [bagView addSubview:mendianSelect];
    [mendianSelect makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBar.mas_right).offset(15);
        make.centerY.equalTo(bagView);
        make.width.equalTo(FitPTScreen(60));
        make.height.equalTo(FitPTScreen(39));
    }];
    
    UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_grey_light"]];
    [bagView addSubview:img];
    [img makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->mendianSelect.mas_right).offset(FitPTScreen(8));
        make.centerY.equalTo(self->mendianSelect);
    }];
    [mendianSelect addTarget:self action:@selector(mendianSelect:) forControlEvents:UIControlEventTouchUpInside];
    //管理员就不隐藏，店长隐藏
    mendianSelect.hidden= ![HLAccount shared].admin;
    img.hidden = ![HLAccount shared].admin;
}

-(void)createDeleteBtn{
    _bottomAddView = [[UIView alloc]init];
    [self.view addSubview:_bottomAddView];
    [_bottomAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(FitPTScreenH(44) + Height_Bottom_Margn);
    }];
    
    addBtn = [[UIButton alloc]init];
    [addBtn setTitle:@"添加门店" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    addBtn.backgroundColor = UIColorFromRGB(0x989898);
    addBtn.titleLabel.font=[UIFont systemFontOfSize:FitPTScreenH(15)];
    [_bottomAddView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addYG:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.bottomAddView);
        make.height.equalTo(self.bottomAddView);
        make.width.equalTo(ScreenW/2);
    }];
    
    UIButton *leibie = [[UIButton alloc]init];
    [leibie setTitle:@"管理类别" forState:UIControlStateNormal];
    [leibie setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
    leibie.backgroundColor = UIColorFromRGB(0xFFFFFF);
    leibie.titleLabel.font=[UIFont systemFontOfSize:FitPTScreenH(15)];
    leibie.layer.borderColor =UIColorFromRGB(0x989898).CGColor;
    leibie.layer.borderWidth = 0.5;
    [_bottomAddView addSubview:leibie];
    [leibie addTarget:self action:@selector(manageLeibie:) forControlEvents:UIControlEventTouchUpInside];
    [leibie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomAddView);
        make.height.equalTo(self.bottomAddView);
        make.width.equalTo(ScreenW/2);
    }];
    
    _bottomBagView = [[UIView alloc]init];
    [self.view addSubview:_bottomBagView];
    [_bottomBagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(FitPTScreenH(44) + Height_Bottom_Margn);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [_bottomBagView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.top.equalTo(self.bottomBagView);
        make.height.equalTo(FitPTScreen(1));
    }];
    _bottomBagView.hidden = YES;
    
    allSelect = [[UIButton alloc]init];
    [allSelect setTitle:@"全选" forState:UIControlStateNormal];
    [allSelect setTitleColor:UIColorFromRGB(0x656565) forState:UIControlStateNormal];
    allSelect.titleEdgeInsets = UIEdgeInsetsMake(15, -245/2 +10, 15, 0);
    allSelect.titleLabel.font=[UIFont systemFontOfSize:FitPTScreenH(15)];
    [_bottomBagView addSubview:allSelect];
    [allSelect addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [allSelect mas_makeConstraints:^(MASConstraintMaker *make) {
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
    delete.titleLabel.font=[UIFont systemFontOfSize:FitPTScreenH(15)];
    [_bottomBagView addSubview:delete];
    [delete addTarget:self action:@selector(deleteSelect:) forControlEvents:UIControlEventTouchUpInside];
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.height.equalTo(self.bottomBagView);
        make.width.equalTo(FitPTScreen(130));
    }];
    
}

#pragma HLSelectShowViewDelegate
-(void)cancelBtn:(UIButton *)sender{
    if ([mendianSelect.titleLabel.text isEqualToString:@"全部类别"]) {
        [self.currentSmallStores removeAllObjects];
    }
    [self removeSubview];
}

-(void)removeSubview{
    mendianSelect.selected = false;
    [showView removeFromSuperview];
    [selectBagView removeFromSuperview];
    showView = nil;
    selectBagView = nil;
    self.tableView.scrollEnabled = YES;
}

-(void)concernBtn:(UIButton *)sender selectItems:(NSMutableArray *)items{
    self.searchBar.text = @"";
    _keyword = @"";
    [self.searchArr removeAllObjects];
    [self.tableView reloadData];
    
    [self.smallcalss removeAllObjects];
    [self.lastSelectStores removeAllObjects];
    //记录第一个分组
    NSMutableArray * firstSection = [NSMutableArray array];
    //记录第二个分组
    NSMutableArray * secondSection = [NSMutableArray array];
    
    for (int i = 0; i< items.count; i++) {
        NSIndexPath * path = items[i];
        if (path.section == 0) {
            [firstSection addObject:self.allBigStores[path.row]];
        }else{
            [secondSection addObject:self.currentSmallStores[path.row]];
        }
    }
    [self.lastSelectStores addObject:firstSection];
    [self.lastSelectStores addObject:secondSection];
    
    NSMutableString * title = [NSMutableString string];
    NSMutableString * smallTitle = [NSMutableString string];
    for (NSIndexPath *index in items) {
        NSDictionary * item = showView.dataSource[index.section];
        NSArray * arr = item[@"datas"];
        if (index.section == 0) {
            _bigclass = arr[index.row][@"id"];
            [title appendFormat:@"%@",arr[index.row][@"classname"]];
        }else{
            [smallTitle appendFormat:@"%@",arr[index.row][@"classname"]];
            if (![smallTitle isEqualToString:@"不限"]) {
              [self.smallcalss addObject:arr[index.row][@"id"]];
            }
        }
    }
    if ([title hl_isAvailable] && ![title isEqualToString:@"不限"]) {
        if (![smallTitle isEqualToString:@"不限"] && [smallTitle hl_isAvailable]) {
            [title appendFormat:@"-%@",smallTitle];
        }
        [mendianSelect setTitle:title forState:UIControlStateNormal];
    }else{
        [mendianSelect setTitle:@"全部类别" forState:UIControlStateNormal];
    }
    if (self.smallcalss.count > 0) {
        _bigclass = nil;
    }
    MJWeakSelf;
    [self loadMDListWithType:@"1" success:^(id datas) {
        [weakSelf removeSubview];
    } fail:nil];
}

-(NSMutableArray<NSIndexPath *>*)getAllSelectStores{
    NSMutableArray * selectStores = [NSMutableArray array];
    if (self.lastSelectStores.count > 0) {
        NSMutableArray * fist = self.lastSelectStores.firstObject;
        NSMutableArray * second = self.lastSelectStores.lastObject;
        for (int i = 0 ; i< fist.count; i++) {
            NSDictionary * dict = fist[i];
            for (int j = 0; j< self.allBigStores.count; j++) {
                NSDictionary * store = self.allBigStores[j];
                if ([store[@"id"] isEqual:dict[@"id"]]) {
                    NSIndexPath * index = [NSIndexPath indexPathForRow:j inSection:0];
                    [selectStores addObject:index];
                }
            }
        }
        
        for (int i = 0 ; i< second.count; i++) {
            NSDictionary * dict = second[i];
            for (int j = 0; j< self.currentSmallStores.count; j++) {
                NSDictionary * store = self.currentSmallStores[j];
                if ([store[@"id"] isEqual:dict[@"id"]]) {
                    NSIndexPath * index = [NSIndexPath indexPathForRow:j inSection:1];
                    [selectStores addObject:index];
                }
            }
        }
    }
    
    return selectStores;
}

-(void)selectFirstSectionWithItem:(NSDictionary *)dict{
    _classid = dict[@"id"];
    weakify(self);
    [self loadMDListWithType:@"3" success:^(id datas) {
        [weak_self.currentSmallStores removeAllObjects];
        [weak_self.currentSmallStores addObjectsFromArray:datas];
        //刷新showview
        [weak_self reloadShowView];
    } fail:nil];
}

#pragma Event Click
-(void)mendianSelect:(UIButton *)sender{
    if (!_isLoad) {
        weakify(self);
        [self loadMDListWithType:@"2" success:^(id datas) {
            [weak_self.allBigStores removeAllObjects];
            [weak_self.allBigStores addObjectsFromArray:datas];
            if (weak_self.allBigStores.count == 0 ) {
                [HLTools showWithText:@"没有任何类别信息"];
                return ;
            }
            [weak_self showAllBigClassess:sender];
        } fail:nil];
    }
}

-(void)showAllBigClassess:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.view endEditing:YES];
    if (!showView) {
        selectBagView = [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.frame.origin.y, ScreenW, self.tableView.bounds.size.height)];
        selectBagView.backgroundColor = [UIColor blackColor];
        selectBagView.alpha = 0.5;
        [self.view addSubview:selectBagView];
        showView = [[HLSelectShowView alloc]init];
        [self.view addSubview:showView];
        [showView makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        showView.delegate = self;
        showView.type = HLMDManagerListType;
        showView.max_hight = self.tableView.frame.size.height;
        if (self.allBigStores.count > 0) {
            NSArray *datas = @[@{@"title":@"门店类别",@"datas":self.allBigStores}];
            showView.sigleSection = 0;
            NSIndexPath * first = [NSIndexPath indexPathForItem:0 inSection:0];
            [showView.selectItems addObject:first];
            if (self.currentSmallStores && self.currentSmallStores.count > 0) {
                datas = @[@{@"title":@"门店类别",@"datas":self.allBigStores},@{@"title":@"门店小类",@"datas":self.currentSmallStores}];
            }
            if (self.lastSelectStores.count > 0) {
                showView.selectItems = [self getAllSelectStores];;
            }
            showView.dataSource = [NSMutableArray arrayWithArray:datas];
        }
    }
    self.tableView.scrollEnabled = !sender.selected;
    if (!sender.selected) {
        [self removeSubview];
    }
}

-(void)ManagerDelete:(UIButton *)sender{
    if (self.dataSource.count == 0) {
        return ;
    }
    sender.selected = !sender.selected;
    allSelect.selected = !sender.selected;
    [self.noDeleteCount removeAllObjects];
    [_tableView setEditing:sender.selected];
    _bottomAddView.hidden = sender.selected;
    _bottomBagView.hidden = !sender.selected;
    if (!sender.selected && !_tableView.editing) {
        [self.selectItems removeAllObjects];
        _selectAllBtnView.image = [UIImage imageNamed:@"success_grey"];
    }
}

//管理类别
-(void)manageLeibie:(UIButton *)sender{
    [HLTools showWithText:@"敬请期待"];
}

-(void)addYG:(UIButton *)sender{
    [HLTools showWithText:@"敬请期待"];
}

-(void)selectAll:(UIButton *)sender{
    [self.selectItems removeAllObjects];
    
    sender.selected = !sender.selected;
    _selectAllBtnView.image = [UIImage imageNamed:sender.selected?@"success_oriange":@"success_grey"];

    if (sender.selected && self.tableView.editing) {
        NSMutableArray * arr = self.searchArr.count>0?self.searchArr:self.dataSource;
        for (HLStoreModel * model in arr) {
            if(([model.is_general_store integerValue] != 1) && ([model.has_user integerValue] != 1)){
                [self.selectItems addObject:model];
            }else{
                [HLTools showWithText:@"总店或该门店下有员工不能删除"];
            }
        }
    }else if (!sender.selected){
        [self.selectItems removeAllObjects];
    }
    [self.tableView reloadData];
}

//调用删除接口
-(void)deleteSelect:(UIButton *)sender{
    if (_tableView.editing) {
        _keyword = @"";
        if (self.selectItems.count == 0) {
            return;
        }
        [self.deleteIDs removeAllObjects];
        for (HLStoreModel *model in self.selectItems) {
            [self.deleteIDs addObject:model.storeID];
        }
        
        [HLCustomAlert showNormalStyleTitle:@"" message:@"确认删除所选门店" buttonTitles:@[@"取消",@"确定"] buttonColors:@[UIColorFromRGB(0x666666),UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
            if (index == 1) {//确定
                [self deleteMDListRequest:@"5" success:^{
                    if (self.searchArr.count > 0) {
                        [self.searchArr removeObjectsInArray:self.selectItems];
                        if (self.searchArr.count == 0) {
                            self.keyword = @"";
                            self.searchBar.text = @"";
                        }
                    }
                    [self.dataSource removeObjectsInArray:self.selectItems];
                    [self.tableView reloadData];
                    [self deleteSucess:YES];
                } fail:^{
                }];
              
            }else{
                [self.selectItems removeAllObjects];
                [self deleteSucess:NO];
            }
        }];
        
    }
}

#pragma mark - Notification- HLReloadStoreDataNotifi
-(void)reloadStoreInfo{
    [self requestList];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArr.count>0?self.searchArr.count:self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLYGManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    HLStoreModel *model = self.searchArr.count>0?self.searchArr[indexPath.row]:self.dataSource[indexPath.row];
    cell.storeModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (tableView.editing) {
        if (allSelect.selected && ([model.is_general_store integerValue] != 1) && ([model.has_user integerValue] != 1)) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLStoreModel *model = self.searchArr.count == 0?self.dataSource[indexPath.row]:self.searchArr[indexPath.row];
    //是总店 或者 有员工
    if (([model.is_general_store integerValue] == 1 || [model.has_user integerValue] == 1) && self.tableView.editing) {
        if ([model.is_general_store integerValue] == 1) {
            [HLTools showWithText:@"总店不能删除"];
        }else if ([model.has_user integerValue] == 1){
            [HLTools showWithText:@"该门店下有员工，不能删除"];
        }
        if (![self.noDeleteCount containsObject:model]) {
            [self.noDeleteCount addObject:model];
        }
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (tableView.editing) {
        if (self.searchArr.count > 0) {
            [self.selectItems addObject:self.searchArr[indexPath.row]];
        }else{
            [self.selectItems addObject:self.dataSource[indexPath.row]];
        }
        
        if (self.selectItems.count == (self.searchArr.count>0?(self.searchArr.count - self.noDeleteCount.count):(self.dataSource.count -self.noDeleteCount.count))) {//全部已选
            allSelect.selected = YES;
            _selectAllBtnView.image = [UIImage imageNamed:@"success_oriange"];
        }
        NSLog(@"selectItems - %@",self.selectItems);
        return;
    }
    HLAddMDViewController * addvc = [[HLAddMDViewController alloc]init];
    HLStoreModel * storeModel = self.searchArr.count == 0?self.dataSource[indexPath.row]:self.searchArr[indexPath.row];
    addvc.storeModel = storeModel;
    [self hl_pushToController:addvc];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        [self.selectItems removeObject:self.searchArr.count>0?self.searchArr[indexPath.row]:self.dataSource[indexPath.row]];
        if (allSelect.selected) {
            allSelect.selected = NO;
            _selectAllBtnView.image = [UIImage imageNamed:@"success_grey"];
        }
        NSLog(@"DeselectItems - %@",self.selectItems);
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _keyword = @"";
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
    _keyword = textField.text;
    [textField resignFirstResponder];
    [self requestList];
    return YES;
}



-(void)reloadShowView{
    NSArray *datas;
    if (self.currentSmallStores.count > 0) {
        datas = @[@{@"title":@"门店类别",@"datas":self.allBigStores},@{@"title":@"门店小类",@"datas":self.currentSmallStores}];
    }else{
        datas = @[@{@"title":@"门店类别",@"datas":self.allBigStores}];
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:showView.selectItems];
    for (NSIndexPath * index in array) {
        if (index.section == 1) {
            [showView.selectItems removeObject:index];
        }
    }
    if (self.currentSmallStores.count > 0) {
       [showView.selectItems addObject:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    showView.dataSource = [NSMutableArray arrayWithArray:datas];
}

#pragma mark - request
//------------------------获取列表-----------------------
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
        NSArray * datas = data;
        //model数组
        NSArray * models = [HLStoreModel mj_objectArrayWithKeyValuesArray:datas];
        if ([type integerValue] == 1) {
            if ([self.keyword hl_isAvailable]) {
                [self.searchArr removeAllObjects];
                [self.searchArr addObjectsFromArray:models];
                [self showEmptyViewWith:YES noData:datas.count == 0];
            }else{
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:models];
                [self showEmptyViewWith:![self.bigclass hl_isAvailable] && self.smallcalss.count == 0 noData:datas.count == 0];
            }
        }
    }
}


-(void)loadMDListWithType:(NSString *)type success:(void(^)(id datas))success fail:(void(^)(id datas))fail{
    _isLoad = YES;
    [self.searchArr removeAllObjects];
    NSDictionary * pargram = @{
                               @"type":type,
                               @"keyword":[_keyword hl_isAvailable]?_keyword:@"",
                               @"class_id":[_classid hl_isAvailable]?_classid:@"",
                               @"bigclass":_bigclass?:@"",
                               @"smaclass":[_smallcalss hl_isAvailable]?[_smallcalss mj_JSONString]:@"",
                               };
    if (![type isEqualToString:@"2"]) {
         HLLoading(self.view);
    }
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StoreManagement.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
       
        if(result.code == 200){
            [self dealWithDatas:result.data type:type];
            if (success) {
              success(result.data);
            }
            [self.tableView reloadData];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
    
}

//----------删除------------------------

- (void)deleteSucess:(BOOL)success{
    self.rightBtn.selected = false;
    self.bottomBagView.hidden = YES;
    self.bottomAddView.hidden = NO;
    [self.noDeleteCount removeAllObjects];
    self.selectAllBtnView.image = [UIImage imageNamed:@"success_grey"];
    [self.tableView setEditing:false];
}


-(void)deleteMDListRequest:(NSString *)type success:(void(^)(void))success fail:(void(^)(void))fail{
    NSDictionary *pargram = @{
                              @"type":type,
                              @"sids":[self.deleteIDs mj_JSONString]
                              };
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StoreEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        
        if(result.code == 200){
            if (success) success();
            [HLTools showWithText:@"删除成功"];
            [self.selectItems removeAllObjects];
            return;
        }
        if (fail) fail();
        [self.selectItems removeAllObjects];
    } onFailure:^(NSError *error) {
    }];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
