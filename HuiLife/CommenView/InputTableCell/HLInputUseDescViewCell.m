//
//  HLInputUseDescViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLInputUseDescViewCell.h"

@interface HLInputUseDescViewCell ()<UITextViewDelegate>

@property(nonatomic,strong)UITextView * textView;

@property(nonatomic,strong)UILabel * numLb;

@end

@implementation HLInputUseDescViewCell

- (void)initSubUI{
    [super initSubUI];
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(18));
    }];
    
    _textView = [[UITextView alloc]init];
    _textView.textColor = UIColorFromRGB(0x555555);
    _textView.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _textView.layer.cornerRadius = FitPTScreen(4);
    _textView.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    _textView.layer.borderWidth = FitPTScreen(1);
    _textView.tintColor = UIColorFromRGB(0xff8717);
    [self.contentView addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(11));
        make.width.equalTo(FitPTScreen(350));
        make.bottom.equalTo(FitPTScreen(-10));
    }];
    _textView.delegate = self;
    
    
    _numLb = [[UILabel alloc]init];
    _numLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textView.right).offset(FitPTScreen(-11));
        make.bottom.equalTo(self.textView.bottom).offset(FitPTScreen(-10));
    }];
    _numLb.hidden = YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    HLInputUseDescInfo * info = (HLInputUseDescInfo *)self.baseInfo;
    
    if (info.singleLine && [text isEqualToString:@"\n"]) {
        return NO;
    }
    
    if (!info.changeLine) {
        return YES;
    }
    
    NSMutableString * mutStr = [NSMutableString stringWithString:textView.text];
    [mutStr replaceCharactersInRange:range withString:text];
    
    self.baseInfo.text = mutStr;
    
    return YES;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    
    HLLog(@"textView = %@",textView.text);
    
    HLInputUseDescInfo * info = (HLInputUseDescInfo *)self.baseInfo;
    if (info.changeLine) {
        return;
    }
    if (!info.showNum) {
        self.baseInfo.text = textView.text;
        return;
    }

    if (info.maxNum == 0) {
        info.text = textView.text;
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
            if (toBeString.length > info.maxNum) {
                textView.text = [toBeString substringToIndex:info.maxNum];
            }
        }
    }else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > info.maxNum) {
            textView.text = [toBeString substringToIndex:info.maxNum];
        }
    }
    
    info.text = textView.text;
    _numLb.attributedText = [self numAttr];
}

- (NSAttributedString *)numAttr{
    HLInputUseDescInfo * info = (HLInputUseDescInfo *)self.baseInfo;
    NSString * text = [NSString stringWithFormat:@"%ld/%ld",_textView.text.length,info.maxNum];
    NSMutableAttributedString * mutrr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xACACAC)}];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%ld",_textView.text.length]];
    [mutrr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFFAF25)} range:range];
    return mutrr;
}


-(void)setBaseInfo:(HLInputUseDescInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    _textView.placeholder = baseInfo.placeHolder;
    _textView.text = baseInfo.text;
    _numLb.hidden = !baseInfo.showNum;
    _numLb.attributedText = [self numAttr];
    if (baseInfo.hideBorder) {
        _textView.layer.borderColor = UIColor.clearColor.CGColor;
        _textView.layer.borderWidth = 0;
    } else {
        _textView.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
        _textView.layer.borderWidth = FitPTScreen(1);
    }
}

@end


@implementation HLInputUseDescInfo

-(BOOL)checkParamsIsOk{
    if (!self.needCheckParams) {
        return YES;
    }
    if (!self.text.length && !self.mParams.count) {
        return NO;
    }
    return YES;
}

@end
