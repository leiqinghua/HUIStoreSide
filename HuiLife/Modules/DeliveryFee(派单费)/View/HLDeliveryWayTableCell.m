//
//  HLDeliveryWayTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/28.
//

#import "HLDeliveryWayTableCell.h"
#import "HLSwitch.h"

@interface HLDeliveryWayTableCell () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView *bagView;
@property(nonatomic, strong) UIButton *coverBtn;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIImageView *picImV;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *detailLb;
@property(nonatomic, strong) HLSwitch *switchBtn;
@property(nonatomic, strong) UILabel *ruleLb;
@property(nonatomic, strong) UIImageView *ruleArrow;
//顺序
@property(nonatomic, strong) UILabel *orderLb;
@end

@implementation HLDeliveryWayTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)setDeliveryInfo:(HLDeliveryWayInfo *)deliveryInfo {
    _deliveryInfo = deliveryInfo;
    _picImV.image = [UIImage imageNamed:_deliveryInfo.pic];
    _nameLb.text = deliveryInfo.name;
    _detailLb.text = deliveryInfo.detail;
    _switchBtn.select = deliveryInfo.on;
    _orderLb.text = deliveryInfo.order;
    _ruleLb.text = deliveryInfo.rule;
    _coverBtn.hidden = deliveryInfo.enable;
    self.tableView.hidden = !deliveryInfo.open;
    [self.tableView reloadData];
}

- (void)openClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.deliveryInfo.open = sender.selected;
    _ruleArrow.image = [UIImage imageNamed:sender.selected?@"arrow_up_grey":@"arrow_down_grey"];
    if ([self.delegate respondsToSelector:@selector(deliveryCell:deliveryInfo:)]) {
        [self.delegate deliveryCell:self deliveryInfo:_deliveryInfo];
    }
}

- (void)switchClick:(UITapGestureRecognizer *)sender {
    HLSwitch * switchV = (HLSwitch *)sender.view;
    if ([self.delegate respondsToSelector:@selector(deliveryCell:on:)]) {
        [self.delegate deliveryCell:self on:!switchV.select];
    }
}

- (void)coverClick {
    if (!self.deliveryInfo.enable) {
        [HLTools showWithText:@"暂未开启服务"];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.deliveryInfo.eleRoles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rules = _deliveryInfo.eleRoles[section];
    return rules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLDeliveryRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLDeliveryRuleCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell configBackgroundColor:UIColor.blackColor titleColor:UIColor.whiteColor];
    } else {
        NSInteger row = indexPath.row % 2;
        [cell configBackgroundColor:(row==0)?UIColorFromRGB(0xF8F8F8):UIColor.whiteColor titleColor:UIColorFromRGB(0x565656)];
    }
    NSArray *rules = _deliveryInfo.eleRoles[indexPath.section];
    cell.rule = rules[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.deliveryInfo.eleRoles.count -1) {
        return FitPTScreen(50);
    }
    return FitPTScreen(35);
}

#pragma mark - UIView
- (void)initSubView {
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bagView];
    _bagView.layer.shadowColor = [UIColor hl_StringToColor:@"#000000" andAlpha:0.08].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(2,3);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(15);
    _bagView.layer.borderWidth = 0.5;
    _bagView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _bagView.layer.cornerRadius = FitPTScreen(4);
    _bagView.layer.masksToBounds = NO;
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(FitPTScreen(7));
        make.height.equalTo(FitPTScreen(101));
    }];
    
    
    _picImV = [[UIImageView alloc]init];
    [_bagView addSubview:_picImV];
    [_picImV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(FitPTScreen(11));
        make.size.equalTo(CGSizeMake(FitPTScreen(25), FitPTScreen(25)));
    }];
    
    _nameLb = [UILabel hl_singleLineWithColor:@"#222222" font:16 bold:YES];
    [_bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImV.right).offset(FitPTScreen(7));
        make.centerY.equalTo(self.picImV);
    }];
    
    _switchBtn = [[HLSwitch alloc]init];
    [_bagView addSubview:_switchBtn];
    [_switchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.right).offset(FitPTScreen(5));
        make.centerY.equalTo(self.nameLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(37), FitPTScreen(23)));
    }];
    UITapGestureRecognizer * switchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchClick:)];
    [_switchBtn addGestureRecognizer:switchTap];
    
    _detailLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:11];
    [_bagView addSubview:_detailLb];
    [_detailLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(6));
    }];
    
    UIView *hLine = [[UIView alloc]init];
    hLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [_bagView addSubview:hLine];
    [hLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.bottom.equalTo(FitPTScreen(-37));
        make.size.equalTo(CGSizeMake(FitPTScreen(226), FitPTScreen(0.5)));
    }];
    
    UIView *vLine = [[UIView alloc]init];
    vLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [_bagView addSubview:vLine];
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hLine.right);
        make.centerY.equalTo(self.bagView);
        make.size.equalTo(CGSizeMake(FitPTScreen(0.5), FitPTScreen(79)));
    }];
    
    UIView *tipBag = [[UIView alloc]init];
    tipBag.backgroundColor = UIColorFromRGB(0xFFF9F2);
    tipBag.layer.cornerRadius = FitPTScreen(1);
    [_bagView addSubview:tipBag];
    [tipBag makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(FitPTScreen(11));
        make.size.equalTo(CGSizeMake(FitPTScreen(90), FitPTScreen(45)));
    }];
    
    _orderLb = [UILabel hl_singleLineWithColor:@"#FE9E30" font:11 bold:YES];
    [tipBag addSubview:_orderLb];
    [_orderLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(5));
        make.centerX.equalTo(tipBag);
    }];
    
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#FE9E30" font:11];
    tipLb.text = @"优先配送权";
    [tipBag addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-7));
        make.centerX.equalTo(tipBag);
    }];
    
    UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ask_oriange"]];
    [tipBag addSubview:tipImV];
    [tipImV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-4));
        make.top.equalTo(FitPTScreen(4));
    }];
    
    UIButton *downBtn = [UIButton hl_regularWithImage:@"arrow_down_grey_cricle" select:NO];
    [_bagView addSubview:downBtn];
    [downBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-23));
        make.bottom.equalTo(FitPTScreen(-12));
    }];
    
    UIButton *upBtn = [UIButton hl_regularWithImage:@"arrow_up_grey_cricle" select:NO];
    [_bagView addSubview:upBtn];
    [upBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(downBtn.left).offset(FitPTScreen(-17));
        make.bottom.equalTo(FitPTScreen(-12));
    }];
    
    UIButton *openBtn = [UIButton hl_regularWithImage:@"" select:NO];
    [_bagView addSubview:openBtn];
    [openBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(2));
        make.bottom.equalTo(FitPTScreen(-2));
        make.top.equalTo(hLine.bottom);
        make.right.equalTo(vLine);
    }];
    [openBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _ruleLb = [UILabel hl_regularWithColor:@"#565656" font:11];
    [_bagView addSubview:_ruleLb];
    [_ruleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.bottom.equalTo(FitPTScreen(-13));
    }];
    
    _ruleArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_grey"]];
    [_bagView addSubview:_ruleArrow];
    [_ruleArrow makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ruleLb.right).offset(FitPTScreen(11));
        make.centerY.equalTo(self.ruleLb);
    }];
    
    _coverBtn = [[UIButton alloc]init];
    _coverBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [_bagView addSubview:_coverBtn];
    [_coverBtn makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bagView);
    }];
    [_coverBtn addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bagView.bottom).offset(FitPTScreen(4));
        make.left.right.bottom.equalTo(self.contentView);
    }];
    [_tableView registerClass:[HLDeliveryRuleCell class] forCellReuseIdentifier:@"HLDeliveryRuleCell"];
}

@end


@interface HLDeliveryRuleCell ()
@property(nonatomic, strong) UIView *bagView;
@property(nonatomic, strong) UILabel *leftLb;
@property(nonatomic, strong) UILabel *rightLb;
@end

@implementation HLDeliveryRuleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.whiteColor;
    _bagView = [[UIView alloc]init];
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(22.5));
        make.right.equalTo(FitPTScreen(-22.5));
        make.top.bottom.equalTo(self.contentView);
    }];
    
    _leftLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    _leftLb.numberOfLines = 2;
    [_bagView addSubview:_leftLb];
    [_leftLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(22.5));
        make.centerY.equalTo(self.bagView);
    }];
    
    UIView *vLine = [[UIView alloc]init];
    vLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [_bagView addSubview:vLine];
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.height.equalTo(self.bagView);
        make.width.equalTo(0.5);
    }];
    
    _rightLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [_bagView addSubview:_rightLb];
    [_rightLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vLine.right).offset(FitPTScreen(33.5));
        make.centerY.equalTo(self.bagView);
    }];
}

- (void)configBackgroundColor:(UIColor *)color titleColor:(UIColor *)titleColor {
    _bagView.backgroundColor = color;
    _leftLb.textColor = titleColor;
    _rightLb.textColor = titleColor;
}

- (void)setRule:(HLDeliveryRule *)rule {
    _rule = rule;
    _leftLb.text = rule.col01;
    _rightLb.text = rule.col02;
}
@end
