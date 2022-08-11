//
//  HLWithDrawalPageInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLWithDrawalPageInfo : NSObject

@property (nonatomic, copy) NSString *matters_info;
@property (nonatomic, assign) double money;

@property (nonatomic, assign) double max_price;
@property (nonatomic, assign) double min_price;

@end

NS_ASSUME_NONNULL_END
