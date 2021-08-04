//
//  HLCompeteUpPageInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/12.
//

#import <Foundation/Foundation.h>
#import "HLCompeteStoreInfo.h"

NS_ASSUME_NONNULL_BEGIN
@class HLCompeteClassInfo;
@interface HLCompeteUpPageInfo : NSObject

@property(nonatomic, assign) NSInteger page;

@property(nonatomic, strong) NSMutableArray<HLCompeteStoreInfo *> *stores;

@property(nonatomic, strong) HLCompeteClassInfo *classInfo;

@property(nonatomic, assign) BOOL noMoreData;

@property(nonatomic, assign) BOOL showNodataView;

@end


@interface HLCompeteClassInfo : NSObject
@property(nonatomic, copy) NSString *Id;
@property(nonatomic, copy) NSString *class_name;
@end

NS_ASSUME_NONNULL_END
