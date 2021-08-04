//
//  HLLBManagerController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import "HLLBManagerController.h"
#import "HLLBHeaderView.h"
#import "HLMDLBManagerCell.h"
#import "HLTextFieldCheckInputNumberTool.h"
#import "HLEmptyDataView.h"

@interface HLLBManagerController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,HLLBHeaderViewDelegate,HLMDLBManagerCellDelegate,UITextFieldDelegate>{
    
    UIButton * addBtn;
    
    HLTextFieldCheckInputNumberTool * checkTool;
    
}
@property(strong,nonatomic)UITableView * tableView;

@property(strong,nonatomic)UITextField * inputField;
//数据源
@property(strong,nonatomic)NSMutableArray * dataSource;

@property(assign,nonatomic)NSInteger currentPage;

//为某个cid大类添加小类，或者删除某个cid小类
@property(copy,nonatomic)NSString * cid;

//添加的名称
@property(copy,nonatomic)NSString * className;

//上次选择的小类位置
@property(strong,nonatomic)NSIndexPath * lastIndexPath;

//上次所选择的大类
@property(assign,nonatomic)NSInteger lastIndex;

@end

@implementation HLLBManagerController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setBackgroundColor:UIColorFromRGB(0xFF8D26)];
    [self hl_setTitle:_isSelect?@"选择门店类别":@"门店类别" andTitleColor:[UIColor whiteColor]];
    [self hl_hideBack:false];
    [self hl_interactivePopGestureRecognizerUseable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始值
    _currentPage = 0;
    _lastIndex = -1;
    //创建门店
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_NavBar, ScreenW, ScreenH-Height_NavBar) style:UITableViewStyleGrouped];
    _tableView.estimatedRowHeight = 45;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[HLMDLBManagerCell class] forCellReuseIdentifier:@"cellID"];
    _tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [_tableView registerClass:[HLLBHeaderView class] forHeaderFooterViewReuseIdentifier:@"HLLBHeaderView"];
    
     AdjustsScrollViewInsetNever(self,_tableView);
    
    
    if (!_isSelect) {
        UIView * bagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreenH(44))];
        bagView.backgroundColor = UIColorFromRGB(0xFBFBFB);
        _tableView.tableHeaderView = bagView;
        _tableView.tableFooterView = [[UIView alloc]init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
        
        _inputField = [[UITextField alloc]init];
        _inputField.backgroundColor = [UIColor colorWithRed:237/255.0 green:235.14/255.0 blue:235.14/255.0 alpha:1];
        _inputField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  请输入新建门店类别" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreenH(13)]}];
        
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10,FitPTScreenH(29))];
        leftView.backgroundColor = [UIColor clearColor];
        _inputField.leftView = leftView;
        _inputField.leftViewMode = UITextFieldViewModeAlways;
        
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.layer.cornerRadius = 3;
        _inputField.returnKeyType = UIReturnKeySearch; //设置按键类型
        [bagView addSubview:_inputField];
        [_inputField makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bagView);
            make.left.equalTo(bagView).offset(20);
            make.width.equalTo(FitPTScreen(253));
            make.height.equalTo(FitPTScreenH(29));
        }];
        
        UIButton * createBtn = [[UIButton alloc]init];
        [createBtn setTitle:@"新建" forState:UIControlStateNormal];
        [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        createBtn.backgroundColor = UIColorFromRGB(0xFF8D26);
        createBtn.layer.cornerRadius = 3;
        createBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
        [createBtn addTarget:self action:@selector(createBigClass:) forControlEvents:UIControlEventTouchUpInside];
        [bagView addSubview:createBtn];
        [createBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bagView);
            make.left.equalTo(self.inputField.mas_right).offset(FitPTScreen(13));
            make.width.equalTo(FitPTScreen(70));
            make.height.equalTo(FitPTScreenH(29));
        }];
    }
    //获取列表
    [self getList];
    checkTool = [[HLTextFieldCheckInputNumberTool alloc]init];
    checkTool.MAX_STARWORDS_LENGTH = 14;
    [_inputField addTarget:checkTool action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)getList{
    MJWeakSelf;
    [self requestData:@"1" success:^(NSArray *datas){
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:datas];
        [weakSelf.tableView reloadData];
        
        if (weakSelf.dataSource.count > 0) {
            [weakSelf.tableView removeEmptyView];
        }else{
            [HLEmptyDataView emptyViewWithFrame:CGRectMake(0, weakSelf.isSelect?0:FitPTScreenH(44), ScreenW, weakSelf.isSelect?CGRectGetMaxY(weakSelf.tableView.bounds):CGRectGetMaxY(weakSelf.tableView.bounds) - FitPTScreenH(44)) superView:weakSelf.tableView type:@"0" balock:^{
                
            }];
        }
    } fail:nil];
}

//新建类别
-(void)createBigClass:(UIButton *)sender{
    if ([NSString isEmpty:self.inputField.text]) {
        [HLTools showWithText:@"内容不能为空"];
        return;
    }
    if (self.inputField.text.length >14) {
        [HLTools showWithText:@"不得超过14个字"];
        return;
    }
    [self.inputField resignFirstResponder];
    MJWeakSelf;
    _className = self.inputField.text;
    if ([self.inputField.text hl_isAvailable]) {
        [self requestData:@"2" success:^(NSArray *datas) {
            [weakSelf.tableView removeEmptyView];
            [HLTools showWithText:@"已新建"];
            [weakSelf.inputField resignFirstResponder];
            weakSelf.inputField.text = @"";
            [weakSelf getList];
            [[NSNotificationCenter defaultCenter]postNotificationName:HLModefyStoreClassNotifi object:nil];
        } fail:nil];
    }
}

-(void)tap:(UITapGestureRecognizer *)recognizer{
    [_inputField resignFirstResponder];
}

-(void)addYG{
    if (!_lastIndexPath && _lastIndex == -1) {
        [HLTools showWithText:@"请选择门店类别"];
        return;
    }
    NSDictionary * bigDict;
    NSDictionary * smallDict;
    if (!_lastIndexPath) {
        bigDict =self.dataSource[_lastIndex];
    }else{
        bigDict = self.dataSource[_lastIndexPath.section];
        smallDict = bigDict[@"smaclass"][_lastIndexPath.row];
    }
    if (self.selectBlock) {
        self.selectBlock(bigDict,smallDict);
    }
    [self hl_goback];
}
#pragma mark- NSMutableArray
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![touch.view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return NO;
}

#pragma UITableViewDataSource

/*
 class = "\U4ed6\U7684\U95e8\U5e97";
 classname = "\U4ed6\U7684\U95e8\U5e97";
 id = 793;
 smaclass =     (
 {
 class = 1234;
 classname = 1234;
 id = 794;
 },
 );
 */

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary * dict = self.dataSource[section];
    NSArray * subClasses = dict[@"smaclass"];
    return  subClasses?subClasses.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = self.dataSource[indexPath.section];
    NSArray * subClasses = dict[@"smaclass"];
    HLMDLBManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isSelect = _isSelect;
    cell.delegate = self;
    cell.indexpath = indexPath;
    [cell hideLine:indexPath.row == subClasses.count-1];
    if ((indexPath.row == subClasses.count-1)&&(indexPath.section == self.dataSource.count -1)) {
        [cell hideLine:NO];
    }
    [cell setContentWithDict:subClasses[indexPath.row]];
    NSString * classid = [NSString stringWithFormat:@"%@",subClasses[indexPath.row][@"id"]];
    if ([classid isEqualToString:_class_id]) {
        [cell setSelectLB:YES];
    }else{
        [cell setSelectLB:NO];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary * dict = self.dataSource[section];
    NSArray * subClasses = dict[@"smaclass"];
    HLLBHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLLBHeaderView"];
    headerView.delegate = self;
    headerView.index = section;
    headerView.isSelect = _isSelect;
    headerView.titleLable.text = [NSString stringWithFormat:@"%@",dict[@"classname"]];
    if (subClasses.count == 0 && section != self.dataSource.count -1) {
        [headerView hideBottomLine:YES];
    }else{
        [headerView hideBottomLine:NO];
    }
    NSString * classid =[NSString stringWithFormat:@"%@",dict[@"id"]];
    if ([classid isEqualToString:_class_id]) {
        [headerView setSelectLB:YES];
    }else{
        [headerView setSelectLB:NO];
    }
    NSLog(@"HLLBHeaderView = %@ ,section = %ld",headerView,section);
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitPTScreenH(45);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma Request
-(void)requestData:(NSString *)type success:(void(^)(NSArray *))success fail:(void(^)(NSArray *))fail{
    NSDictionary * dict = @{
                            @"type":type,
                            @"classname":_className?:@"",
                            @"cid":_cid?:@""
                            };
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/StoreClassEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = dict;
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

#pragma HLLBHeaderViewDelegate
-(void)tapTheViewSelect:(BOOL)select indexpath:(NSInteger)index{
    NSLog(@"点击了第%ld个headview",index);
    if (_lastIndexPath) {
        HLMDLBManagerCell * cell = [_tableView cellForRowAtIndexPath:_lastIndexPath];
        [cell cancelSelect];
        _lastIndexPath = nil;
    }
    if (_lastIndex != -1) {
        HLLBHeaderView * headerView = (HLLBHeaderView * )[_tableView headerViewForSection:_lastIndex];
        headerView.sanjiao.selected = NO;
    }
    _lastIndex = index;
    [self addYG];
}

//添加小类
-(void)addSmallClassAtIndexPath:(NSInteger)section className:(NSString *)name{
    [self.inputField resignFirstResponder];
    if (![name hl_isAvailable]) {
        [HLTools showWithText:@"添加内容不能为空"];
        return;
    }
    _className = name;
    NSDictionary *dict = self.dataSource[section];
    _cid = dict[@"id"];
    MJWeakSelf;
    [self requestData:@"3" success:^(NSArray *datas) {
        [HLTools showWithText:@"已添加"];
        [weakSelf getList];
        [[NSNotificationCenter defaultCenter]postNotificationName:HLModefyStoreClassNotifi object:nil];
    } fail:nil];
}

-(void)deleteBigClassAtIndexPath:(NSInteger)section{
    [self.inputField resignFirstResponder];
    NSDictionary *dict = self.dataSource[section];
    _cid = dict[@"id"];
    MJWeakSelf;
    [self requestData:@"4" success:^(NSArray *datas) {
        [HLTools showWithText:@"已删除"];
        [weakSelf.dataSource removeObject:dict];
        [weakSelf.tableView reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:HLModefyStoreClassNotifi object:nil];
        if (weakSelf.dataSource.count == 0) {
            [HLEmptyDataView emptyViewWithFrame:CGRectMake(0, FitPTScreenH(44), ScreenW, CGRectGetMaxY(weakSelf.tableView.bounds) - FitPTScreenH(44)) superView:self.tableView type:@"0" balock:^{
                
            }];
        }
    } fail:nil];
}
#pragma HLMDLBManagerCellDelegate
-(void)didselectcellAt:(NSIndexPath *)index sender:(UIButton *)sender{
    NSLog(@"点击了第%ld个cell上的选择按钮",index.row);
    if (_lastIndexPath) {
        HLMDLBManagerCell * cell = [_tableView cellForRowAtIndexPath:_lastIndexPath];
        [cell cancelSelect];
    }
    if (_lastIndex != -1) {
        HLLBHeaderView * headerView = (HLLBHeaderView * )[_tableView headerViewForSection:_lastIndex];
        headerView.sanjiao.selected = NO;
        _lastIndex = -1;
    }
    _lastIndexPath = index;
    [self addYG];
}

//删除小类
-(void)deleteSmallClassAtIndexPath:(NSIndexPath *)index{
    [self.inputField resignFirstResponder];
    NSDictionary *dict = self.dataSource[index.section];
    NSArray *item = dict[@"smaclass"];
    _cid = item[index.row][@"id"];
    MJWeakSelf;
    [self requestData:@"4" success:^(NSArray *datas) {
        [HLTools showWithText:@"已删除"];
        [weakSelf getList];
        //通知更新门店列表
        [[NSNotificationCenter defaultCenter]postNotificationName:HLModefyStoreClassNotifi object:nil];
    } fail:nil];
}
-(void)cancelFirstResponder{
    [self.inputField resignFirstResponder];
}
@end
