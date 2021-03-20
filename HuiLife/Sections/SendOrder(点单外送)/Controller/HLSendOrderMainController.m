//
//  HLSendOrderMainController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/8.
//

#import "HLSendOrderMainController.h"
#import "HLSendOrderMainInfo.h"
#import "HLSendOrderPostCell.h"
#import "HLSendOrderSecondCell.h"

@interface HLSendOrderMainController () <UITableViewDelegate,UITableViewDataSource,HLSendOrderPostCellDelegate,HLSendOrderSecondCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HLSendOrderMainInfo *mainInfo;

@end

@implementation HLSendOrderMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self hl_setTitle:@"点单 / 外送" andTitleColor:UIColorFromRGB(0x222222)];
    AdjustsScrollViewInsetNever(self, self.tableView);
    // 加载数据
    [self loadData];
}

- (void)loadData{
    self.tableView.hidden = YES;
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSideA/ProManage.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"type":self.type?:@"1"};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            self.tableView.hidden = NO;
            // 处理数据
            self.mainInfo = [HLSendOrderMainInfo mj_objectWithKeyValues:responseObject.data];
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - HLSendOrderPostCellDelegate

/// 点击发布按钮
- (void)postCell:(HLSendOrderPostCell *)cell clickMainInfo:(HLSendOrderMainInfo *)mainInfo{
    [HLTools pushAppPageLink:mainInfo.iosArdess params:mainInfo.iosParam needBack:NO];
}

#pragma mark - HLSendOrderSecondCellDelegate

/// 点击三个功能按钮
- (void)secondFuncCell:(HLSendOrderSecondCell *)cell clickFuncInfo:(HLSendOrderSecondFuncInfo *)funcInfo{
    [HLTools pushAppPageLink:funcInfo.iosArdess params:funcInfo.iosParam needBack:NO];
}

/// switch开关管理
- (void)switchValueChangeWithSecondFuncCell:(HLSendOrderSecondCell *)cell{
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    
    for (HLSendOrderSecondInfo *info in self.mainInfo.second) {
        NSDictionary *dict = [info buildParams];
        if (dict) {
            [mParams setValuesForKeysWithDictionary:dict];
        }
    }
    
    [mParams setValue:self.type?:@"" forKey:@"type"];
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSideA/ProManageSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = mParams;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
     if ([responseObject code] != 200) {
            cell.secondInfo.isOpen = !cell.secondInfo.isOpen;
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
        cell.secondInfo.isOpen = !cell.secondInfo.isOpen;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.mainInfo.second.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HLSendOrderPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLSendOrderPostCell" forIndexPath:indexPath];
        cell.mainInfo = self.mainInfo;
        cell.delegate = self;
        return cell;
    }else{
        HLSendOrderSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLSendOrderSecondCell" forIndexPath:indexPath];
        cell.secondInfo = self.mainInfo.second[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [HLTools pushAppPageLink:self.mainInfo.manageShow[@"iosArdess"] params:self.mainInfo.manageShow[@"iosParam"] needBack:NO];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return FitPTScreen(77);
    }
    
    HLSendOrderSecondInfo *info = self.mainInfo.second[indexPath.row];
    return  info.cellHight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitPTScreen(58);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(58))];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *topImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:section == 0 ? @"voucher_creatmd_image" : @"voucher_section_bg"]];
    [view addSubview:topImgV];
    [topImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.right.equalTo(FitPTScreen(-12));
        make.top.bottom.equalTo(0);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [topImgV addSubview:label];
    label.text = section == 0 ? self.mainInfo.firstName : @"开启点单 / 外送";
    label.textColor = UIColorFromRGB(0x903400);
    label.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topImgV);
        make.right.lessThanOrEqualTo(FitPTScreen(-13));
        make.left.equalTo(FitPTScreen(52));
    }];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 44;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(19))];
        [_tableView registerClass:[HLSendOrderPostCell class] forCellReuseIdentifier:@"HLSendOrderPostCell"];
        [_tableView registerClass:[HLSendOrderSecondCell class] forCellReuseIdentifier:@"HLSendOrderSecondCell"];

    }
    return _tableView;
}
@end
