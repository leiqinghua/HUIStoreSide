//
//  HLCardPromotionController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import "HLCardPromotionController.h"
#import "HLCardPromotionHeader.h"
#import "HLCardPromotionCell.h"
#import "HLTicketListController.h"
#import "HLCarMarketController.h"

#import "HLAlertController.h"
#import "HLGroupViewController.h"

@interface HLCardPromotionController ()<UITableViewDelegate,UITableViewDataSource,HLCardPromotionDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSArray * datasource;

@end

@implementation HLCardPromotionController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"HUI卡推广"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadList];
}

-(UITableView *)tableView{
    if (!_tableView) {
        self.view.backgroundColor = UIColor.whiteColor;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.rowHeight = FitPTScreen(89);
        [self.view addSubview:_tableView];
        AdjustsScrollViewInsetNever(self, _tableView);
        
        HLCardPromotionHeader * header = [[HLCardPromotionHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(110))];
        _tableView.tableHeaderView = header;
        
        [_tableView registerClass:[HLCardPromotionCell class] forCellReuseIdentifier:@"HLCardPromotionCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLCardPromotionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLCardPromotionCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.datasource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLCardPromotion * model1 = self.datasource[indexPath.row];
    [HLTools pushAppPageLink:model1.iosArdess params:model1.iosParam needBack:false];
    


}
#pragma mark - HLCardPromotionDelegate
-(void)promotionCell:(HLCardPromotionCell *)cell clickWithModel:(HLCardPromotion *)model{
   
}

#pragma mark -
-(void)loadList{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Busniessconfig/configIndex";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        
        if (result.code == 200) {
            [self.view addSubview:self.tableView];
            self.datasource = [HLCardPromotion mj_objectArrayWithKeyValuesArray:result.data[@"extenData"]];
            [self.tableView reloadData];
            HLCardPromotionHeader * header = (HLCardPromotionHeader *)self.tableView.tableHeaderView;
            header.dict = result.data[@"bannerData"];
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

@end
