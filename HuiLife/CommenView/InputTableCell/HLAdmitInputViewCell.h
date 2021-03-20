//
//  HLAdmitInputViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLBaseInputViewCell.h"



@protocol HLAdmitInputViewDelegate <NSObject>

-(void)admitViewWithModel:(HLBaseTypeInfo *)inputInfo admit:(BOOL)admit;

@end


@interface HLAdmitInputInfo : HLBaseTypeInfo

@property(nonatomic,assign) BOOL admit;

@property(nonatomic,copy) NSString *placeHolder;

@property(nonatomic,copy) NSString *subText;
/// 键盘类型
@property(nonatomic, assign) UIKeyboardType keyBoardType;

@property(nonatomic,assign) BOOL showBox;

@property(nonatomic,assign) BOOL showArrow;

@property(nonatomic,assign) BOOL canInput;

//两个按钮的title
@property(nonatomic,strong) NSArray *titles;

@end

@interface HLAdmitInputViewCell : HLBaseInputViewCell

@property(nonatomic,weak)id<HLAdmitInputViewDelegate>delegate;

@end

