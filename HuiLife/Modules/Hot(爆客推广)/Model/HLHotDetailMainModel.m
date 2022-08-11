//
//  HLHotDetailMainModel.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/20.
//

#import "HLHotDetailMainModel.h"

@implementation HLHotDetailMainModel

- (instancetype)init
{
    self = [super init];
    if (self) {
//        默认高度
        _contentHight = FitPTScreen(100);
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"generalizeFunList":@"HLHotFunction",
             @"featureList": @"HLFeature",
             @"caseInfo":@"HLHotCaseInfo"
    };
}

- (CGFloat)funHight {
    
    if (!_generalizeFunList.count) {
        return 0;
    }
    
    if (!_funHight) {
        CGFloat hight = FitPTScreen(40);
        NSInteger row = (_generalizeFunList.count - 1) / 3 + 1;
        _funHight = hight + FitPTScreen(70)*row + FitPTScreen(10);
    }
    return _funHight;
}

- (CGFloat)caseHight {
    if (!_caseInfo.count) {
           return 0;
       }
       if (!_caseHight) {
           CGFloat hight = FitPTScreen(40);
           _caseHight = hight + FitPTScreen(110)*_caseInfo.count + FitPTScreen(10);
       }
       return _caseHight;
}


@end


@implementation HLHotFunction

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}


@end


@implementation HLHotCaseInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}


@end

@implementation HLFeature

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}

@end

@implementation HLHotAlertInfo



@end
