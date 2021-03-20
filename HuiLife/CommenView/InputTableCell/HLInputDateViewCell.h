//
//  HLInputDateViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/5.
//

#import "HLBaseInputViewCell.h"

@interface HLInputDateInfo : HLBaseTypeInfo

//0 显示箭头，1 显示 开关
@property(nonatomic,assign)NSInteger dateType;

@property(nonatomic,copy)NSString * placeHoder;

/// 开关是否打开了
@property (nonatomic, assign) BOOL swithOn;

@end


@protocol HLInputDateViewCellDelegate;

@interface HLInputDateViewCell : HLBaseInputViewCell

@property(nonatomic,weak)id<HLInputDateViewCellDelegate>delegate;

@end




@protocol HLInputDateViewCellDelegate <NSObject>

@optional
-(void)dateCell:(HLInputDateViewCell *)cell switchON:(BOOL)on;

@end
