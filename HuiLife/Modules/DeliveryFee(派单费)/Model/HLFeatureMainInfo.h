//
//  HLFeatureMainInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLFeatureInfo;
@interface HLFeatureMainInfo : NSObject

@property(nonatomic, assign) BOOL is_open;
@property(nonatomic, copy) NSString *label_1;
@property(nonatomic, copy) NSString *label_2;
@property(nonatomic, copy) NSString *label_3;

@property(nonatomic, strong) NSMutableArray<HLFeatureInfo *> *datasource;

@end

@interface HLFeatureInfo :NSObject
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *value;

@end
NS_ASSUME_NONNULL_END
