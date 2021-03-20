//
//  HLRightBoxInputViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLBaseInputViewCell.h"


@interface HLRightBoxInputInfo : HLBaseTypeInfo

@property(nonatomic,copy)NSString * placeHolder;

@property (nonatomic, assign) UIKeyboardType keyBoardType;

@end

@interface HLRightBoxInputViewCell : HLBaseInputViewCell

@end

