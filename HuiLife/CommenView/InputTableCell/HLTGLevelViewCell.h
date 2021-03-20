//
//  HLTGLevelViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import "HLBaseInputViewCell.h"


@interface HLTGLevelInfo : HLBaseTypeInfo

//0较弱，1 中等，2非常好
@property (nonatomic, assign) NSInteger levle;

@end


@interface HLTGLevelViewCell : HLBaseInputViewCell

@end

