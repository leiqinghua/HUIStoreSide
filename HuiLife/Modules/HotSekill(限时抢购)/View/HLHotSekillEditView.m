//
//  HLHotSekillEditView.m
//  HuiLife
//
//  Created by 王策 on 2021/8/8.
//

#import "HLHotSekillEditView.h"
#import "HLRightInputViewCell.h"
#import "HLCalendarViewController.h"
#import "HLTimeSingleSelectView.h"

#define kTableHeaderHeight FitPTScreen(50)
#define kTableFooterHeight FitPTScreen(95)

@interface HLHotSekillEditView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) void(^submitBlock)(NSDictionary *dict, HLHotSekillEditView *editView);
@end

@implementation HLHotSekillEditView

+ (void)showEditViewWithData:(NSDictionary *)orinalData superView:(UIView *)superView submitBlock:(void(^)(NSDictionary *dict, HLHotSekillEditView *editView))submitBlock{
    HLHotSekillEditView *editView = [[HLHotSekillEditView alloc] initWithFrame:superView.bounds];
    [editView configOrinalData:orinalData];
    editView.submitBlock = submitBlock;
    [superView addSubview:editView];
    [editView show];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)creatSubViews{
    
    self.contentHeight = 400;
    
    self.tableView = [[UITableView alloc] init];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = FitPTScreen(46);
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorColor = SeparatorColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];

    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kTableHeaderHeight)];
    self.tableView.tableHeaderView = tableHeaderView;
    
    UILabel *tipLab = [[UILabel alloc] init];
    [tableHeaderView addSubview:tipLab];
    tipLab.text = @"修改爆款秒杀";
    tipLab.font = [UIFont boldSystemFontOfSize:16];
    tipLab.textColor = UIColorFromRGB(0x333333);
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.centerY.equalTo(tableHeaderView);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [tableHeaderView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"close_x_grey"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(tableHeaderView);
        make.width.equalTo(kTableHeaderHeight);
    }];
    
    UIView *headerLine = [[UIView alloc] init];
    [tableHeaderView addSubview:headerLine];
    headerLine.backgroundColor = SeparatorColor;
    [headerLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(0.7);
        make.bottom.equalTo(0);
    }];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kTableFooterHeight)];
    self.tableView.tableFooterView = tableFooterView;
    
    UIView *footerLine = [[UIView alloc] init];
    [tableFooterView addSubview:footerLine];
    footerLine.backgroundColor = SeparatorColor;
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(0);
        make.height.equalTo(0.7);
        make.bottom.equalTo(0);
    }];
    
    // 加按钮
    UIButton *submitBtn = [[UIButton alloc] init];
    [tableFooterView addSubview:submitBtn];
    [submitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateHighlighted];
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tableFooterView);
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)submitBtnClick{
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    for (HLBaseTypeInfo *info in self.dataSource) {
        if (info.needCheckParams && ![info checkParamsIsOk]) {
            HLShowHint(info.errorHint, self);
            return;
        }else{
            if (info.mParams.count > 0) {
                [mParams setValuesForKeysWithDictionary:info.mParams];
            }else{
                [mParams setValue:info.text forKey:info.saveKey];
            }
        }
    }
    
    if(self.submitBlock){
        self.submitBlock(mParams, self);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault:
        {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    
    HLRightInputTypeInfo *dateInfo = self.dataSource[indexPath.row];
    // 修改秒杀有效期
    if ([dateInfo.leftTip containsString:@"秒杀有效期"]) {
        HLCalendarViewController *overView = [[HLCalendarViewController alloc] initWithCallBack:^(NSDate *start, NSDate *end) {
            dateInfo.text = [NSString stringWithFormat:@"%@ 至 %@",[HLTools formatterWithDate:start formate:@"yyyy-MM-dd"],[HLTools formatterWithDate:end formate:@"yyyy-MM-dd"]];
            dateInfo.mParams = @{
                @"startTime":[HLTools formatterWithDate:start formate:@"yyyy-MM-dd"],
                @"endTime":[HLTools formatterWithDate:end formate:@"yyyy-MM-dd"]
            };
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [(UIViewController *)self.nextResponder.nextResponder presentViewController:overView animated:false completion:nil];
    }
    
    // 选择截止日期
    if ([dateInfo.leftTip containsString:@"消费截止日期"]) {
        [HLTimeSingleSelectView showEditTimeView:dateInfo.text startWithToday:YES callBack:^(NSString * _Nonnull date) {
            dateInfo.text = date;
            dateInfo.mParams = @{@"closingDate":date};
            [self.tableView reloadData];
        }];
        return;
    }
}


#pragma mark - Public Method

- (void)configOrinalData:(NSDictionary *)orinalData{
    
    self.dataSource = [NSMutableArray array];
    
    // 配置数据
    if([orinalData.allKeys containsObject:@"invite_amount"]){
        // 佣金
        HLRightInputTypeInfo *yjInfo = [[HLRightInputTypeInfo alloc] init];
        yjInfo.leftTip = @"跨店分佣";
        yjInfo.placeHoder = @"¥请输入商品跨店分佣";
        yjInfo.canInput = YES;
        yjInfo.saveKey = @"invite_amount";
        yjInfo.errorHint = @"请输入商品跨店分佣";
        yjInfo.needCheckParams = YES;
        yjInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        yjInfo.text = orinalData[yjInfo.saveKey];
        [self.dataSource addObject:yjInfo];
    }
    
    HLRightInputTypeInfo *sumNumInfo = [[HLRightInputTypeInfo alloc] init];
    sumNumInfo.leftTip = @"提供数量";
    sumNumInfo.placeHoder = @"抢购总数量";
    sumNumInfo.rightText = @"份";
    sumNumInfo.cellHeight = FitPTScreen(53);
    sumNumInfo.canInput = YES;
    sumNumInfo.needCheckParams = YES;
    sumNumInfo.saveKey = @"offerNum";
    sumNumInfo.errorHint = @"请输入抢购总数量";
    sumNumInfo.keyBoardType = UIKeyboardTypeNumberPad;
    sumNumInfo.text = orinalData[sumNumInfo.saveKey];
    [self.dataSource addObject:sumNumInfo];
    
    HLRightInputTypeInfo *buyNumInfo = [[HLRightInputTypeInfo alloc] init];
    buyNumInfo.leftTip = @"每人限购";
    buyNumInfo.placeHoder = @"每人限购数量";
    buyNumInfo.cellHeight = FitPTScreen(53);
    buyNumInfo.canInput = YES;
    buyNumInfo.saveKey = @"limitNum";
    buyNumInfo.needCheckParams = YES;
    buyNumInfo.rightText = @"份";
    buyNumInfo.errorHint = @"请输入限购数量";
    buyNumInfo.keyBoardType = UIKeyboardTypeNumberPad;
    buyNumInfo.text = orinalData[buyNumInfo.saveKey];
    [self.dataSource addObject:buyNumInfo];
    
    HLRightInputTypeInfo *timeInfo = [[HLRightInputTypeInfo alloc] init];
    timeInfo.leftTip = @"秒杀有效期";
    timeInfo.placeHoder = @"请选择秒杀有效期";
    timeInfo.canInput = NO;
    timeInfo.errorHint = @"请选择秒杀有效期";
    timeInfo.needCheckParams = YES;
    timeInfo.cellHeight = FitPTScreen(76);
    timeInfo.text = [NSString stringWithFormat:@"%@ 至 %@",orinalData[@"startTime"],orinalData[@"endTime"]];
    timeInfo.mParams = @{
        @"startTime":orinalData[@"startTime"],
        @"endTime":orinalData[@"endTime"]
    };
    [self.dataSource addObject:timeInfo];

    
    HLRightInputTypeInfo *dateInfo = [[HLRightInputTypeInfo alloc] init];
    dateInfo.leftTip = @"消费截止日期";
    dateInfo.canInput = NO;
    dateInfo.placeHoder = @"在消费截止日期内可使用";
    dateInfo.errorHint = @"请选择消费截止日期";
    dateInfo.needCheckParams = YES;
    dateInfo.cellHeight = FitPTScreen(76);
    dateInfo.text = orinalData[@"closingDate"];
    dateInfo.mParams = @{
        @"closingDate":orinalData[@"closingDate"]
    };
    [self.dataSource addObject:dateInfo];

    for(HLRightInputTypeInfo *info in self.dataSource){
        info.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(15), 0, 0);
    }
    
    // 计算高度，因为秒杀有效期是 2 个时间，所以计算高度 count - 1
    self.contentHeight = (orinalData.count - 1) * self.tableView.rowHeight + kTableFooterHeight + kTableHeaderHeight;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.bottom).offset(self.contentHeight);
        make.height.equalTo(self.contentHeight);
    }];
    [self.tableView hl_addCornerRadius:FitPTScreen(10) bounds:CGRectMake(0, 0, self.bounds.size.width, self.contentHeight) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self.tableView reloadData];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

}

- (void)show{
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(0);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
            
    }];
}

- (void)hide{
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(self.contentHeight);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end


//https://sapi.51huilife.cn/HuiLife_Api/MerchantSide/SeckillInsert.php?dev=1
//id    60528
//token    xm7Kd7f731rByBzB0tYs
//bid    40816
//invite_amount    1
//offerNum    100
//limitNum    100
//startTime    2020-11-25
//endTime    2021-10-31
//closingDate    2025-12-31 23:59:59
//pid    1346191
