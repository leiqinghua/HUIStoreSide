//
//  HLCollegeDesViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/28.
//

#import "HLCollegeDesViewCell.h"

@interface HLCollegeDesViewCell()<UITextViewDelegate>

@property(nonatomic,strong)UIImageView * leftImgV;

@property(nonatomic,strong)UILabel * leftLb;

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)UITextView * textView;

@property(nonatomic,strong)UILabel * numLb;

@end

@implementation HLCollegeDesViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = UIColor.clearColor;
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, FitPTScreen(13), 0, FitPTScreen(13)));
    }];
    
    _leftImgV = [[UIImageView alloc]init];
    [_bagView addSubview:_leftImgV];
    [_leftImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(24));
    }];
    
    _leftLb = [[UILabel alloc]init];
    _leftLb.textColor = UIColorFromRGB(0x222222);
    _leftLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_bagView addSubview:_leftLb];
    [_leftLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgV.right).offset(FitPTScreen(12));
        make.centerY.equalTo(self.leftImgV);
    }];
    
    _textView = [[UITextView alloc]init];
    _textView.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _textView.layer.cornerRadius = FitPTScreen(6);
    _textView.layer.borderColor = UIColorFromRGB(0xEAEAEA).CGColor;
    _textView.layer.borderWidth = FitPTScreen(1);
    _textView.delegate = self;
    _textView.tintColor = UIColorFromRGB(0xff8717);
    [_bagView addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(self.leftLb.bottom).offset(FitPTScreen(17));
        make.width.equalTo(FitPTScreen(309));
        make.height.equalTo(FitPTScreen(147));
    }];
    
    _numLb = [[UILabel alloc]init];
    _numLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_bagView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textView.right).offset(FitPTScreen(-11));
        make.bottom.equalTo(self.textView.bottom).offset(FitPTScreen(-10));
    }];
}


-(void)setInfoModel:(HLInfoModel *)infoModel{
    _infoModel = infoModel;
    HLCollegeDesModel * desModel = (HLCollegeDesModel *)_infoModel;
    _leftImgV.image = [UIImage imageNamed:desModel.leftPic];
    _leftLb.text = desModel.leftText;
    _textView.zw_placeHolder = desModel.placeHolder;
    _textView.text = desModel.text;
    _textView.keyboardType = desModel.keyboardType;
    _numLb.attributedText = [self numAttr];
    _numLb.hidden = !desModel.showNumLb;
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    HLCollegeDesModel * desModel = (HLCollegeDesModel *)_infoModel;
    if (desModel.maxNum == 0) {
        self.infoModel.text = textView.text;
        _numLb.attributedText = [self numAttr];
        return;
    }
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > desModel.maxNum) {
                textView.text = [toBeString substringToIndex:desModel.maxNum];
            }
        }
    }else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > desModel.maxNum) {
            textView.text = [toBeString substringToIndex:desModel.maxNum];
        }
    }
    
    self.infoModel.text = textView.text;
    _numLb.attributedText = [self numAttr];
}

-(NSAttributedString *)numAttr{
    HLCollegeDesModel * desModel = (HLCollegeDesModel *)_infoModel;
    NSString * text = [NSString stringWithFormat:@"%ld/%ld",_textView.text.length,desModel.maxNum];
    NSMutableAttributedString * mutrr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xACACAC)}];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%ld",_textView.text.length]];
    [mutrr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFFAF25)} range:range];
    return mutrr;
}

@end


@implementation HLCollegeDesModel



@end
