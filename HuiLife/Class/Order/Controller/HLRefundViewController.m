//
//  HLRefundViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/25.
//

#import "HLRefundViewController.h"
#import "HLRefoundGoodViewCell.h"
#import "HLExpressionView.h"
#import "HLRefundModel.h"
#import "HLRefundReasonView.h"

@interface HLRefundViewController ()<UITableViewDelegate,UITableViewDataSource,HLRefoundGoodViewCellDelegate>{
}
//选择的退款原因
@property(assign,nonatomic)NSInteger selectIndex;

@property(strong,nonatomic)UIScrollView * scrollView;

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)UIButton *bottomButton;

@property (strong,nonatomic)UILabel * taxNum;//税号

@property (strong,nonatomic)UILabel * zhuohao;//桌号

@property (strong,nonatomic)UIButton * refoundBtn;//全部退款
//用户收到的退款金额
@property (strong,nonatomic)HLExpressionView * userPrice;
//商家承担的退款金额
@property (strong,nonatomic)HLExpressionView * storePrice;

@property (strong,nonatomic)UILabel * tipLable;//温馨提示

@property(strong,nonatomic)HLRefundModel *refundModel;
//参数
@property(strong,nonatomic)NSMutableDictionary * pargram;

@end

@implementation HLRefundViewController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setBackgroundColor:UIColorFromRGB(0xFF8D26)];
    [self hl_setTitle:@"退款" andTitleColor:[UIColor whiteColor]];
}

-(void)cancelClick:(UIButton *)sender{
    [self hl_goback];
}

//提交按钮
-(void)bottomButtonClick{
    if (self.pargram.count == 0) {
        [HLTools showWithText:@"请选择商品"];
        return;
    }
    NSArray * ids = [NSObject allKeysWithDictionary:self.pargram];
    NSMutableArray * nums = [NSMutableArray array];
    for (int i=0; i<ids.count; i++) {
        NSDictionary * dict = self.pargram[ids[i]];
        [nums addObject:dict[@"num"]];
    }
    [self loadDataWithType:2 ids:ids nums:nums];
}

-(void)refoundBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.pargram removeAllObjects];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hl_StringToColor:@"#F8F8F8"];
    [self initNavi];
    [self initBottomButton];
    _selectIndex = 1;
    [self loadDataWithType:1 ids:nil nums:nil];
}

-(void)initNavi{
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBar;
}

-(void)initBottomButton{
    _bottomButton = [[UIButton alloc]init];
    _bottomButton.backgroundColor = [UIColor hl_StringToColor:@"#FF8D26"];
    [_bottomButton setTitle:@"提交" forState:UIControlStateNormal];
    [_bottomButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _bottomButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.view addSubview:_bottomButton];
    [_bottomButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(FitPTScreen(44));
        make.bottom.equalTo(-Height_Bottom_Margn);
    }];
    [_bottomButton addTarget:self action:@selector(bottomButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initSubView{
    CGFloat tableView_h = self.refundModel.pro_info.count * FitPTScreen(75);
    CGFloat bottomView_h = tableView_h + FitPTScreen(58) + FitPTScreen(96);
    CGFloat totleHight = bottomView_h + FitPTScreen(100) + FitPTScreen(15);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH -Height_NavBar - FitPTScreen(49))];
    _scrollView.contentSize = CGSizeMake(ScreenW, totleHight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:_scrollView];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(FitPTScreen(20), FitPTScreen(15),FitPTScreen(335),bottomView_h)];
    bottomView.backgroundColor = UIColor.whiteColor;
    bottomView.layer.cornerRadius = 3;
    bottomView.layer.shadowColor =UIColorFromRGB(0xFFFFFF).CGColor;
    bottomView.layer.shadowRadius = 1;
    bottomView.layer.shadowOpacity = 0.8f;
    bottomView.layer.masksToBounds = false;
    bottomView.clipsToBounds = false;
    bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    [_scrollView addSubview:bottomView];
    
    _taxNum = [[UILabel alloc]init];
    _taxNum.attributedText = _refundModel.idAttr;

    [bottomView addSubview:_taxNum];
    [_taxNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _zhuohao = [[UILabel alloc]init];
    _zhuohao.text = _refundModel.deskNumText;
    
    _zhuohao.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _zhuohao.textColor = [UIColor hl_StringToColor:@"#989898"];
    [bottomView addSubview:_zhuohao];
    [_zhuohao makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.taxNum.mas_right).offset(FitPTScreen(26));
        make.centerY.equalTo(self.taxNum);
    }];
    
    _refoundBtn = [[UIButton alloc]init];
    [_refoundBtn setTitle:@"全部退款" forState:UIControlStateNormal];
    [_refoundBtn setTitle:@"取消" forState:UIControlStateSelected];
    _refoundBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_refoundBtn setTitleColor:[UIColor hl_StringToColor:@"#656565"] forState:UIControlStateNormal];
    [bottomView addSubview:_refoundBtn];
    [_refoundBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.centerY.equalTo(self.zhuohao);
    }];
    [_refoundBtn addTarget:self action:@selector(refoundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, FitPTScreen(58), CGRectGetMaxX(bottomView.bounds),tableView_h) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever(self,_tableView);
    [bottomView addSubview:_tableView];
    [_tableView registerClass:[HLRefoundGoodViewCell class] forCellReuseIdentifier:@"HLRefoundGoodViewCell"];
    
    _userPrice = [[HLExpressionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), CGRectGetMaxX(bottomView.bounds), FitPTScreen(48)) show:NO];
    [_userPrice setContent:@"" type:HLExpressionAcceptTKType];
    [_userPrice showPrice:@"￥0.00"];
    [bottomView addSubview:_userPrice];
    
    _storePrice = [[HLExpressionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_userPrice.frame), CGRectGetMaxX(bottomView.bounds), FitPTScreen(48)) show:NO];
    [_storePrice setContent:@"" type:HLExpressionBearTKType];
    [_storePrice showPrice:@"￥0.00"];
    [bottomView addSubview:_storePrice];
    
    HLRefundReasonView * reasonView = [[HLRefundReasonView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:reasonView];
    weakify(self);
    reasonView.select = ^(NSInteger index) {
        weak_self.selectIndex = index;
    };
    [reasonView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(bottomView.mas_bottom).offset(FitPTScreen(20));
        make.width.equalTo(bottomView);
        make.height.equalTo(FitPTScreen(45));
    }];
    
    _tipLable = [[UILabel alloc]init];
    _tipLable.attributedText = _refundModel.tipAttr;
    _tipLable.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_scrollView addSubview:_tipLable];
    [_tipLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(reasonView.mas_bottom).offset(FitPTScreen(20));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refundModel.pro_info.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitPTScreen(75);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLRefoundGoodViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLRefoundGoodViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.goodModel = _refundModel.pro_info[indexPath.row];
    cell.delegate = self;
    cell.selectAll = _refoundBtn.selected;
    
    return cell;
}

#pragma mark -HLRefoundGoodViewCellDelegate
-(void)cell:(HLRefoundGoodViewCell *)cell changeNumWithModel:(HLRefundGoodModel *)model{

    if (_refundModel.totleCount > 0 ) {
       _refoundBtn.selected = self.refundModel.is_zd;
    }
    // user:用户收到的退款金额，store:商家承担的
    NSDictionary * dict = @{
                            @"num":@(model.selectNum),
                            @"user":@(model.ss_price.floatValue * model.selectNum),
                            @"store":@(model.sd_price.floatValue * model.selectNum)
                            };
    [self.pargram setObject:dict forKey:model.Id];
    
    //计算用户收到的退款金额
    CGFloat userMoney = 0.0;
    CGFloat storeMoney = 0.0;
    for (NSString *key in self.pargram.allKeys) {
        NSDictionary * value = self.pargram[key];
        userMoney += [value[@"user"] floatValue];
        storeMoney+= [value[@"store"] floatValue];
    }
    
    [_userPrice showPrice:[NSString stringWithFormat:@"%.2lf",userMoney]];
    [_storePrice showPrice:[NSString stringWithFormat:@"%.2lf",storeMoney]];
    
    if (model.selectNum == 0) {
        if ([[self.pargram allKeys] containsObject:model.Id]) {
            [self.pargram removeObjectForKey:model.Id];
        }
    }
    
}


//1-默认值，2-退款,
/*
 is_zd:1全退，2部分退
 dd_ids:商品id，数组
 nums:商品的数量
 */
-(void)loadDataWithType:(NSInteger)type ids:(NSArray *)ids nums:(NSArray *)nums{
    NSDictionary * pargram = @{
                               @"type":@(type),
                               @"order_id":_orderid?:@"",
                               @"dd_ids":ids?[ids mj_JSONString]:@"",
                               @"nums":nums?[nums mj_JSONString]:@"",
                               @"refuse":@(_selectIndex),
                               @"is_zd":_refundModel.is_zd?@"1":@"2"
                               };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/OrderRefund.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        [self handleDataWithType:type model:result];
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)handleDataWithType:(NSInteger)type model:(XMResult *)model{
    if (type == 2) {
        if (model.code == 200) {
           [HLTools showWithText:@"退款成功"];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"3",@(_type)]];
        
        return;
    }
    NSArray * datas = model.data;
    NSDictionary * dataDict = datas.firstObject;
    HLRefundModel * refundModel = [HLRefundModel mj_objectWithKeyValues:dataDict];
    _refundModel = refundModel;
    if (type == 1) {
        [self initSubView];
    }
}

-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}

@end
