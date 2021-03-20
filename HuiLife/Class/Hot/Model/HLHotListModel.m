//
//  HLHotListModel.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/19.
//

#import "HLHotListModel.h"

@implementation HLHotListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"huiSubClassList":@"HLHotClass"};
}
@end
