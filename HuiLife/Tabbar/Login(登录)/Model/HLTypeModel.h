//
//  HLTypeModel.h
//  HuiLife
//
//  Created by 王策 on 2021/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLTypeSubModel;
@interface HLTypeModel : NSObject

@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSArray <HLTypeSubModel *>*sub;

@end

@interface HLTypeSubModel : NSObject

@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;

@end



NS_ASSUME_NONNULL_END
