//
//  HLAddPromotionController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import "HLAddPromotionController.h"
#import "HLRightInputViewCell.h"
#import "HLTGLevelViewCell.h"
#import "HLCardSelectController.h"
#import "HLTicketSelectController.h"

@interface HLAddPromotionController ()<UITableViewDelegate,UITableViewDataSource,HLRightInputViewCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property (nonatomic, copy) NSMutableArray *dataSource;
//售价
@property(nonatomic,strong)HLRightInputTypeInfo *priceInfo;
//低价
@property(nonatomic,strong)HLRightInputTypeInfo *diPrice;

@property(nonatomic,strong)NSMutableDictionary * pargram;

@end

@implementation HLAddPromotionController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:_cardPromote?@"卡推广":@"代金券推广"];
}

-(void)nextClick{
    
    for (HLBaseTypeInfo *info in self.dataSource) {
        // 如果必须要验证参数，那么就判断参数
        if (info.needCheckParams && ![info checkParamsIsOk]) {
            HLShowHint(info.errorHint, self.view);
            return;
        }
        // 参数验证通过，先判断 mParams ，再去设置text
        if(info.mParams.count > 0){
            [self.pargram setValuesForKeysWithDictionary:info.mParams];
        }
        
        if (info.saveKey) {
            [self.pargram setValue:info.text forKey:info.saveKey];
        }
    }
    
     [self addPromoteData];
    
    HLLog(@"pargram = %@",self.pargram);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self creatFootView];
}

/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLTGLevelViewCell class] forCellReuseIdentifier:@"HLTGLevelViewCell"];
        
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault:
        {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case HLInputCellTypeTGLevel:
        {
             HLTGLevelViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"HLTGLevelViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    return [info cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    weakify(self);
    
    if (indexPath.row == 0) {
        if (_cardPromote) {
            HLCardSelectController * cardSelect = [[HLCardSelectController alloc]init];
            cardSelect.cardPromoteBlock = ^(NSString * _Nonnull name, NSString * _Nonnull price, NSString * _Nonnull Id) {
                info.text = name;
                info.mParams = @{@"objId":Id};
                weak_self.priceInfo.text = price;
                [weak_self changePromoteLevel];
                [tableView reloadData];
            };
            [self hl_pushToController:cardSelect];
            return;
        }
        
        HLTicketSelectController * selectTicket = [[HLTicketSelectController alloc]init];
        selectTicket.ticketPromoteBlock = ^(NSString * _Nonnull name, NSString * _Nonnull price, NSString * _Nonnull Id) {
            info.text = name;
            info.mParams = @{@"objId":Id};
            weak_self.priceInfo.text = price;
            [weak_self changePromoteLevel];
            [tableView reloadData];
        };
        [self hl_pushToController:selectTicket];
        return;
    }
}


#pragma mark - HLRightInputViewCellDelegate
-(void)inputViewCell:(HLRightInputViewCell *)cell textChanged:(HLRightInputTypeInfo *)inputInfo{
        
    if (![inputInfo isEqual:_diPrice]) {
        return;
    }
    
    HLTGLevelInfo * promoteInfo = self.dataSource.lastObject;
    
    
    if ([_priceInfo.text floatValue] == 0) {
        promoteInfo.levle = 0;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    double disCount = 0;
    
    if ([self.priceInfo.text floatValue] > 0.0) {
        if (inputInfo.text.floatValue == 0) {
            disCount = 0.0;
        }else{
            NSDecimalNumber *diPrice = [NSDecimalNumber decimalNumberWithString:inputInfo.text];
            NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.priceInfo.text];
            
            NSDecimalNumber *average = [diPrice decimalNumberByDividingBy:price];
            disCount =  [average doubleValue];
            HLLog(@"diPrice = %@ ,price = %@, disCount = %lf",diPrice,price,disCount);
        }
    }
    
    if (disCount >= 0.9) {
        promoteInfo.levle = 0;
    }else if (disCount > 0.8){
        promoteInfo.levle = 1;
    }else{
        promoteInfo.levle = 2;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


-(void)changePromoteLevel{
    HLTGLevelInfo * promoteInfo = self.dataSource.lastObject;
    double disCount = 0;
    if ([self.priceInfo.text floatValue] > 0.0) {
        if (self.diPrice.text.floatValue == 0) {
            disCount = 0.0;
        }else{
            NSDecimalNumber *diPrice = [NSDecimalNumber decimalNumberWithString:self.diPrice.text];
            NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.priceInfo.text];
            NSDecimalNumber *average = [diPrice decimalNumberByDividingBy:price];
            disCount =  [average doubleValue];
        }
    }
    if (disCount >= 0.9) {
        promoteInfo.levle = 0;
    }else if (disCount > 0.8){
        promoteInfo.levle = 1;
    }else{
        promoteInfo.levle = 2;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


-(NSMutableDictionary *)pargram{
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
    }
    return _pargram;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        
        HLRightInputTypeInfo *companyInfo = [[HLRightInputTypeInfo alloc] init];
        companyInfo.leftTip = _cardPromote?@"*卡推广":@"*代金券推广";
        companyInfo.placeHoder = _cardPromote?@"选择体验卡":@"选择代金券";
        companyInfo.showRightArrow = YES;
        companyInfo.cellHeight = FitPTScreen(51);
        companyInfo.canInput = false;
        companyInfo.needCheckParams = YES;
        companyInfo.errorHint = _cardPromote?@"请选择推广卡" :@"请选择推广代金券";
        
        HLRightInputTypeInfo *priceInfo = [[HLRightInputTypeInfo alloc] init];
        priceInfo.leftTip = @"*售价";
        priceInfo.placeHoder = @"¥售价 可填0为免费领取";
        priceInfo.needCheckParams = YES;
        priceInfo.cellHeight = FitPTScreen(51);
        priceInfo.canInput = false;
        priceInfo.needCheckParams = YES;
        priceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        _priceInfo = priceInfo;
        priceInfo.errorHint = _cardPromote?@"请输入售价" :@"请输入售价";
        
        HLRightInputTypeInfo *diPrice = [[HLRightInputTypeInfo alloc] init];
        diPrice.leftTip = @"*底价";
        diPrice.placeHoder = @"¥商品给平台最低价";
        diPrice.cellHeight = FitPTScreen(51);
        diPrice.canInput = YES;
        diPrice.saveKey = @"floorPrice";
        diPrice.needCheckParams = YES;
        diPrice.keyBoardType = UIKeyboardTypeDecimalPad;
        diPrice.canInputZero = YES;
        diPrice.errorHint = _cardPromote?@"请输入底价" :@"请输入底价";
        _diPrice = diPrice;
        
        HLRightInputTypeInfo *numberInfo = [[HLRightInputTypeInfo alloc] init];
        numberInfo.leftTip = @"*平台数量";
        numberInfo.placeHoder = @"商品给平台数量";
        numberInfo.cellHeight = FitPTScreen(51);
        numberInfo.canInput = YES;
        numberInfo.saveKey = @"platfNum";
        numberInfo.needCheckParams = YES;
        numberInfo.keyBoardType = UIKeyboardTypeNumberPad;
        numberInfo.errorHint = _cardPromote?@"请输入平台数量" :@"请输入平台数量";
        
        HLTGLevelInfo *levleInfo = [[HLTGLevelInfo alloc] init];
        levleInfo.type = HLInputCellTypeTGLevel;
        levleInfo.leftTip = @"推广强度";
        levleInfo.cellHeight = FitPTScreen(51);

        _dataSource = [NSMutableArray array];
        [_dataSource addObject:companyInfo];
        [_dataSource addObject:priceInfo];
        [_dataSource addObject:diPrice];
        [_dataSource addObject:numberInfo];
        [_dataSource addObject:levleInfo];
    }
    return _dataSource;
}


-(void)addPromoteData{
    HLLoading(self.view);
    NSString * api = @"/Shopplus/Extencard/addExtenCard";
    if (!_cardPromote) {
        api = @"/Shopplus/Extencoupon/addExtenCoupon";
    }
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = api ;
        request.serverType = HLServerTypeStoreService;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            if (!self.cardPromote) {
                [HLNotifyCenter postNotificationName:HLReloadTicketListNotifi object:nil];
            }else{
                [HLNotifyCenter postNotificationName:HLReloadCardListNotifi object:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }

    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}
@end
