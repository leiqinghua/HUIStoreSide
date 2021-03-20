//
//  HLPickUpGoodModel.h
//  HuiLife
//
//  Created by 雷清华 on 2020/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLPickUpGoodModel : NSObject

@property(nonatomic, copy) NSString *pro_name;

@property(nonatomic, copy) NSString *pro_pic;

@property(nonatomic, assign) NSInteger pro_num;

@property(nonatomic, assign) double pay_price;

@property(nonatomic, assign) double price;

@end

NS_ASSUME_NONNULL_END
