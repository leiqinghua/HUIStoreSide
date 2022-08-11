//
//  HLCollegeFindController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/28.
//

#import "HLCollegeFindController.h"
#import "HLCollegeFindViewCell.h"
#import "HLCollegeDesViewCell.h"

@interface HLCollegeFindController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSArray * datasource;

@property(nonatomic,strong)UILabel * historyLb;

@property(nonatomic,strong)NSMutableDictionary * pargram;

@property(nonatomic,strong)NSDictionary * result;
@end

@implementation HLCollegeFindController

/// 这个不能去掉，因为修改导航栏样式是在 baseVC viewWillAppear,嵌套的是不需要实现该方法
-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self loadDefaultData];
}


-(void)askBtnClick{
    for (HLInfoModel * model in self.datasource) {
        if (model.needCheckParams && ![model checkParamsIsOk]) {
            HLShowHint(model.errorHint, self.view);
            return;
        }
        
        if (model.key.length) {
            [self.pargram setObject:model.text forKey:model.key];
        }
    }
    
    [self upAskData];
    
}

//历史记录
-(void)recordClick{
    [HLTools pushAppPageLink:self.result[@"iosArdess"] params:self.result[@"iosParam"] needBack:false];
}

/// 加载数据
- (void)loadData{
    [self loadDefaultData];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = UIColorFromRGB(0xf4f5f4);
        AdjustsScrollViewInsetNever(self, _tableView);
        
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(119))];
        _tableView.tableHeaderView = headerView;
        
        UIButton * tipBtn = [[UIButton alloc]init];
        tipBtn.userInteractionEnabled = false;
        [tipBtn setTitle:@" 店铺推广找专家" forState:UIControlStateNormal];
        [tipBtn setImage:[UIImage imageNamed:@"college_tip"] forState:UIControlStateNormal];
        tipBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipBtn setTitleColor:UIColorFromRGB(0x444444) forState:UIControlStateNormal];
        [headerView addSubview:tipBtn];
        [tipBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView);
            make.top.equalTo(FitPTScreen(43));
        }];
        
        UIView * leftLine = [[UIView alloc]init];
        leftLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [headerView addSubview:leftLine];
        [leftLine makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tipBtn.left).offset(FitPTScreen(-10));
            make.centerY.equalTo(tipBtn);
            make.width.equalTo(FitPTScreen(39));
            make.height.equalTo(1);
        }];
        
        UIView * rightLine = [[UIView alloc]init];
        rightLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [headerView addSubview:rightLine];
        [rightLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipBtn.right).offset(FitPTScreen(10));
            make.centerY.equalTo(tipBtn);
            make.width.equalTo(FitPTScreen(39));
            make.height.equalTo(1);
        }];
        
        UILabel * subLb = [[UILabel alloc]init];
        subLb.text = @"提交您的店铺，免费获取专家推广方案";
        subLb.textColor = UIColorFromRGB(0x999999);
        subLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
        [headerView addSubview:subLb];
        [subLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView);
            make.top.equalTo(tipBtn.bottom).offset(FitPTScreen(15));
        }];
        
        
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(250))];
        _tableView.tableFooterView = footerView;
        
        UIButton * askBtn = [[UIButton alloc]init];
        [askBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
        [askBtn setTitle:@"我要提问" forState:UIControlStateNormal];
        askBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [askBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [askBtn addTarget:self action:@selector(askBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:askBtn];
        [askBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footerView);
            make.top.equalTo(FitPTScreen(25));
            make.width.equalTo(FitPTScreen(307));
            make.height.equalTo(FitPTScreen(72));
        }];
        
        
        UIView * historyBg = [[UIView alloc]init];
        historyBg.backgroundColor = UIColor.whiteColor;
        historyBg.layer.cornerRadius = FitPTScreen(7);
        [footerView addSubview:historyBg];
        [historyBg makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(13));
            make.right.equalTo(FitPTScreen(-13));
            make.top.equalTo(askBtn.bottom).offset(FitPTScreen(13));
            make.height.equalTo(FitPTScreen(57));
        }];
        UITapGestureRecognizer * tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recordClick)];
        [historyBg addGestureRecognizer:tapClick];
        
        
        
        UIButton * recordBtn = [[UIButton alloc]init];
        recordBtn.userInteractionEnabled = false;
        [recordBtn setTitle:@" 历史提问记录" forState:UIControlStateNormal];
        [recordBtn setImage:[UIImage imageNamed:@"time_oriange"] forState:UIControlStateNormal];
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [recordBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [historyBg addSubview:recordBtn];
        [recordBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(historyBg);
            make.left.equalTo(FitPTScreen(17));
        }];
        
        UIImageView * arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
        [historyBg addSubview:arrow];
        [arrow makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(historyBg);
            make.right.equalTo(FitPTScreen(-15));
        }];
        
        _historyLb = [[UILabel alloc]init];
        _historyLb.textColor = UIColorFromRGB(0x888888);
        _historyLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [historyBg addSubview:_historyLb];
        [_historyLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(historyBg);
            make.right.equalTo(arrow.left).offset(FitPTScreen(-8));
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLInfoModel * model = self.datasource[indexPath.row];
    if (model.type == HLInfoCollegeDesType) {
        HLCollegeDesViewCell * cell = [HLCollegeDesViewCell dequeueReusableCell:tableView];
        cell.infoModel = model;
        return cell;
    }
    HLCollegeFindViewCell * cell = [HLCollegeFindViewCell dequeueReusableCell:tableView];
    cell.infoModel = self.datasource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLInfoModel * model = self.datasource[indexPath.row];
    return model.cellHight;
}


-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}

-(NSArray *)datasource{
    if (!_datasource) {
        
        HLInfoModel * typeInfo = [[HLInfoModel alloc]init];
        typeInfo.leftPic = @"store_oriange";
        typeInfo.leftText = @"店铺类型：";
        typeInfo.placeHolder = @"请输入店铺类型";
        typeInfo.cellHight = FitPTScreen(50);
        typeInfo.needCheckParams = YES;
        typeInfo.errorHint = @"请输入店铺类型";
        typeInfo.key = @"business_type";
        
        HLInfoModel * mesInfo = [[HLInfoModel alloc]init];
        mesInfo.leftPic = @"college_phone";
        mesInfo.leftText = @"联系方式：";
        mesInfo.placeHolder = @"请输入联系方式";
        mesInfo.keyboardType = UIKeyboardTypePhonePad;
        mesInfo.cellHight = FitPTScreen(50);
        mesInfo.needCheckParams = YES;
        mesInfo.errorHint = @"请输入联系方式";
        mesInfo.key = @"mobile";
        
        HLCollegeDesModel * desInfo = [[HLCollegeDesModel alloc]init];
        desInfo.placeHolder = @"请输入推广需求描述";
        desInfo.leftPic = @"edit_blue";
        desInfo.leftText = @"推广需求描述：";
        desInfo.cellHight = FitPTScreen(218);
        desInfo.maxNum = 500;
        desInfo.showNumLb = YES;
        desInfo.type = HLInfoCollegeDesType;
        desInfo.needCheckParams = YES;
        desInfo.errorHint = @"请输入推广需求描述";
        desInfo.key = @"question";
        
        _datasource = @[typeInfo,mesInfo,desInfo];
        
    }
    return _datasource;
}


-(void)loadDefaultData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Shotcollege/aqAdd";
        request.serverType = HLServerTypeStoreService;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            self.result = result.data;
            self.historyLb.text = result.data[@"newAnswerInfo"]?:@"";
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


-(void)upAskData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Shotcollege/aqInsert";
        request.serverType = HLServerTypeStoreService;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self loadDefaultData];
            for (HLInfoModel * info in self.datasource) {
                info.text = @"";
            }
            [self.tableView reloadData];
            HLShowHint(@"提问成功", self.view);
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

@end
