//
//  HLHotBuyKindModel.m
//  HuiLife
//
//  Created by 王策 on 2019/10/30.
//

#import "HLHotBuyKindModel.h"

@implementation HLHotBuyKindModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"cat_id":@"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"child":@"HLHotBuyKindModel"};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.child = [NSMutableArray array];
    }
    return self;
}

@end
