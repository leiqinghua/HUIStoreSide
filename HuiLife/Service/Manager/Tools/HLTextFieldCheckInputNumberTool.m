//
//  HLTextFieldCheckInputNumberTool.m
//  HuiLife
//
//  Created by 雷清华 on 2018/9/3.
//

#import "HLTextFieldCheckInputNumberTool.h"

@implementation HLTextFieldCheckInputNumberTool


-(void)textFieldDidChanged:(UITextField *)obj
{

    UITextField *textField = obj;
    NSString *toBeString = textField.text;
    textField.contentMode = UIViewContentModeScaleAspectFit;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > _MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:_MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

-(void)textViewDidChangeText:(NSNotification *)sender{
    UITextView *textView = (UITextView *)sender.object;
    NSString *toBeString = textView.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
         UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _MAX_STARWORDS_LENGTH) {
                // 截取子串
                textView.text = [toBeString substringToIndex:_MAX_STARWORDS_LENGTH];
            }
        }
    }else {
         // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > _MAX_STARWORDS_LENGTH) {
            // 截取子串
            textView.text = [toBeString substringToIndex:_MAX_STARWORDS_LENGTH];
        }
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 10000) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            
            if (character < 48) return NO; // 48 unichar for 0
            
            if (character > 57 && character < 65) return NO; //
            
            if (character > 90 && character < 97) return NO;
            
            if (character > 122) return NO;
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > _MAX_STARWORDS_LENGTH) {
            return NO;//限制长度
        }
    }
    return YES;
}
@end
