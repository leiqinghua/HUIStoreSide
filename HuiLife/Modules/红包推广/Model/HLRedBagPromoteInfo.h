//
//  HLRedBagPromoteInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLRedBagPromoteInfo : NSObject
@property(nonatomic, copy) NSString *Id;//红包推广ID
@property(nonatomic, copy) NSString *proId;//推广的商品ID
@property(nonatomic, copy) NSString *name;//名称
@property(nonatomic, copy) NSString *pic;//图片
@property(nonatomic, assign) NSInteger state;//状态(0:推广中 1:暂停中 2已结束)
@property(nonatomic, copy) NSString *total;//总额
@property(nonatomic, copy) NSString *left;//剩余
@property(nonatomic, copy) NSString *get;//领取
@property(nonatomic, copy) NSString *back;//退回(目前没有)
@property(nonatomic, assign) NSInteger scopeType;//推广范围类型(0:本店顾客 1:同城顾客)
@property(nonatomic, copy) NSString *scopeStr;//推广范围
@property(nonatomic, assign) NSInteger timeType;//推广时间类型(0:10天 1:30天 2：领完为止)
@property(nonatomic, copy) NSString *timeStr;//推广时间
@end

//记录
@interface HLRedBagRecordInfo : NSObject
@property(nonatomic, copy) NSString *Id;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *money;
@end
NS_ASSUME_NONNULL_END
