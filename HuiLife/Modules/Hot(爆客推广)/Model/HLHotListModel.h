//
//  HLHotListModel.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/19.
//

#import <Foundation/Foundation.h>
#import "HLHotClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLHotListModel : NSObject

@property(nonatomic, copy) NSString *Id;
//活动名称
@property(nonatomic, copy) NSString *title;
//活动图片
@property(nonatomic, copy) NSString *pic;
@property(nonatomic, copy) NSString *typeName;
//商家使用量
@property(nonatomic, copy) NSString *shopUseNum;
@property(nonatomic, copy) NSString *butName;
@property(nonatomic, copy) NSString *hui_sub_class_id;

@property(nonatomic, assign) NSInteger default_shop_num;
//引流数量
@property(nonatomic, copy) NSString * orderNum;
//关联小类
@property(nonatomic, strong) NSArray<HLHotClass *> *huiSubClassList;

@end

NS_ASSUME_NONNULL_END
