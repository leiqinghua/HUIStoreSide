//
//  HLInputUseDescViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLBaseInputViewCell.h"


@interface HLInputUseDescInfo : HLBaseTypeInfo

@property(nonatomic,copy) NSString * placeHolder;

@property(nonatomic,assign)BOOL changeLine;

@property(nonatomic, assign) NSInteger maxNum;

@property(nonatomic, assign) BOOL showNum;

@property(nonatomic, assign) BOOL hideBorder;//隐藏边框

@property(nonatomic,assign)BOOL singleLine;

@end

@interface HLInputUseDescViewCell : HLBaseInputViewCell

@end

