//
//  HLCompeteStoreInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLCompeteStoreInfo : NSObject
@property(nonatomic, copy) NSString *business_id;
@property(nonatomic, copy) NSString *hui_class_id;
@property(nonatomic, copy) NSString *store_id;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *distance;
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, copy) NSString *business_name;
@property(nonatomic, assign) NSInteger state;
@property(nonatomic, copy) NSString *typeName;
@end

NS_ASSUME_NONNULL_END
