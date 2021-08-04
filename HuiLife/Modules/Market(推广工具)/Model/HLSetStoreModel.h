//
//  HLSetStoreModel.h
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSetStoreModel : NSObject

@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *userIdBuss;
@property (nonatomic, copy) NSString *userIdAgent;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, assign) NSInteger isGeneralStore;
@property (nonatomic, copy) NSString *storePic;
@property (nonatomic, copy) NSString *storeAddress;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *classId;
@property (nonatomic, copy) NSString *className;

@end

NS_ASSUME_NONNULL_END
