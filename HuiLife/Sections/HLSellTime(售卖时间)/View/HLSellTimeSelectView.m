//
//  HLSellTimeSelectView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/31.
//

#import "HLSellTimeSelectView.h"

@interface HLSellTimeSelectView () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *times;

@property(nonatomic, assign) NSInteger selectIndex;

@property(nonatomic, strong) UIView *dependView;

@property(nonatomic, copy) void(^completion)(NSInteger);

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) BOOL upShow;//是否向上
//固定高度
@property(nonatomic, assign) NSInteger height;

@end

@implementation HLSellTimeSelectView

+ (void)showWithTitles:(NSArray *)times selectIndex:(NSInteger)index dependView:(UIView *)dependView completion:(void(^)(NSInteger))completion {
    HLSellTimeSelectView *sellTimeView = [[HLSellTimeSelectView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    sellTimeView.backgroundColor = UIColor.clearColor;
    sellTimeView.times = times;
    sellTimeView.selectIndex = index;
    sellTimeView.dependView = dependView;
    sellTimeView.completion = completion;
    [sellTimeView initSubView];
    [sellTimeView showTimeView];
}

+ (void)showWithTitles:(NSArray *)times selectIndex:(NSInteger)index height:(CGFloat)height dependView:(UIView *)dependView completion:(void(^)(NSInteger))completion {
    HLSellTimeSelectView *sellTimeView = [[HLSellTimeSelectView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    sellTimeView.backgroundColor = UIColor.clearColor;
    sellTimeView.times = times;
    sellTimeView.height = height;
    sellTimeView.selectIndex = index;
    sellTimeView.dependView = dependView;
    sellTimeView.completion = completion;
    [sellTimeView initSubView];
    [sellTimeView showTimeView];
}


- (void)initSubView {
    
    self.layer.shadowColor = [HLTools hl_toColorByColorStr:@"#000000" alpha:0.1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = FitPTScreen(6);
    self.layer.cornerRadius = FitPTScreen(6);
    self.layer.masksToBounds = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = FitPTScreen(40);
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}

#pragma mark - show
- (void)showTimeView {
    
    [KEY_WINDOW addSubview:self];
    
    CGFloat tableHight = _times.count * FitPTScreen(40);
    if (_times.count > 5) {
        tableHight = FitPTScreen(200);
    }
    if (_height) {
        tableHight = _height;
    }
//    计算在widow上的位置
    CGRect rect = [_dependView convertRect:_dependView.bounds toView:KEY_WINDOW];
    if (rect.size.width < FitPTScreen(133)) {
        rect.size.width = FitPTScreen(133);
    }
//    判断是不是超过屏幕
    CGFloat totalHight = CGRectGetMaxY(rect) + tableHight;
    _upShow = totalHight > ScreenH;
    if (_upShow) { //tableView向上打开
        self.tableView.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), rect.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.tableView.frame;
            frame.origin.y = CGRectGetMinY(rect) - tableHight;
            frame.size.height = tableHight;
            self.tableView.frame = frame;
        }];
    } else { //向下打开
        self.tableView.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect), rect.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.tableView.frame;
            frame.size.height = tableHight;
            self.tableView.frame = frame;
        }];
    }
    
}

- (void)hideTimeView {
    CGRect rect = [_dependView convertRect:_dependView.bounds toView:KEY_WINDOW];
    if (_upShow) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.tableView.frame;
            frame.origin.y = CGRectGetMinY(rect);
            frame.size.height = 0;
            self.tableView.frame = frame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.tableView.frame;
        frame.size.height = 0;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.times.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLb = [cell.contentView viewWithTag:1000];
    if (!titleLb) {
        titleLb = [UILabel hl_regularWithColor:@"#222222" font:14];
        titleLb.tag = 1000;
        [cell.contentView addSubview:titleLb];
        [titleLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(cell.contentView);
        }];
    }
    titleLb.text = self.times[indexPath.row];
    if (indexPath.row == _selectIndex) {
        titleLb.textColor = UIColorFromRGB(0xFD8A29);
        cell.backgroundColor = UIColorFromRGB(0xfff3e8);
    } else {
        titleLb.textColor = UIColorFromRGB(0x222222);
        cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;
    if (self.completion) {
        self.completion(_selectIndex);
    }
    [self hideTimeView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideTimeView];
}

@end
