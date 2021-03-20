//
//  HLWithDrawalPageInfo.m
//  HuiLife
//
//  Created by 王策 on 2019/9/19.
//

#import "HLWithDrawalPageInfo.h"

@implementation HLWithDrawalPageInfo

-(NSString *)matters_info{
    if (_matters_info) {
        return [_matters_info stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }
    return @"";
}

@end
