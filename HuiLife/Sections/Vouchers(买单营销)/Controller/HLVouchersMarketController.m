//
//  HLVouchersMarketController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import "HLVouchersMarketController.h"
#import "HLVoucherMarketHead.h"
#import "HLVoucherMarketInfo.h"
#import "HLVoucherMarketFuncCell.h"
#import "HLVoucherMarketAddController.h"
#import "HLVoucherCodeController.h"

/// 生成买单牌那块是tableHead

@interface HLVouchersMarketController () <UITableViewDelegate,UITableViewDataSource,HLVoucherMarketHeadDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HLVoucherMarketHead *tableHead;

@property (nonatomic, strong) HLVoucherMarketInfo *marketInfo;

@end

@implementation HLVouchersMarketController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"买单推广" andTitleColor:UIColorFromRGB(0x333333)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    _tableHead = [[HLVoucherMarketHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(210))];
    _tableHead.delegate = self;
    self.tableView.tableHeaderView = _tableHead;
    
    // 默认情况下，tableView 隐藏，拉取数据成功后显示
    self.tableView.hidden = YES;
    [self loadData];
}

- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Agentserver/getIndex";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            self.tableView.hidden = NO;
            // 处理数据
            self.marketInfo = [HLVoucherMarketInfo mj_objectWithKeyValues:responseObject.data];
            [self.tableHead configState:self.marketInfo.accountSt.integerValue stateTitle:self.marketInfo.oneTitle];
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - HLVoucherMarketHeadDelegate

/// 点击创建按钮
- (void)marketHead:(HLVoucherMarketHead *)head addButtonClick:(UIButton *)addButton{
    
    // 判断此时的状态
    if (self.marketInfo.accountSt.integerValue != 3) {
        HLVoucherMarketAddController *marketAdd = [[HLVoucherMarketAddController alloc] init];
        marketAdd.state = self.marketInfo.accountSt;
        marketAdd.addBlock = ^{
            [self loadData];
        };
        [self.navigationController pushViewController:marketAdd animated:YES];
    }else{
        HLVoucherCodeController *voucherCode = [[HLVoucherCodeController alloc] init];
        [self.navigationController pushViewController:voucherCode animated:YES];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.marketInfo.downInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLVoucherMarketFuncCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLVoucherMarketFuncCell" forIndexPath:indexPath];
    cell.activityInfo = self.marketInfo.downInfo[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLVoucherMarketActivityInfo *info = self.marketInfo.downInfo[indexPath.row];
    [HLTools pushAppPageLink:info.iosAddress params:info.iosParam needBack:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitPTScreen(57);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(57))];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *topImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voucher_section_bg"]];
    [view addSubview:topImgV];
    [topImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.right.equalTo(FitPTScreen(-12));
        make.top.bottom.equalTo(0);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [topImgV addSubview:label];
    label.text = self.marketInfo.twoTitle ?:@"";
    label.textColor = UIColorFromRGB(0x994E00);
    label.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topImgV);
        make.right.lessThanOrEqualTo(FitPTScreen(-13));
        make.left.equalTo(FitPTScreen(52));
    }];
    
    return view;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = FitPTScreen(74);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLVoucherMarketFuncCell class] forCellReuseIdentifier:@"HLVoucherMarketFuncCell"];
    }
    return _tableView;
}

@end
