//
//  HLButtonsView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/26.
//

#import "HLButtonsView.h"
#import "HLPrinterButton.h"

@interface HLButtonsView ()

@property (strong,nonatomic)NSArray *titles;

@property (strong,nonatomic)NSMutableArray<HLPrinterButton *> *buttons;

@property (strong,nonatomic)NSMutableArray * selectArray;

@property (strong,nonatomic)NSMutableArray * selectButtons;

@end

@implementation HLButtonsView

-(instancetype)initWithTitles:(NSArray *)titles{
    if (self = [super init]) {
        _titles = titles;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.backgroundColor = UIColorFromRGB(0xFAFAFA);
    UILabel * info = [[UILabel alloc]init];
    info.text = @"订单客户信息";
    info.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    info.textColor = UIColorFromRGB(0xABABAB);
    [self addSubview:info];
    [info makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    UIView * bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bottomView];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(FitPTScreen(45));
    }];
    
    [bottomView addSubview:[HLTools lineWithGap:0 topMargn:0]];
    [bottomView addSubview:[HLTools lineWithGap:0 topMargn:FitPTScreen(44)]];
    
    for (NSString * title in self.titles) {
        HLPrinterButton * button = [[HLPrinterButton alloc]initWithName:title];
        NSInteger index = [self.titles indexOfObject:title];
        button.tag = index;
        [bottomView addSubview:button];
        [self.buttons addObject:button];
        
        HLPrinterButton * lastButton = self.buttons.count > 1?self.buttons[index - 1]: nil;
        
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastButton?lastButton.mas_right:bottomView).offset(FitPTScreen(20));
            make.centerY.equalTo(bottomView);
        }];
        [button addTarget:self selecter:@selector(tapClick:)];
    }
}


-(void)tapClick:(NSObject *)sender{
    UITapGestureRecognizer * tap =(UITapGestureRecognizer *)sender;
    HLPrinterButton * button = (HLPrinterButton *)tap.view;
    button.selected = !button.selected;
    
    [self.selectArray removeAllObjects];
    for (int i= 0 ; i<_buttons.count; i++) {
        HLPrinterButton * btn = _buttons[i];
        if (btn.selected) {
            [self.selectArray addObject:[NSString stringWithFormat:@"%ld",btn.tag + 1]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(buttonsView:selectArray:)]) {
        [self.delegate buttonsView:self selectArray:self.selectArray];
    }
}

-(void)setSelectWithArray:(NSArray *)selectArr{
    for (NSString * select in selectArr) {
        HLPrinterButton * button = self.buttons[select.integerValue - 1];
        button.selected = YES;
        [self.selectButtons addObject:button];
    }
    
    for (HLPrinterButton * button  in self.buttons) {
        if (![self.selectButtons containsObject:button]) {
            button.selected = NO;
        }
    }
}

-(NSMutableArray<HLPrinterButton *> *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

-(NSMutableArray *)selectButtons{
    if (!_selectButtons) {
        _selectButtons = [NSMutableArray array];
    }
    return _selectButtons;
}

@end
