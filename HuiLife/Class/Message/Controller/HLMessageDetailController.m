//
//  HLMessageDetailController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/9/12.
//

#import "HLMessageDetailController.h"
#import "HLMessageDetailViewCell.h"

@interface HLMessageDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView * tableView;

@property(strong,nonatomic)UIImageView * bagView;

@property(strong,nonatomic)UIImageView * headView;

@property(strong,nonatomic)UILabel * storeName;

@property(strong,nonatomic)UILabel * add;

@property(strong,nonatomic)UILabel * moneyLb;

@property(strong,nonatomic)UILabel * yuan;

@property(strong,nonatomic) NSArray * dataSource;

@end

@implementation HLMessageDetailController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTransparentNavtion];
    [self hl_setTitle:@"账单详情" andTitleColor:[UIColor whiteColor]];
    [self hl_setBackImage:@"back_white"];
}


-(NSAttributedString *)moneyAttrWithMoney:(NSString *)money{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:money];
    NSRange range = NSMakeRange(0, 1);
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(23)]} range:range];
    return attr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}


- (void)loadData{
    NSDictionary *params = @{@"order_id":self.order_id?:@"",@"sodm":@(self.sodm)};;
    if(self.listModel){
       params  = @{@"order_id":self.listModel.order_id,@"sodm":@(self.listModel.sodm)};
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/MessageDetail.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = params;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        NSArray * datas = result.data;
        [self configDataDict:datas.firstObject];
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)configDataDict:(NSDictionary *)dict{
    // 店铺图片
    [_headView sd_setImageWithURL:[NSURL URLWithString:dict[@"logo"]]];
    // 店铺名称
    _storeName.text = dict[@"store_oriange"];
    //
//    _money.text = dict[@"amount"];
    float money = [dict[@"amount"] floatValue];
    NSString * moneyText = [NSString stringWithFormat:@"￥%.2f",money];
    _moneyLb.attributedText = [self moneyAttrWithMoney:moneyText];
    
    NSString *state = @"";

    if (self.listModel) {
        state = self.listModel.sodm == 1 ? @"收款成功" : @"退款成功";
        _add.text = self.listModel.sodm == 1 ? @"+" : @"-";
    }else{
        state = self.sodm == 1 ? @"收款成功" : @"退款成功";
        _add.text = self.sodm == 1 ? @"+" : @"-";
    }
    
    double weixin = [dict[@"weixin_price"] doubleValue];
    double balance = [dict[@"use_balance"] doubleValue];
    double use_consume_money = [dict[@"use_consume_money"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"use_consume_money"] doubleValue]; // 消费金
    
    
    NSMutableString *tradeType = [NSMutableString string];
    if (weixin > 0) {
        [tradeType appendFormat:@"微信￥%.2lf",weixin];
    }
    if (balance > 0) {
        [tradeType appendFormat:@"余额￥%.2lf",balance];
    }
    if (use_consume_money > 0) {
        [tradeType appendFormat:@"消费金￥%.2lf",use_consume_money];
    }
 
    NSString * payWay = [NSString stringWithFormat:@"%@",[HLTools toStringWithObj:dict[@"pay_money"]]];
    
    NSString *zf_order_id = [dict[@"zf_order_id"] isKindOfClass:[NSNull class]] ? @"无" : dict[@"zf_order_id"];
    
    self.dataSource = @[
                        @{@"title":@"昵称",@"text":[HLTools toStringWithObj:dict[@"nick_name"]]?:@""},
                        @{@"title":@"电话",@"text":[HLTools toStringWithObj:dict[@"mobile"]]?:@""},
                        @{@"title":@"桌号",@"text":[HLTools toStringWithObj:dict[@"zhuohao"]]?:@""},
                        @{@"title":@"人数",@"text":[HLTools toStringWithObj:dict[@"people_num"]]?:@""},
                        @{@"title":@"订单号",@"text":[HLTools toStringWithObj:dict[@"id"]]?:@""},
                        @{@"title":@"订单类型",@"text":[HLTools toStringWithObj:dict[@"source"]]?:@""},
                        @{@"title":@"交易状态",@"text":state?:@""},
                        @{@"title":@"交易时间",@"text":dict[@"cj_time"]?:@""},
                        @{@"title":@"交易方式",@"text":payWay?:payWay},
                        @{@"title":@"交易单号",@"text":zf_order_id?:@""},
                        
                        ];
    [self.tableView reloadData];
}

#pragma mark - UI
-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    AdjustsScrollViewInsetNever(self,_tableView);
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = FitPTScreen(53);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[HLMessageDetailViewCell class] forCellReuseIdentifier:@"HLMessageDetailViewCell"];
    
    _bagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(224) + HIGHT_NavBar_MARGIN)];
    _bagView.image = [UIImage imageNamed:@"mesg_header_bg"];
    _tableView.tableHeaderView = _bagView;
    
    _headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_circle_default"]];
    _headView.layer.cornerRadius = FitPTScreen(54) / 2;
    _headView.clipsToBounds = YES;
    [_bagView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bagView);
        make.top.equalTo(FitPTScreen(74) + HIGHT_NavBar_MARGIN);
        make.size.equalTo(CGSizeMake(FitPTScreen(54), FitPTScreen(54)));
    }];

    _storeName = [[UILabel alloc]init];
    _storeName.textColor = [UIColor whiteColor];
    _storeName.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _storeName.lineBreakMode = NSLineBreakByTruncatingTail;
    _storeName.textAlignment = NSTextAlignmentCenter;
    [_bagView addSubview:_storeName];
    [_storeName makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bagView);
        make.top.equalTo(self.headView.bottom).offset(FitPTScreen(15));
    }];

    _moneyLb = [[UILabel alloc]init];
    _moneyLb.font = [UIFont systemFontOfSize:FitPTScreen(35)];
    _moneyLb.textColor = [UIColor whiteColor];
    [_bagView addSubview:_moneyLb];
    [_moneyLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.storeName);
        make.top.equalTo(self.storeName.bottom).offset(FitPTScreen(13));
    }];
    
}

#pragma mark - Array


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLMessageDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLMessageDetailViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.titleLable.text = dict[@"title"];
    cell.subLable.text = [dict[@"text"] hl_isAvailable]?dict[@"text"]:@"---";
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//amount = "8.99";  // 钱
//"buy_store_id" = 30636; //
//"chengjiao_price" = "8.99"; //
//"cj_time" = "2018-09-04 10:35:41"; 时间
//id = 961880;      // 订单号
//logo = "http://aimg8.oss-cn-shanghai"; 头像
//source = "\U626b\U7801\U70b9\U9910"; 订单类型
//"store_name" = fhgjdhckchkjcgj; // 店铺名称
//type = 18;
//"use_balance" = "0.00"; 余额
//"use_consume_money" = "0.00"; 消费金
//"weixin_price" = "8.99"; 微信
//"zf_order_id" = 4200000159201809042890827709; 交易单号
// sodm 1 收款成功 2退款成功 交易状态

@end
