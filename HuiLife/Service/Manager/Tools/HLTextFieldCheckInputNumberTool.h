//
//  HLTextFieldCheckInputNumberTool.h
//  HuiLife
//
//  Created by 雷清华 on 2018/9/3.
//

#import <Foundation/Foundation.h>

@protocol HLTextFieldCheckInputNumberDelegate

-(void)textFieldDidChanged:(UITextField *)obj;

-(void)textViewDidChangeText:(NSNotification *)sender;

@end

@interface HLTextFieldCheckInputNumberTool : NSObject<HLTextFieldCheckInputNumberDelegate,UITextFieldDelegate>
//最大输入数
@property(assign,nonatomic)NSInteger MAX_STARWORDS_LENGTH;

@end
