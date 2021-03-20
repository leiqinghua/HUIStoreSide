//
//  HLDownSelectView.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLDownSelectView.h"

@interface HLDownSelectView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy)   NSArray *titles;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) UIView *dependView;
@property (nonatomic, assign) HLDownSelectType selectType;
@property (nonatomic, copy)   HLDownSelectCallBack callBack;
@property (nonatomic, copy)   HLDownSelectHideCallBack hideCallBack;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, assign) CGFloat tableHeight;
@property (nonatomic, assign) BOOL needShowSelect;  // 是否需要选择已选中的
@property (nonatomic, copy) NSString *currentTitle; // 应该选中的文字
@property (nonatomic, assign) BOOL showSeperator; // 是否需要显示分割线

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HLDownSelectView

+ (void)showSelectViewWithTitles:(NSArray *)titles itemHeight:(CGFloat)itemHeight dependView:(UIView *)dependView showType:(HLDownSelectType)type maxNum:(CGFloat)maxNum callBack:(HLDownSelectCallBack)callBack{
    [self showSelectViewWithTitles:titles currentTitle:@"" needShowSelect:NO showSeperator:YES itemHeight:itemHeight dependView:dependView showType:type maxNum:maxNum hideCallBack:nil callBack:callBack];
}

+ (void)showSelectViewWithTitles:(NSArray *)titles currentTitle:(NSString *)currentTitle needShowSelect:(BOOL)needShowSelect showSeperator:(BOOL)showSeperator itemHeight:(CGFloat)itemHeight dependView:(UIView *)dependView showType:(HLDownSelectType)type maxNum:(CGFloat)maxNum hideCallBack:(HLDownSelectHideCallBack)hideCallBack callBack:(HLDownSelectCallBack)callBack{
    HLDownSelectView *view = [[HLDownSelectView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    view.titles = titles;
    view.itemHeight = itemHeight;
    view.dependView = dependView;
    view.selectType = type;
    view.maxNum = maxNum;
    view.callBack = callBack;
    view.hideCallBack = hideCallBack;
    view.currentTitle = currentTitle;
    view.showSeperator = showSeperator;
    view.needShowSelect = needShowSelect;
    [view creatSubUI];
    [view show];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.01];
        [bgView hl_addTarget:self action:@selector(hide)];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide];
}

- (void)creatSubUI{
    // 计算高度
    CGFloat cellHeight = self.itemHeight;
    CGFloat tableHeight = 0;
    if (self.titles.count >= self.maxNum) {
        tableHeight = self.maxNum * cellHeight;
    }else{
        tableHeight = self.titles.count * cellHeight;
    }
    
    self.tableView.rowHeight = cellHeight;
    self.tableHeight = tableHeight;
    [self addSubview:self.tableView];
    
    self.tableView.separatorStyle = self.showSeperator ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
    
    self.tableView.layer.borderColor = UIColorFromRGB(0xDBDBDB).CGColor;
    self.tableView.layer.borderWidth = FitPTScreen(0.7);
    self.tableView.layer.cornerRadius = FitPTScreen(5);
    self.tableView.layer.masksToBounds = YES;

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *systemCellId = @"systemCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:systemCellId];
        cell.textLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
        cell.textLabel.textColor = UIColorFromRGB(0x555555);
        if (self.needShowSelect) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_yellow_light"]];
        }
    }
    cell.textLabel.text = self.titles[indexPath.row];
    if (self.needShowSelect) {
        // 判断是否是此时选中的那个
        BOOL isCurrenSelect = [cell.textLabel.text isEqualToString:self.currentTitle];
        cell.textLabel.textColor = isCurrenSelect ? UIColorFromRGB(0xFFAB33) : UIColorFromRGB(0x555555);
        cell.accessoryView.hidden = !isCurrenSelect;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.callBack) {
        self.callBack(indexPath.row);
    }
    [self hide];
}


- (void)show{
    [KEY_WINDOW addSubview:self];
    CGRect dependFrame = [self.dependView convertRect:self.dependView.bounds toView:KEY_WINDOW];
    
    // 判断如果是自动的，就去判断向下展开是否可以，不允许则直接向上展开
    if (self.selectType == HLDownSelectTypeAuto) {
        if (self.tableHeight + CGRectGetMaxY(dependFrame) > ScreenH) {
            self.selectType = HLDownSelectTypeUp;
            if (self.tableHeight > CGRectGetMinY(dependFrame)) {
                self.tableHeight = CGRectGetMinY(dependFrame) - FitPTScreen(30);
            }
        }else{
            self.selectType = HLDownSelectTypeDown;
        }
    }
    
    // 如果是向下展开
    if (self.selectType == HLDownSelectTypeDown) {
        self.tableView.frame = CGRectMake(CGRectGetMinX(dependFrame), CGRectGetMaxY(dependFrame), CGRectGetWidth(dependFrame), 0);
        [UIView animateWithDuration:0.10 animations:^{
            self.tableView.frame = CGRectMake(CGRectGetMinX(dependFrame), CGRectGetMaxY(dependFrame), CGRectGetWidth(dependFrame), self.tableHeight);
        }];
    }else{
        self.tableView.layer.anchorPoint = CGPointMake(1, 0.5);
        self.tableView.frame = CGRectMake(CGRectGetMinX(dependFrame), CGRectGetMinY(dependFrame), CGRectGetWidth(dependFrame), 0);
        [UIView animateWithDuration:0.10 animations:^{
            self.tableView.frame = CGRectMake(CGRectGetMinX(dependFrame), CGRectGetMinY(dependFrame) - self.tableHeight, CGRectGetWidth(dependFrame), self.tableHeight);
        }];
    }
}

- (void)hide{
    CGRect frame = self.tableView.frame;
    [UIView animateWithDuration:0.1 animations:^{
        self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + (self.selectType == HLDownSelectTypeUp ? self.tableHeight : 0), frame.size.width, 0);
        self.tableView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        //
        if(self.hideCallBack){
            self.hideCallBack();
        }
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    return _tableView;
}

@end
