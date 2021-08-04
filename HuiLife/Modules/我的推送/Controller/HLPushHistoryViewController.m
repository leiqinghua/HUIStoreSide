//
//  HLPushHistoryViewController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import "HLPushHistoryViewController.h"
#import "HLPushHistoryModel.h"
#import "HLPushHistoryHeadView.h"
#import "HLPushHistorySectionHeader.h"

@interface HLPushHistoryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HLPushHistoryHeadView *headView;

@property (nonatomic, strong) HLPushHistoryModel *dataModel;

@end

@implementation HLPushHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.navigationItem.title = @"推送记录";
}

#pragma mark - Method

/// 创建视图
- (void)creatSubViews{
    [self.view addSubview:self.tableView];
    AdjustsScrollViewInsetNever(self, self.tableView);
    self.headView = [[HLPushHistoryHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    weakify(self);
    self.headView.pushBtnClick = ^{
        [weak_self pushBtnClick];
    };
    self.tableView.tableHeaderView = self.headView;
}

/// 推送数据
- (void)pushBtnClick{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/push/myPush.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"push_id":self.push_id,@"push_time":@"[0,0]"};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            HLShowHint(@"推送成功", nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 加载数据
- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/push/history.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"push_id":self.push_id};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 创建视图
            [self creatSubViews];
            self.dataModel = [HLPushHistoryModel mj_objectWithKeyValues:responseObject.data];
            // 配置数据
            HLPushHistoryHeadView *headView = (HLPushHistoryHeadView *)self.tableView.tableHeaderView;
            [headView confgiDataModel:self.dataModel];
            [self.tableView reloadData];
        }else{
            weakify(self);
            [self hl_showNetFail:self.view.bounds callBack:^{
                [weak_self loadData];
            }];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
        weakify(self);
        [self hl_showNetFail:self.view.bounds callBack:^{
            [weak_self loadData];
        }];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModel.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *leftLab = [[UILabel alloc] init];
        [cell.contentView addSubview:leftLab];
        leftLab.textColor = UIColorFromRGB(0x666666);
        leftLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        leftLab.tag = 101;
        [leftLab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(FitPTScreen(15));
        }];
        
        UILabel *rightLab = [[UILabel alloc] init];
        [cell.contentView addSubview:rightLab];
        rightLab.textColor = UIColorFromRGB(0x666666);
        rightLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        rightLab.tag = 102;
        [rightLab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(FitPTScreen(-12));
        }];
    }
    
    UILabel *leftLab = [cell.contentView viewWithTag:101];
    leftLab.text = [self.dataModel.notes[indexPath.row] allKeys].firstObject;
    
    UILabel *rightLab = [cell.contentView viewWithTag:102];
    NSInteger pushNum = [[self.dataModel.notes[indexPath.row] allValues].firstObject integerValue];
    NSString *allStr = [NSString stringWithFormat:@"成功推送%ld人",pushNum];
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [mAttr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF9900)} range:[allStr rangeOfString:[NSString stringWithFormat:@"%ld",pushNum]]];
    rightLab.attributedText = mAttr;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitPTScreen(46);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HLPushHistorySectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLPushHistorySectionHeader"];
    header.number = self.dataModel.cumulative;
    header.contentView.backgroundColor = UIColor.whiteColor;
    return header;
}

#pragma mark - Getter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColorFromRGB(0xEDEDED);
        _tableView.rowHeight = FitPTScreen(40);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLPushHistorySectionHeader class] forHeaderFooterViewReuseIdentifier:@"HLPushHistorySectionHeader"];
    }
    return _tableView;
}


@end
