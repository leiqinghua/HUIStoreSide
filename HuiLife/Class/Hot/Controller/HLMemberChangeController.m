//
//  HLMemberChangeController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/19.
//

#import "HLMemberChangeController.h"
#import "HLMemberChangeHeader.h"
#import "HLActivityMethodTableCell.h"
#import "HLActivityDescTableCell.h"
#import "HLActivityReviewTableCell.h"
#import "HLExpertTipController.h"
#import "HLHotDetailMainModel.h"

@interface HLMemberChangeController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) HLHotDetailMainModel *mainModel;

@end

@implementation HLMemberChangeController

- (void)viewWillAppear:(BOOL)animated {
    [self hl_setBackgroundColor:UIColor.clearColor];
    [self hl_setBackImage:@"back_white"];
}

#pragma mark - method
- (void)tipBtnClick:(UIButton *)sender {
    HLExpertTipController *expertVC = [[HLExpertTipController alloc]init];
    self.definesPresentationContext = YES;
    expertVC.mainModel = _mainModel;
    [self.navigationController presentViewController:expertVC animated:NO completion:nil];
}

//体验此活动
- (void)leftBtnClick {
    HLHotCaseInfo *caseInfo = self.mainModel.caseInfo.firstObject;
    [HLWXManage jumpToWXMiniProgramWithUserName:WX_MINIPAGRAM_USERNAME path:caseInfo.path json:@""];
}

//创建同款活动
- (void)rightBtnClick {
    NSDictionary *create = _mainModel.create;
    NSString *iosAddress = create[@"iosAddress"];
    NSDictionary *pragram = create[@"iosParam"];
    [HLTools pushAppPageLink:iosAddress params:pragram needBack:NO];
}

#pragma mark - 请求
- (void)requestPageInfo {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HotSellsInfo.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"info_id":_Id?:@""};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSDictionary *dict = result.data[@"info"];
            _mainModel = [HLHotDetailMainModel mj_objectWithKeyValues:dict];
            [self hl_setTitle:_mainModel.typeName andTitleColor:UIColor.whiteColor];
            [self.view addSubview:self.tableView];
            if (!_mainModel.zhuanJiaInfo.is_state) {
               [self initTipButton];
            }
            [self initBottomButton];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)reloadContentHight {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_resetStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self requestPageInfo];
    [HLNotifyCenter addObserver:self selector:@selector(reloadContentHight) name:HLHotReloadHtmlHightNotifi object:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - FitPTScreen(50)- Height_Bottom_Margn)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf8f9f8);
        AdjustsScrollViewInsetNever(self, _tableView);
        
        [_tableView registerClass:[HLActivityMethodTableCell class] forCellReuseIdentifier:@"HLActivityMethodTableCell"];
        [_tableView registerClass:[HLActivityDescTableCell class] forCellReuseIdentifier:@"HLActivityDescTableCell"];
        [_tableView registerClass:[HLActivityReviewTableCell class] forCellReuseIdentifier:@"HLActivityReviewTableCell"];
        
        HLMemberChangeHeader *tableHeader = [[HLMemberChangeHeader alloc]initWithFrame:CGRectZero];
        tableHeader.mainModel = _mainModel;
        CGFloat hight = FitPTScreen(510);
        hight += [HLTools estmateHightString:_mainModel.brief Font:[UIFont systemFontOfSize:FitPTScreen(13)] lineSpace:5];
        tableHeader.frame = CGRectMake(0, 0, ScreenW, hight);
        _tableView.tableHeaderView = tableHeader;
    }
    return _tableView;
}

//专家提示
- (void)initTipButton {
    UIButton *tipBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 backgroundImg:@"hot_zj_tip"];
    [self.view addSubview:tipBtn];
    [tipBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-9));
        make.bottom.equalTo(FitPTScreen(-102) - Height_Bottom_Margn);
        make.size.equalTo(CGSizeMake(FitPTScreen(63.5), FitPTScreen(63.5)));
    }];
    [tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initBottomButton {
    UIView *line = [[UIView alloc]init];
    [self.view addSubview:line];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-50)-Height_Bottom_Margn);
        make.left.right.equalTo(self.view);
        make.height.equalTo(0.5);
    }];
    
    UIButton *leftBtn = [UIButton hl_regularWithTitle:@"体验此活动" titleColor:@"#FF7F2B" font:15 image:@""];
    leftBtn.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:leftBtn];
    [leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(FitPTScreen(153));
        make.height.equalTo(FitPTScreen(50)+Height_Bottom_Margn);
    }];
    
    UIButton *rightBtn = [UIButton hl_regularWithTitle:@"创建同款活动" titleColor:@"#FFFFFF" font:15 image:@""];
    rightBtn.backgroundColor = UIColorFromRGB(0xFF7F2B);
    [self.view addSubview:rightBtn];
    [rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.left.equalTo(leftBtn.right);
        make.height.equalTo(leftBtn);
    }];
    
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HLActivityMethodTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLActivityMethodTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainModel = _mainModel;
        return cell;
    }
    
    if (indexPath.section == 1) {
        HLActivityDescTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLActivityDescTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainModel = _mainModel;
        return cell;
    }
    
    HLActivityReviewTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLActivityReviewTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mainModel = _mainModel;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _mainModel.funHight;
    }
    
    if (indexPath.section == 1) {
        return _mainModel.caseHight;
    }
    return _mainModel.contentHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        HLHotCaseInfo *caseInfo = self.mainModel.caseInfo.firstObject;
        [HLWXManage jumpToWXMiniProgramWithUserName:WX_MINIPAGRAM_USERNAME path:caseInfo.path json:@""];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     CGFloat offset = self.tableView.contentOffset.y;
       if (offset<=0) {
           [self.tableView setContentOffset:CGPointMake(0, 0)];
           [self hl_GradientColor:[UIColor.clearColor colorWithAlphaComponent:0]];
       }else{
           CGFloat alpha=1-((Height_NavBar-offset)/Height_NavBar);
           [self hl_GradientColor:[UIColorFromRGB(0xFF7F2B) colorWithAlphaComponent:alpha]];
       }
}
@end
