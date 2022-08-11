//
//  HLCompeteUpMainInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/12.
//

#import "HLCompeteUpPageInfo.h"

@implementation HLCompeteUpPageInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _stores = [NSMutableArray array];
    }
    return self;
}

@end


@implementation HLCompeteClassInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}

@end
