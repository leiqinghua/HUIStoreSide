//
//  HLGuideMaskDefine.h
//  HuiLife
//
//  Created by 王策 on 2019/10/15.
//

typedef enum : NSUInteger {
    HLGuideMaskTypeNo1,
    HLGuideMaskTypeNo2,
    HLGuideMaskTypeNo3,
    HLGuideMaskTypeNo4,
    HLGuideMaskTypeNo5,
    HLGuideMaskTypeStep1,
    HLGuideMaskTypeStep2,
    HLGuideMaskTypeStep3
} HLGuideMaskType;

// 是否功能点击
typedef void(^HLGuideMaskClickBlock)(BOOL isFuncClick);

// 编号1-5是否展示标志
#define kGuideMaskNo1To5HasShow @"kGuideMaskNo1To5HasShow"

// step1是否展示标志
#define kGuideMaskStep1HasShow @"kGuideMaskStep1HasShow"

// step2是否展示标志
#define kGuideMaskStep2HasShow @"kGuideMaskStep2HasShow"
