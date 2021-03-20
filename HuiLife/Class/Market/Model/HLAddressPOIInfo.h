//
//  HLAddressPOIInfo.h
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/12/24.
//  Copyright © 2018 wce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLAddressPOIInfo : NSObject

@property (copy, nonatomic) NSString *detail;

@property (copy, nonatomic) NSString *all;

@property (copy, nonatomic) NSString *realDetailAddress; // 提供外部的地址

@property (copy, nonatomic) NSString *city;

@property (copy, nonatomic) NSString *area;

@property (copy, nonatomic) NSString *province;

@property (assign, nonatomic) double latitude;

@property (assign, nonatomic) double longitude;

@property (assign, nonatomic) BOOL select;


@end

NS_ASSUME_NONNULL_END
