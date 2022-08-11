//
//  HLSendOrderCodeListCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderCodeListCell.h"

@interface HLSendOrderCodeListCell () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HLSendOrderCodeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    [self.contentView addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(60))];
    self.tableView.tableFooterView = footView;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, FitPTScreen(50), ScreenW, FitPTScreen(10))];
    bottomLine.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [footView addSubview:bottomLine];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - FitPTScreen(71), 0, FitPTScreen(71), FitPTScreen(50))];
    [footView addSubview:editBtn];
    [editBtn setTitle:@" 编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:UIColorFromRGB(0xFF7800) forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [editBtn setImage:[UIImage imageNamed:@"edit_red"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(editBtn.frame) - FitPTScreen(71), 0, FitPTScreen(71), FitPTScreen(50))];
    [footView addSubview:delBtn];
    [delBtn setTitle:@" 删除" forState:UIControlStateNormal];
    [delBtn setTitleColor:UIColorFromRGB(0xFF7800) forState:UIControlStateNormal];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [delBtn setImage:[UIImage imageNamed:@"delete_oriange"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(FitPTScreen(15), 0, ScreenW - FitPTScreen(15), 0.6)];
    [footView addSubview:line];
    line.backgroundColor = UIColorFromRGB(0xECECEC);
}

- (void)editBtnClick{
    if (self.delegate) {
        [self.delegate listCell:self editCodeInfo:self.codeInfo];
    }
}

- (void)delBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:delCodeInfo:)]) {
        [self.delegate listCell:self delCodeInfo:self.codeInfo];
    }
}

-(void)setCodeInfo:(HLSendOrderCodeInfo *)codeInfo{
    _codeInfo = codeInfo;
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:@{@"tip":@"桌号",@"text":codeInfo.tableNo?:@""}];
    
    for (NSInteger i = 0; i < codeInfo.cardNoArr.count; i++) {
        [self.dataSource addObject:@{@"tip":[NSString stringWithFormat:@"点单牌%ld",i+1],@"text":codeInfo.cardNoArr[i]}];
    }

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *systemCellId = @"systemCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:systemCellId];
        [self initCellContentSubViews:cell.contentView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataSource[indexPath.row];
    UILabel *textLab = [cell.contentView viewWithTag:101];
    UILabel *detailTextLab = [cell.contentView viewWithTag:102];
    textLab.text = dict[@"tip"];
    detailTextLab.text = dict[@"text"];
    cell.separatorInset = UIEdgeInsetsMake(0, indexPath.row == 0 ? FitPTScreen(15) : ScreenW, 0, 0);
    return cell;
}

- (void)initCellContentSubViews:(UIView *)superView{
    UILabel *textLabel = [[UILabel alloc] init];
    [superView addSubview:textLabel];
    textLabel.tag = 101;
    textLabel.textColor = UIColorFromRGB(0x333333);
    textLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(17));
        make.centerY.equalTo(superView);
    }];
    
    UILabel *detailTextLabel = [[UILabel alloc] init];
    [superView addSubview:detailTextLabel];
    detailTextLabel.tag = 102;
    detailTextLabel.textColor = UIColorFromRGB(0x333333);
    detailTextLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [detailTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-14));
        make.centerY.equalTo(superView);
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.rowHeight = FitPTScreen(50);
        _tableView.separatorColor = UIColorFromRGB(0xECECEC);
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
