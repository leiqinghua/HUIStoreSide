//
//  HLTextViewTableCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLTextViewTableCell.h"

@interface HLTextViewTableCell()<UITextViewDelegate>

@property(nonatomic,strong)UILabel * titleLb;

@property(nonatomic,strong)UITextView * textView;

@property(nonatomic,strong)UIView * bottomLine;

@end

@implementation HLTextViewTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _titleLb.text = @"详细地址";
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.centerY.equalTo(self.contentView);
    }];
    
    _textView = [[UITextView alloc]init];
    [self.contentView addSubview:_textView];
    _textView.textColor = UIColorFromRGB(0x666666);
    _textView.textAlignment = NSTextAlignmentRight;
    _textView.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textView.zw_placeHolderColor = UIColorFromRGB(0x666666);
    _textView.placeholder = @"请输入地址";
    _textView.tintColor = UIColorFromRGB(0xff8717);
    _textView.delegate = self;
    [_textView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(FitPTScreen(-15));
        make.width.equalTo(FitPTScreen(234));
        make.height.equalTo(FitPTScreen(30));
        make.centerY.equalTo(self.contentView);
//        make.top.equalTo(FitPTScreen(5));
//        make.bottom.equalTo(FitPTScreen(-5));
    }];
    
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [self.contentView addSubview:_bottomLine];
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-1));
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(FitPTScreenH(1));
    }];
}


- (void)textViewDidChange:(UITextView *)textView{
    self.inputModel.value = textView.text;
    [self updateTextViewHight];
}


- (void)updateTextViewHight{
    NSString *text = self.textView.text;
    CGFloat width = [HLTools estmateWidthString:text Font:[UIFont systemFontOfSize:FitPTScreen(14)]];
    CGFloat hight = FitPTScreen(30);
    if (width > FitPTScreen(200)) {
        hight = FitPTScreen(55);
    }
    [_textView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(hight);
    }];
}


- (void)setInputModel:(HLBaseInputModel *)inputModel{
    _inputModel = inputModel;
    _textView.editable = inputModel.canEdit;
    _titleLb.text = inputModel.text;
    _textView.placeholder = inputModel.place;
    _textView.text = inputModel.value?:@"";
    _bottomLine.hidden = inputModel.hideLine;
    [self updateTextViewHight];
    
}


@end
