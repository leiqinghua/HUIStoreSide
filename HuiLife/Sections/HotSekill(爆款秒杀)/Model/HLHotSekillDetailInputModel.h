//
//  HLHotSekillDetailInputModel.h
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLHotSekillDetailUnitModel;
@interface HLHotSekillDetailInputModel : NSObject

@property (nonatomic, copy) NSString *contentName;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *orinalPrice;
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSArray <HLHotSekillDetailUnitModel *>*unitArr;
@property (nonatomic, strong) HLHotSekillDetailUnitModel *selectUnit;

- (NSDictionary *)buildParams;

@end

@interface HLHotSekillDetailUnitModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
