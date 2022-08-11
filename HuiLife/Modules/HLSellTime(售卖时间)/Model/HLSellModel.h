//
//  HLSellModel.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSellModel : NSObject

@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) NSArray *values;

@end


@interface HLTimeModel : NSObject

@property(nonatomic, copy) NSString *beginTime;

@property(nonatomic, copy) NSString *endTime;

@end
NS_ASSUME_NONNULL_END
