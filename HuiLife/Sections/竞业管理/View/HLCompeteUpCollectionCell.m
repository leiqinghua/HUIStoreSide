//
//  HLCompeteUpCollectionCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/11.
//

#import "HLCompeteUpCollectionCell.h"
#import "HLCompeteBaseTableCell.h"
#import "HLCompeteUpPageInfo.h"

@interface HLCompeteUpCollectionCell ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *noDataView;
@end

@implementation HLCompeteUpCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)setPageInfo:(HLCompeteUpPageInfo *)pageInfo {
    _pageInfo = pageInfo;
    [_tableView hideFooter:!_pageInfo.stores.count];
    if (_pageInfo.showNodataView) [self showNodataView:!_pageInfo.stores.count];
    [_tableView endRefresh];
    if (_pageInfo.noMoreData) [self.tableView endNomorData];
    [self.tableView reloadData];
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show{
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.backgroundColor = UIColor.clearColor;
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_card_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(228));
            make.centerX.equalTo(self.noDataView);
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"暂无店铺信息";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    _noDataView.hidden = !show;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pageInfo.stores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLCompeteBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLCompeteBaseTableCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.storeInfo = _pageInfo.stores[indexPath.row];
    weakify(self);
    cell.upDownCallBack = ^(HLCompeteStoreInfo * _Nonnull storeInfo) {
        if ([weak_self.delegate respondsToSelector:@selector(upCollectionCellUpdate:)]) {
            [weak_self.delegate upCollectionCellUpdate:storeInfo];
        }
    };
    return cell;
}

#pragma mark - UIView
- (void)initSubView {
    _tableView = [[UITableView alloc]initWithFrame:self.contentView.bounds];
    _tableView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    [self.contentView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = FitPTScreen(137);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[HLCompeteBaseTableCell class] forCellReuseIdentifier:@"HLCompeteBaseTableCell"];
    
    //下拉刷新
    [_tableView headerNormalRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(upCollectionCell:down:)]) {
            [self.delegate upCollectionCell:self down:YES];
        }
    }];
    
    [_tableView footerWithEndText:@"没有更多数据" refreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(upCollectionCell:down:)]) {
            [self.delegate upCollectionCell:self down:NO];
        }
    }];
    
    [_tableView hideFooter:YES];
}
@end
