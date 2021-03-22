//
//  HLBuyCardViewController.m
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import "HLBuyCardViewController.h"
#import "HLBuyCardListViewCell.h"
#import "HLBuyCardPackageViewCell.h"
#import "HLBuyCardBottomBuyView.h"

@interface HLBuyCardViewController () <UITableViewDataSource,UITableViewDelegate,HLBuyCardPackageViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HLBuyCardBottomBuyView *buyView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HLBuyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开通商家";
    [self creatSubViews];
    [self.tableView reloadData];
}

#pragma mark - Private Methods

/// 构建视图
- (void)creatSubViews{
    
    self.buyView = [[HLBuyCardBottomBuyView alloc] init];
    [self.view addSubview:self.buyView];
    [self.buyView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(FitPTScreen(55) + Height_Bottom_Margn);
    }];
    
    self.view.backgroundColor = [UIColor hl_StringToColor:@"#F8F8F8"];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(self.buyView.top);
    }];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 选择套餐cell
    if ([self.dataSource[indexPath.row] isMemberOfClass:[HLBuyCardPackageViewModel class]]) {
        HLBuyCardPackageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLBuyCardPackageViewCell"];
        if (!cell) {
            cell = [[HLBuyCardPackageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HLBuyCardPackageViewCell"];
            cell.delegate = self;
        }
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    
    HLBuyCardListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLBuyCardListViewCell"];
    if (!cell) {
        cell = [[HLBuyCardListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HLBuyCardListViewCell"];
    }
    cell.listModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource[indexPath.row] isMemberOfClass:[HLBuyCardPackageViewModel class]]) {
        return [self.dataSource[indexPath.row] cellHeight];
    }
    return FitPTScreen(46.5);
}

#pragma mark - HLBuyCardPackageViewCellDelegate

- (void)packageViewCell:(HLBuyCardPackageViewCell *)cell selectItem:(HLBuyCardPackageViewItem *)item{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = FitPTScreen(46.5);
        _tableView.separatorColor = [UIColor hl_StringToColor:@"#EDEDED"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor hl_StringToColor:@"#F8F8F8"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        HLBuyCardListViewModel *telModel = [[HLBuyCardListViewModel alloc] init];
        telModel.tip = @"商家手机号:";
        telModel.placeHolder = @"请输入商家手机号";
        telModel.canEdit = YES;
        telModel.keyboardType = UIKeyboardTypeDefault;
        telModel.inputValue = [HLAccount shared].mobile;
        
        HLBuyCardListViewModel *nameModel = [[HLBuyCardListViewModel alloc] init];
        nameModel.tip = @"商家名称:";
        nameModel.placeHolder = @"请输入商家名称";
        nameModel.canEdit = YES;
        nameModel.keyboardType = UIKeyboardTypeDefault;
        nameModel.inputValue = [HLAccount shared].store_name;
        
        HLBuyCardListViewModel *classModel = [[HLBuyCardListViewModel alloc] init];
        classModel.tip = @"商家类别:";
        classModel.placeHolder = @"请输入商家类别";
        classModel.canEdit = YES;
        classModel.keyboardType = UIKeyboardTypeDefault;
    //    classModel.inputValue = [HLAccount shared].mobile;
        
        ///  选择服务套餐model
        HLBuyCardPackageViewModel *packageModel = [self createPackageModel];
        packageModel.tip = @"服务套餐选择:";
        
        HLBuyCardListViewModel *numModel = [[HLBuyCardListViewModel alloc] init];
        numModel.tip = @"购买张数:";
        numModel.placeHolder = @"请输入购买张数(不低于1000张)";
        numModel.canEdit = YES;
        classModel.keyboardType = UIKeyboardTypeNumberPad;
        
        HLBuyCardListViewModel *giveNumModel = [[HLBuyCardListViewModel alloc] init];
        giveNumModel.tip = @"赠送张数:";
        giveNumModel.placeHolder = @"赠送张数";
        giveNumModel.canEdit = NO;
        giveNumModel.inputValue = @"0";
        classModel.keyboardType = UIKeyboardTypeNumberPad;
        
        HLBuyCardListViewModel *moneyModel = [[HLBuyCardListViewModel alloc] init];
        moneyModel.tip = @"服务费:";
        moneyModel.placeHolder = @"请输入服务费(选填)";
        moneyModel.canEdit = YES;
        moneyModel.keyboardType = UIKeyboardTypeDecimalPad;
        
        self.dataSource = [@[telModel,nameModel,classModel,packageModel,numModel,giveNumModel,moneyModel] mutableCopy];
    }
    return _dataSource;
}

- (HLBuyCardPackageViewModel *)createPackageModel{
    
    HLBuyCardPackageViewItem *packageItem0 = [[HLBuyCardPackageViewItem alloc] init];
    packageItem0.num = 100;
    packageItem0.giveNum = 0;
    
    HLBuyCardPackageViewItem *packageItem1 = [[HLBuyCardPackageViewItem alloc] init];
    packageItem1.num = 300;
    packageItem1.giveNum = 10;
    
    HLBuyCardPackageViewItem *packageItem2 = [[HLBuyCardPackageViewItem alloc] init];
    packageItem2.num = 500;
    packageItem2.giveNum = 30;
    
    HLBuyCardPackageViewItem *packageItem3 = [[HLBuyCardPackageViewItem alloc] init];
    packageItem3.num = 1000;
    packageItem3.giveNum = 100;
    
    HLBuyCardPackageViewItem *packageItem4 = [[HLBuyCardPackageViewItem alloc] init];
    packageItem4.isCustom = YES;
    
    
    HLBuyCardPackageViewModel *packageModel = [[HLBuyCardPackageViewModel alloc] init];
    packageModel.items = @[packageItem0,packageItem1,packageItem2,packageItem3,packageItem4];
    packageModel.selectIndex = 0;
    return packageModel;
}

@end
