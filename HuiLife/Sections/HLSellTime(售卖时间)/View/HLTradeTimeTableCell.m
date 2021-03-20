//
//  HLTradeTimeTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import "HLTradeTimeTableCell.h"
#import "HLSellTimeSelectView.h"

@interface HLTradeTimeTableCell () <HLTradeTimeItemDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, strong) UIScrollView *bottomView;

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation HLTradeTimeTableCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:NO];
    
    _titleLb = [UILabel hl_regularWithColor:@"#333333" font:14];
    [self.bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(FitPTScreen(19));
    }];
    
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.rowHeight = FitPTScreen(50);
    [self.bagView addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.bagView);
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(10));
        make.height.equalTo(FitPTScreen(250));
    }];
    [_tableView registerClass:[HLTradeTimeItemCell class] forCellReuseIdentifier:@"HLTradeTimeItemCell"];

}

#pragma mark - setter
- (void)setModel:(HLSellModel *)model {
    _model = model;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:model.title];
    if ([model.title containsString:@"*"]) {
        [attr addAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xFF3A3A)} range:NSMakeRange(0, 1)];
    }
    _titleLb.attributedText = attr;
    
    [self.tableView reloadData];
}

#pragma mark - Method
- (NSInteger)compareWithStart:(NSString *)startTime end:(NSString *)endTime format:(NSString *)format {
    NSString *start = startTime;
    NSString *end = endTime;
    if ([start isEqualToString:@"24:00"]) {
        start = @"23:59";
    }
    if ([end isEqualToString:@"24:00"]) {
        end = @"23:59";
    }
    return [HLTools compareWithFirst:start another:end formate:format];
}

#pragma mark - HLTradeTimeItemDelegate
- (void)tradeTime:(HLTimeModel *)timeModel add:(BOOL)isAdd {
    NSMutableArray *times = [NSMutableArray arrayWithArray:_model.values];
    if (isAdd) { //添加
        if (times.count >= 5) {
            HLShowHint(@"最多可设置5个营业时间", nil);
            return;
        }
        HLTimeModel *model = [[HLTimeModel alloc]init];
//        [times insertObject:model atIndex:1];
        [times addObject:model];
        _model.values = [times copy];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:times.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    //删除
    NSInteger index = [_model.values indexOfObject:timeModel];
    [times removeObject:timeModel];
    _model.values = [times copy];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tradeTime:(HLTimeModel *)timeModel begin:(BOOL)begin dependView:(nonnull UIView *)dependView{
    __block NSInteger index= -1;
    [_timeData enumerateObjectsUsingBlock:^(NSString *  _Nonnull time, NSUInteger idx, BOOL * _Nonnull stop) {
        if (([time isEqualToString:timeModel.beginTime] && begin) || ([time isEqualToString:timeModel.endTime] && !begin)) {
            index = idx;
        }
    }];
    
    [HLSellTimeSelectView showWithTitles:_timeData selectIndex:index dependView:dependView completion:^(NSInteger index) {
        NSString *time = _timeData[index];
        NSInteger row = [self.model.values indexOfObject:timeModel];
        if (begin) {
            //            判断 begin<end
            NSInteger result = [self compareWithStart:time end:timeModel.endTime format:@"HH:mm"];
            if ((result == 1 && timeModel.endTime.length) || !timeModel.endTime.length) {
                timeModel.beginTime = time;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                return;
            }
            HLShowHint(@"起始时间应小于结束时间", nil);
            return;
        }
        NSInteger result = [self compareWithStart:timeModel.beginTime end:time format:@"HH:mm"];;
        if ((result == 1 && timeModel.beginTime.length) || !timeModel.beginTime.length) {
            timeModel.endTime = time;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        HLShowHint(@"结束时间应大于起始时间", nil);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLTradeTimeItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLTradeTimeItemCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.optionType = indexPath.row == 0?0:1;
    cell.model = _model.values[indexPath.row];
    cell.delegate = self;
    return cell;
}

@end


@interface HLTradeTimeItemCell ()

@property(nonatomic, strong) UIButton *optionBtn;

@property(nonatomic, strong) UILabel *leftLb;

@property(nonatomic, strong) UILabel *rightLb;

@end

@implementation HLTradeTimeItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}


- (void)initSubView {
    _optionBtn = [[UIButton alloc]init];
    _optionBtn.layer.cornerRadius = FitPTScreen(6);
    _optionBtn.layer.borderWidth = 0.5;
    _optionBtn.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    [self.contentView addSubview:_optionBtn];
    [_optionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(12));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(40), FitPTScreen(40)));
    }];
    [_optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *optionView = [[UIView alloc]init];
    optionView.layer.cornerRadius = FitPTScreen(6);
    optionView.layer.borderWidth = 0.5;
    optionView.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    [self.contentView addSubview:optionView];
    [optionView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.optionBtn.left).offset(FitPTScreen(-12));
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(FitPTScreen(40));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [optionView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(optionView);
        make.centerY.equalTo(optionView);
        make.size.equalTo(CGSizeMake(FitPTScreen(0.5), FitPTScreen(16)));
    }];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.tag = 1000;
    [optionView addSubview:leftBtn];
    [leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(optionView);
        make.right.equalTo(line.left);
    }];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.tag = 1001;
    [optionView addSubview:rightBtn];
    [rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(optionView);
        make.left.equalTo(line.right);
    }];
    [leftBtn addTarget:self action:@selector(showTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(showTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    

    _leftLb = [UILabel hl_regularWithColor:@"#222222" font:12];
    _leftLb.text = @"请选择开始时间";
    [leftBtn addSubview:_leftLb];
    [_leftLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(leftBtn);
    }];
//
    UIImageView *leftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"time_black"]];
    [leftBtn addSubview:leftImg];
    [leftImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftLb.left).offset(FitPTScreen(-8));
        make.centerY.equalTo(self.leftLb);
    }];
    
    UIImageView *leftArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_darkBlack"]];
    [leftBtn addSubview:leftArrow];
    [leftArrow makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLb.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.leftLb);
    }];

    _rightLb = [UILabel hl_regularWithColor:@"#222222" font:12];
    _rightLb.text = @"请选择结束时间";
    [rightBtn addSubview:_rightLb];
    [_rightLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(rightBtn);
    }];
    //
    UIImageView *rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"time_black"]];
    [rightBtn addSubview:rightImg];
    [rightImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLb.left).offset(FitPTScreen(-8));
        make.centerY.equalTo(self.rightLb);
    }];
    
    UIImageView *rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_darkBlack"]];
    [rightBtn addSubview:rightArrow];
    [rightArrow makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightLb.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.rightLb);
    }];
    
}

- (void)setOptionType:(NSInteger)optionType {
    _optionType = optionType;
    NSString *image = @"add_black";
    if (_optionType == 1) {
        image = @"delete_black";
    }
    [_optionBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)setModel:(HLTimeModel *)model {
    _model = model;
    _leftLb.text = model.beginTime.length?model.beginTime:@"请选择开始时间";
    _rightLb.text = model.endTime.length?model.endTime:@"请选择结束时间";
    
}

- (void)optionClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(tradeTime:add:)]) {
        [self.delegate tradeTime:_model add:(_optionType == 0)];
    }
}

- (void)showTimeClick:(UIButton *)sender {
    BOOL begin = sender.tag == 1000;
    if ([self.delegate respondsToSelector:@selector(tradeTime:begin:dependView:)]) {
        [self.delegate tradeTime:_model begin:begin dependView:sender];
    }
}

@end
