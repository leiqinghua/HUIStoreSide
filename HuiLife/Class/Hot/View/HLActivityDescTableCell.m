//
//  HLActivityDescTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/20.
// 案例说明

#import "HLActivityDescTableCell.h"
#import "HLActivityCaseTableCell.h"
#import "HLHotDetailMainModel.h"

@interface HLActivityDescTableCell () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UILabel *tipLb;

@property(nonatomic, strong) UITableView *tableView;
@end

@implementation HLActivityDescTableCell

- (void)initSubView {
    [super initSubView];
    self.backgroundColor = UIColor.clearColor;
    self.bagView.backgroundColor = UIColor.whiteColor;
    self.bagView.layer.cornerRadius = FitPTScreen(10);
    self.bagView.layer.masksToBounds = YES;
    [self.bagView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(10), FitPTScreen(5), FitPTScreen(10)));
    }];
    UIImageView *tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"member_left_tip"]];
    [self.bagView addSubview:tipView];
    [tipView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    _tipLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    _tipLb.text = @"案例说明";
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView.right).offset(FitPTScreen(10));
        make.centerY.equalTo(tipView);
    }];
    
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.userInteractionEnabled = NO;
    [self.bagView addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLb.bottom);
        make.left.bottom.right.equalTo(self.bagView);
    }];
    [_tableView registerClass:[HLActivityCaseTableCell class] forCellReuseIdentifier:@"HLActivityCaseTableCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mainModel.caseInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLActivityCaseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLActivityCaseTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showLine = indexPath.row != (_mainModel.caseInfo.count - 1);
    cell.caseInfo = _mainModel.caseInfo[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FitPTScreen(110);
}

#pragma mark - setter
- (void)setMainModel:(HLHotDetailMainModel *)mainModel {
    _mainModel = mainModel;
    [self.tableView reloadData];
    
}
@end
