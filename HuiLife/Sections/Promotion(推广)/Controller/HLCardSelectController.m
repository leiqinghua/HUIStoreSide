//
//  HLCardSelectController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/10.
//

#import "HLCardSelectController.h"
#import "HLCardSelectViewCell.h"

@interface HLCardSelectController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView * nodataView;

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)HLCardSelectModel * selectModel;

@property(nonatomic,strong)NSMutableArray * datasource;

@property(nonatomic,assign)NSInteger page;

@end

@implementation HLCardSelectController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"卡列表"];
}

//确定
-(void)addClick{
    if (self.cardPromoteBlock) {
        self.cardPromoteBlock(_selectModel.cardName,_selectModel.price,_selectModel.cardId);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self creatFootView];
    _page =1;
    [self loadPromoteList];
}

// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLCardSelectViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLCardSelectViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.baseModel = self.datasource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLCardSelectModel * model = self.datasource[indexPath.row];
    if (model.isExtConupon) {
        return;
    }
    if (![_selectModel isEqual:model]) {
        _selectModel.select = false;
        model.select = YES;
        _selectModel = model;
        [tableView reloadData];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = FitPTScreen(191);
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(15))];
        [_tableView registerClass:[HLCardSelectViewCell class] forCellReuseIdentifier:@"HLCardSelectViewCell"];
    }
    return _tableView;
}

-(void)showNodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _nodataView.backgroundColor = UIColor.whiteColor;
        
        UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_card_default"]];
        [_nodataView addSubview:imageV];
        [imageV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(162));
            make.centerX.equalTo(self.nodataView);
        }];
        
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.textColor = UIColorFromRGB(0x999999);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        tipLb.text = @"暂无进行中卡";
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

//获取可推广的卡列表
-(void)loadPromoteList{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Cardmarket/getExtCardList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"page":@(_page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleListDataWithData:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)handleListDataWithData:(NSDictionary *)dict{
    if (_page == 1) {
        [self.datasource removeAllObjects];
    }
    NSArray * datas = [HLCardSelectModel mj_objectArrayWithKeyValuesArray:dict[@"cardDatas"]];
    [self.datasource addObjectsFromArray:datas];
    if (!self.datasource.count) {
        [self showNodataView];
    }else{
        [_nodataView removeFromSuperview];
        [self.tableView hideFooter:false];
    }
    NSInteger count = [dict[@"cardPage"] integerValue];
    if (_page >=count) {
        [self.tableView endNomorData];
    }
    [self.tableView reloadData];
}
@end
