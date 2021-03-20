//
//  HLSpecialPeron.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/19.
//

#import "HLSpecialPeron.h"

@implementation HLSpecialPeron

- (NSString *)mobileText {
    if (!_mobileText) {
        if (!_mobile) return @"";
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"] invertedSet];
        NSString *text = [NSString stringWithString:_mobile];
        //    在第一个位置插入一个空格
        NSMutableString *mutString = [NSMutableString stringWithString:text];
        [mutString insertString:@" " atIndex:0];
        text = mutString;
        _mobileText = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            _mobileText = [_mobileText stringByAppendingString:subString];
            if (subString.length == 4) {
                _mobileText = [_mobileText stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        //    去除前面的空格
        _mobileText = [_mobileText stringByTrimmingCharactersInSet:characterSet];
    }
    return _mobileText;
}
@end


@implementation HLSpecialMainInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"mobile_info":@"HLSpecialPeron",
             };
}
@end

