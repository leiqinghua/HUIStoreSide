//
//  HLCustomField.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/13.
//

#import <UIKit/UIKit.h>

@class HLCustomField;
@protocol HLCustomFieldDelegate <NSObject>

-(void)customField:(HLCustomField *)field searchWithText:(NSString *)text;

-(void)customField:(HLCustomField *)field searchDidChangeText:(NSString *)text;

-(void)customFieldShouldBeginEditing;

@end


@interface HLCustomField : UIView

@property(nonatomic,copy)NSString * placeHolder;

@property(nonatomic,copy)UIImage * searchImg;

@property(nonatomic,copy)UIColor * textColor;

@property(nonatomic,copy)UIFont * textFont;

@property(nonatomic,copy)NSAttributedString * placeAttr;

@property(nonatomic,copy,readonly)NSString * text;

@property(nonatomic,weak)id<HLCustomFieldDelegate>delegate;

@end

