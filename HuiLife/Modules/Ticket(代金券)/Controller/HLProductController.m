//
//  HLProductController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/7.
//

#import "HLProductController.h"
#import "HLInputDateViewCell.h"
#import "HLRightInputViewCell.h"
#import "HLProduceReviewController.h"

@interface HLProductController ()<UITableViewDelegate,UITableViewDataSource,HLInputDateViewCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * datasource;

@property(nonatomic,strong)NSArray * otherModels;

@end

@implementation HLProductController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"发布设置"];
}

//去发布
-(void)productClick{
    
    for (HLBaseTypeInfo *info in self.datasource) {
        if (info.needCheckParams && ![info checkParamsIsOk]) {
            HLShowHint(info.errorHint, self.view);
            return;
        }
        // 参数验证通过，先判断 mParams ，再去设置text
        [self.pargram setValue:info.text forKey:info.saveKey];
    }
    
    [self uploadDatas];
    HLLog(@"pargram = %@",self.pargram);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self creatFootView];
}

// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"去发布" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(productClick) forControlEvents:UIControlEventTouchUpInside];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLInputDateViewCell class] forCellReuseIdentifier:@"HLInputDateViewCell"];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
    }
    return _tableView;
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLBaseTypeInfo *info = self.datasource[indexPath.row];
    
    switch (info.type) {
        case HLInputCellTypeDefault:
        {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case HLInputCellTypeDate:
        {
            HLInputDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputDateViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseTypeInfo *info = self.datasource[indexPath.row];
    return [info cellHeight];
}

#pragma mark - HLInputDateViewCellDelegate
-(void)dateCell:(HLInputDateViewCell *)cell switchON:(BOOL)on{
    if (on && self.datasource.count ==1) {
        [self.datasource addObjectsFromArray:self.otherModels];
    }
    if (!on && self.datasource.count >1) {
        [self.datasource removeObjectsInArray:self.otherModels];
    }
    
    if (!on) {
        for (HLRightInputTypeInfo * info in self.otherModels) {
            info.text = @"";
            [self.pargram removeObjectForKey:info.saveKey];
        }
    }
    
    [self.tableView reloadData];
}


-(NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        HLInputDateInfo * date = [[HLInputDateInfo alloc]init];
        date.type = HLInputCellTypeDate;
        date.placeHoder = @"分享好友领取成功后，用户代金券增加金额";
        date.leftTip = @"分享领取后，用户可立得";
        date.dateType = 1;
        date.cellHeight = FitPTScreen(77);
        date.saveKey = @"isReward";
        [_datasource addObject:date];
    }
    return _datasource;
}

-(NSArray *)otherModels{
    if (!_otherModels) {
        HLRightInputTypeInfo * info1 = [[HLRightInputTypeInfo alloc]init];
        info1.canInput = YES;
        info1.leftTip = @"代金券加额";
        info1.placeHoder = @"¥每分享一位好友可增加金额";
        info1.cellHeight = FitPTScreen(51);
        info1.saveKey = @"plusPrice";
        info1.keyBoardType = UIKeyboardTypeDecimalPad;
        
        HLRightInputTypeInfo * info2 = [[HLRightInputTypeInfo alloc]init];
        info2.canInput = YES;
        info2.leftTip = @"最高增加金额";
        info2.placeHoder = @"¥到达最高金额后不再增加金额";
        info2.cellHeight = FitPTScreen(51);
        info2.saveKey = @"maxPlusPrice";
        info2.keyBoardType = UIKeyboardTypeDecimalPad;
        _otherModels = @[info1,info2];
    }
    return _otherModels;
}


-(void)uploadDatas{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Couponmanager/getJumpUrl";
        request.serverType = HLServerTypeStoreService;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            NSString * url = result.data[@"url"];
            HLProduceReviewController * productReview = [[HLProduceReviewController alloc]init];
            [productReview resetWebViewFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            productReview.loadUrl = url;
            productReview.isTicket = self.isTicket;
            [self hl_pushToController:productReview];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


@end
