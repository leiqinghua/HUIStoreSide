//
//  HLBuyCardListViewCell.m
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import "HLBuyCardListViewCell.h"

@implementation HLBuyCardListViewModel

@end

@interface HLBuyCardListViewCell ()

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation HLBuyCardListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)creatSubViews{
    
    self.tipLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.tipLab];
    self.tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.tipLab.textColor = [UIColor hl_StringToColor:@"#666666"];
    [self.tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(FitPTScreen(12.5));
        make.width.mas_lessThanOrEqualTo(FitPTScreen(90));
    }];
    
    self.textField = [[UITextField alloc] init];
    [self.contentView addSubview:self.textField];
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.textField.textColor = [UIColor hl_StringToColor:@"#333333"];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLab.right).offset(FitPTScreen(5));
        make.top.bottom.equalTo(0);
        make.right.equalTo(FitPTScreen(-12));
    }];
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)textFieldChanged:(UITextField *)sender{
    self.listModel.inputValue = sender.text;
}

- (void)setListModel:(HLBuyCardListViewModel *)listModel{
    _listModel = listModel;
    self.tipLab.text = listModel.tip;
    self.textField.enabled = listModel.canEdit;
    self.textField.keyboardType = listModel.keyboardType;
    self.textField.placeholder = listModel.placeHolder;
    self.textField.text = listModel.inputValue;
}

@end


