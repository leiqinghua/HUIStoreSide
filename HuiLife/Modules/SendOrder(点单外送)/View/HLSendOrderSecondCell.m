//
//  HLSendOrderSecondCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/8.
//

#import "HLSendOrderSecondCell.h"
#import "HLSwitch.h"

@interface HLSendOrderSecondCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) HLSwitch *switchOn;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) NSMutableArray *btnArr;

@end

@implementation HLSendOrderSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _titleLab = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLab];
    _titleLab.textColor = UIColorFromRGB(0x333333);
    _titleLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(20));
        make.left.equalTo(FitPTScreen(14));
    }];
    
    _stateLab = [[UILabel alloc] init];
    [self.contentView addSubview:_stateLab];
    _stateLab.textColor = UIColorFromRGB(0x999999);
    _stateLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [_stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.right).offset(FitPTScreen(3));
        make.centerY.equalTo(_titleLab);
    }];
    
    _subTitleLab = [[UILabel alloc] init];
    [self.contentView addSubview:_subTitleLab];
    _subTitleLab.textColor = UIColorFromRGB(0x666666);
    _subTitleLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_subTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.bottom).offset(FitPTScreen(7));
        make.left.equalTo(_titleLab);
    }];
    
    _switchOn = [[HLSwitch alloc]init];
    [self.contentView addSubview:_switchOn];
    [_switchOn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.top.equalTo(FitPTScreen(27));
        make.width.equalTo(FitPTScreen(43));
        make.height.equalTo(FitPTScreen(22));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_switchOn addGestureRecognizer:tap];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = UIColorFromRGB(0xDADADA);
    [self.contentView addSubview:_line];
    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.right.equalTo(FitPTScreen(-14));
        make.height.equalTo(0.6);
        make.top.equalTo(_switchOn.bottom).offset(FitPTScreen(29));
    }];
    
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [self creatFuncButton];
        [self.contentView addSubview:button];
        button.layer.cornerRadius = FitPTScreen(12.5);
        button.layer.borderWidth = FitPTScreen(0.8);
        button.layer.masksToBounds = YES;
        button.tag = i;
        button.layer.borderColor = UIColorFromRGB(0xFF9F16).CGColor;
        [self.btnArr addObject:button];
        [button addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.contentView addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(FitPTScreen(10));
    }];
}

- (UIButton *)creatFuncButton{
    
    UIButton *button = [[UIButton alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [button addSubview:imageView];
    imageView.tag = 101;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.height.width.equalTo(FitPTScreen(10));
        make.centerY.equalTo(button);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0xFF9F16);
    label.tag = 102;
    label.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [button setTitleColor:UIColorFromRGB(0xFF9F16) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [button addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.right).offset(FitPTScreen(4));
        make.centerY.equalTo(button);
    }];
    
    return button;
}

- (void)tapClick:(UITapGestureRecognizer *)sender{
    HLSwitch * switchV = (HLSwitch *)sender.view;
    switchV.select = !switchV.select;
    _secondInfo.isOpen = switchV.select;
    _stateLab.text = _secondInfo.isOpen ? @"已开启" : @"未开启";
    if (self.delegate) {
        [self.delegate switchValueChangeWithSecondFuncCell:self];
    }
}

- (void)subButtonClick:(UIButton *)button{
    if (self.delegate) {
        [self.delegate secondFuncCell:self clickFuncInfo:self.secondInfo.items[button.tag]];
    }
}

-(void)setSecondInfo:(HLSendOrderSecondInfo *)secondInfo{
    _secondInfo = secondInfo;
    _titleLab.text = secondInfo.title;
    _subTitleLab.text = secondInfo.subTitle;
    _switchOn.select = secondInfo.isOpen;
    _stateLab.text = secondInfo.isOpen ? @"已开启" : @"未开启";
    //创建button
    NSInteger row = 0;
    CGFloat rowWidth = FitPTScreen(25);
    for (int i = 0; i< secondInfo.items.count; i++) {
        UIButton *button = [self creatFuncButton];
        [self.contentView addSubview:button];
        button.layer.cornerRadius = FitPTScreen(12.5);
        button.layer.borderWidth = FitPTScreen(0.8);
        button.layer.masksToBounds = YES;
        button.tag = i;
        button.layer.borderColor = UIColorFromRGB(0xFF9F16).CGColor;
        [self.btnArr addObject:button];
        [button addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        HLSendOrderSecondFuncInfo *info = secondInfo.items[i];
        UIImageView *imageView = [button viewWithTag:101];
        UILabel *label = [button viewWithTag:102];
        label.text = info.title;
        [imageView sd_setImageWithURL:[NSURL URLWithString:info.pic]];
        
        CGFloat itemWidth = [secondInfo.itemWidthArr[i] floatValue];
        
//        NSInteger row = i / 3;
//        [button makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(itemWidth);
//            make.height.equalTo(FitPTScreen(25));
//            make.top.equalTo(_line.bottom).offset(FitPTScreen(15) + row *(FitPTScreen(25)+FitPTScreen(15)));
//            if (i == 0) {make.left.equalTo(FitPTScreen(25));}
//            if (i == 1) {make.left.equalTo(FitPTScreen(143));}
//            if (i == 2) {make.right.equalTo(FitPTScreen(-22));}
//            if (i == 3) {make.left.equalTo(FitPTScreen(25));}
//        }];
        if (rowWidth + itemWidth + FitPTScreen(15) > ScreenW - FitPTScreen(10)) {
            rowWidth = FitPTScreen(25);
            row += 1;
        }
        
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rowWidth);
            make.top.equalTo(_line.bottom).offset(FitPTScreen(15) + row *(FitPTScreen(25)+FitPTScreen(15)));
            make.size.equalTo(CGSizeMake(itemWidth, FitPTScreen(25)));
        }];
        
        rowWidth += itemWidth + FitPTScreen(15);
       
    }
    
    
    
    
    
//    for (NSInteger i = 0; i < self.btnArr.count; i++) {
//        UIButton *button = self.btnArr[i];
//        button.hidden = i == secondInfo.items.count;
//        if (i < secondInfo.itemWidthArr.count) {
//            HLSendOrderSecondFuncInfo *info = secondInfo.items[i];
//            UIImageView *imageView = [button viewWithTag:101];
//            UILabel *label = [button viewWithTag:102];
//            label.text = info.title;
//            [imageView sd_setImageWithURL:[NSURL URLWithString:info.pic]];
//
//            CGFloat itemWidth = [secondInfo.itemWidthArr[i] floatValue];
//            [button remakeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(itemWidth);
//                make.height.equalTo(FitPTScreen(25));
//                make.top.equalTo(_line.bottom).offset(FitPTScreen(15));
//                if (i == 0) {make.left.equalTo(FitPTScreen(25));}
//                if (i == 1) {make.left.equalTo(FitPTScreen(143));}
//                if (i == 2) {make.right.equalTo(FitPTScreen(-22));}
//            }];
//        }
//    }
}

-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

@end
