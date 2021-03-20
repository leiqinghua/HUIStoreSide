//
//  HLHotMainModel.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/19.
//

#import "HLHotMainModel.h"

@implementation HLHotMainModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _curPage = 1;
        _datasource = [NSMutableArray array];
    }
    return self;
}
@end
