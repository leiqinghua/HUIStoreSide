//
//  HLCityJsonManager.h
//  HuiLifeUserSide
//
//  Created by 王策 on 2019/7/4.
//  Copyright © 2019 wce. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HLCityJsonCallBack)(NSArray *cityData);

NS_ASSUME_NONNULL_BEGIN

@interface HLCityJsonManager : NSObject

+ (NSString *)citySaveUpCode;

+ (void)saveUpCode:(NSString *)upCode;

+ (void)loadAreaDataWithController:(HLBaseViewController *)controller callBack:(HLCityJsonCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
