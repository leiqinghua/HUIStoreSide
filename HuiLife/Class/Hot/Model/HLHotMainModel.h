//
//  HLHotMainModel.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLHotListModel;
@interface HLHotMainModel : NSObject

@property(nonatomic, copy) NSString *bigId;

@property(nonatomic, copy) NSString *subId;

@property(nonatomic, assign) NSInteger curPage;

@property(nonatomic, strong) NSMutableArray<HLHotListModel *> *datasource;

@property(nonatomic, assign) BOOL isMore;

@property(nonatomic, assign) BOOL showNotView;

@end

NS_ASSUME_NONNULL_END
