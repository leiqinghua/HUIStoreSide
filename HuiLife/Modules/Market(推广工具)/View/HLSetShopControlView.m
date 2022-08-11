//
//  HLSetShopControlView.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLSetShopControlView.h"
#import "HLSetShopControlCell.h"

@interface HLSetShopControlView () <UITableViewDelegate, UITableViewDataSource, HLSetShopControlCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HLSetStoreModel *>*dataSource;
@property (nonatomic, strong) UIView *canAddFootView;
@property (nonatomic, assign) BOOL canAdd;

@end

@implementation HLSetShopControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    [self hl_addTarget:self action:@selector(hide)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    self.tableView.rowHeight = FitPTScreen(73.5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.tableView];
}

#pragma mark - Method

- (void)hide{
    [self removeFromSuperview];
}

// 配置数据
- (void)configStores:(NSArray <HLSetStoreModel *>*)stores canAdd:(BOOL)canAdd{
    self.dataSource = [stores mutableCopy];
    self.canAdd = canAdd;
    [self resetTableFrame];
}

// 重新设置frame
- (void)resetTableFrame{
    if(self.canAdd){
        self.tableView.tableFooterView = self.canAddFootView;
    }else{
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    NSInteger maxCount = self.dataSource.count > 5 ? 5 : self.dataSource.count;
    self.tableView.frame = CGRectMake(0, 0, ScreenW, self.tableView.rowHeight * maxCount + self.tableView.tableFooterView.bounds.size.height);
    
    [self.tableView reloadData];
}

#pragma mark -

// 添加按钮
- (void)addBtnClick{
    if (self.delegate) {
        [self.delegate addStoreWithControlView:self];
    }
}

#pragma mark - HLSetShopControlCellDelegate

- (void)controlCell:(HLSetShopControlCell *)cell delWithStoreModel:(HLSetStoreModel *)model{
    [self.delegate controlView:self deleteWithStoreModel:model successBlock:^{
        
    }];
}

- (void)controlCell:(HLSetShopControlCell *)cell editWithStoreModel:(HLSetStoreModel *)model{
    if (self.delegate) {
        [self.delegate controlView:self editWithStoreModel:model];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLSetShopControlCell *cell = [HLSetShopControlCell dequeueReusableCell:tableView];
    cell.storeModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - Getter

- (UIView *)canAddFootView{
    if (!_canAddFootView) {
        _canAddFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(82))];

        // 加按钮
        UIButton *addBtn = [[UIButton alloc] init];
        [_canAddFootView addSubview:addBtn];
        [addBtn setTitle:@"+ 添加门店" forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
        [addBtn makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_canAddFootView);
            make.width.equalTo(FitPTScreen(260.5));
            make.height.equalTo(FitPTScreen(61.5));
        }];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _canAddFootView;
}

@end
