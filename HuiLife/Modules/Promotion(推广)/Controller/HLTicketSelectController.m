//
//  HLTicketSelectController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/11.
//

#import "HLTicketSelectController.h"
#import "HLTicketSelectViewCell.h"

@interface HLTicketSelectController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)UIView * nodataView;

@property(nonatomic,strong)NSMutableArray * datasource;

@property(nonatomic,strong)HLTicketPromoteAble * selectModel;

@end

@implementation HLTicketSelectController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"代金券推广"];
}

//确定
-(void)addBtnClick{
    if (!_selectModel) {
        HLShowHint(@"请选择可推广代金券", self.view);
        return;
    }
    
    if (self.ticketPromoteBlock) {
        self.ticketPromoteBlock(_selectModel.echoDisplay,_selectModel.price,_selectModel.couponId);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    _page = 1;
    [self loadPromoteAbleList];
}

-(void)initView{
    
    self.view.backgroundColor = UIColor.whiteColor;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar-(FitPTScreen(10) + Height_Bottom_Margn + FitPTScreen(72))) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(15))];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"upload_btn"] forState:UIControlStateNormal];
    [addBtn setTitle:@"确定" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.view addSubview:addBtn];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(Height_Bottom_Margn);
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView footerWithEndText:@"没有更多信息" refreshingBlock:^{
        self.page ++;
        [self loadPromoteAbleList];
    }];
    
    [_tableView hideFooter:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLTicketSelectViewCell * cell = [HLTicketSelectViewCell dequeueReusableCell:tableView];
    cell.model = self.datasource[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLTicketPromoteAble * model = self.datasource[indexPath.row];
    if (model.isExtConupon) {//已被选择过
        return;
    }
    
    if (![_selectModel isEqual:model]) {
        _selectModel.select = false;
        model.select = YES;
        _selectModel = model;
        [self.tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLTicketPromoteAble * model = self.datasource[indexPath.row];
    return model.cellHight;
}



-(void)showNodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _nodataView.backgroundColor = UIColor.whiteColor;
        
        UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_ticket_default"]];
        [_nodataView addSubview:imageV];
        [imageV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(162));
            make.centerX.equalTo(self.nodataView);
        }];
        
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.textColor = UIColorFromRGB(0x999999);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        tipLb.text = @"暂无进行中代金券";
        [_nodataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.nodataView);
            make.top.equalTo(imageV.bottom).offset(FitPTScreen(20));
        }];
    }
    
    [self.tableView addSubview:_nodataView];
}


-(NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

-(void)loadPromoteAbleList{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Couponmanager/getExtConuponList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"page":@(_page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        
        if(result.code == 200){
            [self handleListDataWithData:result.data];
            return ;
        }
        
        if (self.page >1) self.page --;
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        if (self.page >1) self.page --;
    }];
}

-(void)handleListDataWithData:(NSDictionary *)dict{
    if (_page == 1) {
        [self.datasource removeAllObjects];
    }
    NSArray * datas = [HLTicketPromoteAble mj_objectArrayWithKeyValuesArray:dict[@"couponDatas"]];
    [self.datasource addObjectsFromArray:datas];
    if (!self.datasource.count) {
        [self showNodataView];
    }else{
        [_nodataView removeFromSuperview];
        [self.tableView hideFooter:false];
    }
    NSInteger count = [dict[@"countPage"] integerValue];
    if (_page >=count) {
        [self.tableView endNomorData];
    }
    [self.tableView reloadData];
}

@end
