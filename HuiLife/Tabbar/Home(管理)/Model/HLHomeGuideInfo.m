//
//  HLHomeGuideInfo.m
//  HuiLife
//
//  Created by 王策 on 2019/10/15.
//

#import "HLHomeGuideInfo.h"

@implementation HLHomeGuideInfo

- (BOOL)needShowStepGuide{
    return self.one || self.two || self.three;
}

- (BOOL)needShowStep1{
    return self.one;
}

- (BOOL)needShowStep2{
    return self.two;
}

- (BOOL)needShowStep3{
    return self.three;
}

@end
