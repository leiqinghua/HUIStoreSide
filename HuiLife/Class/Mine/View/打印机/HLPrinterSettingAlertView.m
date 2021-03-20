//
//  HLPrinterSettingAlertView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//

#import "HLPrinterSettingAlertView.h"

#define AlertCell_H 50

#define PickerView_H 147

#define PickerViewCell_H 46

#define AnimateTime 0.2

@interface HLPrinterSettingAlertView()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{

    BOOL  _isBlueTooth;//有么有选择蓝牙
    
    BOOL _isSingle;//是否单选
}

@property(assign,nonatomic)NSInteger defaultIndex;

@property (strong,nonatomic)UILabel * titleLable;

@property (copy,nonatomic)NSString * title;

@property (strong,nonatomic)UITableView * tableView;

@property (assign,nonatomic)HLPrinterViewStyle style;

@property (strong,nonatomic)UIView * bagView;

@property (strong,nonatomic)UIView * alertView;

@property (strong,nonatomic)NSArray * dataSource;

@property (copy,nonatomic)CallBackBlock callBack;

@property (copy,nonatomic)MutableSelectBlock mu_callBack;

@property(strong,nonatomic)UIPickerView * pickerView;

@property(strong,nonatomic)UILabel * pickerShowLable;

//    所有选择的
@property(strong,nonatomic)NSMutableArray * selects;;
@end

@implementation HLPrinterSettingAlertView

//多选
+ (void)showWithTitle:(NSString *)title type:(HLPrinterViewStyle)style dataSource:(NSArray *)dataSource selects:(MutableSelectBlock)callBack{
    HLPrinterSettingAlertView * alertView = [[HLPrinterSettingAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds title:title Type:style dataSource:dataSource defaultIndex:0];
    alertView.mu_callBack = callBack;
    alertView->_isSingle = NO;
    [KEY_WINDOW addSubview:alertView];
    [alertView alertAnimate];
}


//单选
+ (void)showWithTitle:(NSString *)title type:(HLPrinterViewStyle)style dataSource:(NSArray *)dataSource defaultIndex:(NSInteger)index callBack:(CallBackBlock)callBack{
    HLPrinterSettingAlertView * alertView = [[HLPrinterSettingAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds title:title Type:style dataSource:dataSource defaultIndex:index];
    alertView.callBack = callBack;
    alertView->_isSingle = YES;
    [KEY_WINDOW addSubview:alertView];
    [alertView alertAnimate];
}


-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title Type:(HLPrinterViewStyle)style dataSource:(NSArray *)dataSource defaultIndex:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        _title = title;
        _style = style;
        _dataSource = dataSource;
        _defaultIndex = index;
        [self initSubViews];
    }
    return self;
}

-(void)cancelClick{
    [self hideAnimate];
}

-(void)buttonClick:(UIButton *)sender{
    NSInteger index = 0;
    if (sender.tag == 1001) {
        index = 1;
    }
    [self hideAnimate];
    
    if (!_isSingle) {
        self.mu_callBack(_isBlueTooth, self.selects);
        return;
    }
    
    if (self.callBack) {
        self.callBack(index, _defaultIndex);
    }
}

-(void)alertAnimate{
    [UIView animateWithDuration:AnimateTime animations:^{
        CGRect frame = self.alertView.frame;
        frame.origin.y = self.bounds.size.height - frame.size.height;
        self.alertView.frame = frame;
        self.bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideAnimate{
    [UIView animateWithDuration:AnimateTime animations:^{
        CGRect frame = self.alertView.frame;
        frame.origin.y = self.bounds.size.height;
        self.alertView.frame = frame;
        self.bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(NSMutableArray *)selects{
    if (!_selects) {
        _selects = [NSMutableArray array];
    }
    return _selects;
}


-(void)initSubViews{
    _bagView = [[UIView alloc]initWithFrame:self.bounds];
    _bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:_bagView];
    
    CGFloat alert_h = self.dataSource.count * FitPTScreen(AlertCell_H);
    
    if (_style ==HLPrinterViewStyleScroll) {
        alert_h = FitPTScreen(PickerView_H);
    }
    
    CGFloat totleH = FitPTScreen(45 + 50) + alert_h + Height_Bottom_Margn;
    CGFloat tableH = self.dataSource.count * FitPTScreen(AlertCell_H);
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, ScreenW, totleH)];
    _alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_alertView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_alertView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _alertView.bounds;
    maskLayer.path = maskPath.CGPath;
    _alertView.layer.mask  = maskLayer;
    
    UILabel * titleLb = [[UILabel alloc]init];
    titleLb.textColor = UIColorFromRGB(0x333333);
    titleLb.text = _title;
    titleLb.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [_alertView addSubview:titleLb];
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.alertView);
        make.height.equalTo(FitPTScreen(50));
    }];
    
    UIButton * cancel = [[UIButton alloc]init];
    [cancel setImage:[UIImage imageNamed:@"colse_x_light_grey"] forState:UIControlStateNormal];
    [_alertView addSubview:cancel];
    [cancel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLb);
        make.right.equalTo(self.alertView);
        make.width.height.equalTo(FitPTScreenH(40));
    }];
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (_style == HLPrinterViewStyleDefault) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HLPrinterSettingAlertViewCell class] forCellReuseIdentifier:@"HLPrinterSettingAlertViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = FitPTScreen(AlertCell_H);
        [_alertView addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bagView);
            make.top.equalTo(titleLb.bottom);
            make.height.equalTo(tableH);
        }];
    }
    else{
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = UIColor.whiteColor;
        [_alertView addSubview:_pickerView];
        [_pickerView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.alertView);
            make.top.equalTo(titleLb.bottom);
            make.height.equalTo(FitPTScreen(PickerView_H));
        }];
        
        UILabel * tip = [[UILabel alloc]init];
        tip.text = @"联";
        tip.textColor = UIColorFromRGB(0x656565);
        tip.font = [UIFont systemFontOfSize:FitPTScreen(18)];
        [_pickerView addSubview:tip];
        [tip makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-122));
            make.centerY.equalTo(self.pickerView.top).equalTo(FitPTScreenH(PickerViewCell_H * 1.5 + 5));
        }];
        
        //选中默认的
        [_pickerView selectRow:_defaultIndex inComponent:0 animated:YES];
        
    }
    
    UIButton * cancelBtn = [[UIButton alloc]init];
    cancelBtn.tag = 1000;
    cancelBtn.backgroundColor = UIColor.whiteColor;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [_alertView addSubview:cancelBtn];
    
    UIButton * concernBtn = [[UIButton alloc]init];
    concernBtn.tag = 1001;
    [concernBtn setBackgroundImage:[UIImage imageNamed:@"concern_bg"] forState:UIControlStateNormal];;
    [concernBtn setTitle:@"确认" forState:UIControlStateNormal];
    [concernBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    concernBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [_alertView addSubview:concernBtn];
    
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.alertView);
        make.width.equalTo(FitPTScreen(188));
        make.height.equalTo(FitPTScreenH(45) + Height_Bottom_Margn);
    }];
    
    [concernBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.alertView);
        make.width.equalTo(FitPTScreen(188));
        make.height.equalTo(FitPTScreenH(45) + Height_Bottom_Margn);
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0x333333);
    [cancelBtn addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(cancelBtn);
        make.height.equalTo(FitPTScreen(0.3));
    }];
    [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [concernBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLPrinterSettingAlertViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLPrinterSettingAlertViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HLPrinterItemModel * model = self.dataSource[indexPath.row];
    if (_isSingle) {
        model.selected = indexPath.row == _defaultIndex;
    }
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _defaultIndex = indexPath.row;
    if (!_isSingle) {//多选的情况下
        HLPrinterItemModel * model = self.dataSource[indexPath.row];
        model.selected = !model.selected;
        [self addSelectModel:model];
    }
    [self.tableView reloadData];
}

//添加选中的model
-(void)addSelectModel:(HLPrinterItemModel *)model{
    if (model.selected && ![self.selects containsObject:model]) {
        [self.selects addObject:model];
        if (model.isBluetooth) {
            _isBlueTooth = YES;
        }
    }else if (!model.selected && [self.selects containsObject:model]){
        [self.selects removeObject:model];
        if (model.isBluetooth) {
            _isBlueTooth = NO;
        }
    }
}

#pragma mark -UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

//返回每列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.bounds.size.width;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return FitPTScreenH(PickerViewCell_H);
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for(UIView *speartorView in pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = UIColor.clearColor;//隐藏分割线
        }
    }
    UILabel * titleLable = (UILabel *)view;
    if (!titleLable) {
        titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreenH(46))];
        titleLable.textAlignment = NSTextAlignmentCenter;
    }
    if (row == _defaultIndex) {
        titleLable.textColor = UIColorFromRGB(0x656565);
        titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(20)];
    }else{
        titleLable.textColor = UIColorFromRGB(0x656565);
        titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    }
    titleLable.text = self.dataSource[row];
    return titleLable;
}

//返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel * lable = (UILabel *)[pickerView viewForRow:row forComponent:component];
    lable.textColor = UIColorFromRGB(0x656565);
    lable.font = [UIFont systemFontOfSize:FitPTScreenH(20)];
    _defaultIndex = row;
}


@end


@interface HLPrinterSettingAlertViewCell()

@property (strong,nonatomic)UILabel * title;

@property (strong,nonatomic)UIButton * button;

@property (strong,nonatomic)UIImageView * pic;

@end

@implementation HLPrinterSettingAlertViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    _pic = [[UIImageView alloc]init];
    [self.contentView addSubview:_pic];
    [_pic makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(30));
        make.centerY.equalTo(self.contentView);
    }];
    
    _title = [[UILabel alloc]init];
    _title.textColor = UIColorFromRGB(0x444444);
    _title.font = [UIFont systemFontOfSize: FitPTScreen(15)];
    [self.contentView addSubview:_title];
    [_title makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pic.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.contentView);
    }];
    
    _button = [[UIButton alloc]init];
    _button.tag = 10000;
    [_button setImage:[UIImage imageNamed:@"circle_normal"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"success_oriange"] forState:UIControlStateSelected];
    [self.contentView addSubview:_button];
    [_button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self.contentView);
    }];
}


-(void)setModel:(HLPrinterItemModel *)model{
    _model = model;
    _title.text = model.title;
    _pic.image = [UIImage imageNamed:model.leftPic];
    _button.selected = model.selected;
    if (![model.leftPic hl_isAvailable]) {
        [_pic updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(10));
        }];
    }
}

@end

@implementation HLPrinterItemModel

@end
