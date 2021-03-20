//
//  HLHotPromoteCollectionCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/2/19.
//

#import "HLBaseCollectionCell.h"
#import "HLHotMainModel.h"
#import "HLHotActivityCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HLHotPromoteCollectionDelegate <NSObject>
//下拉刷新 上啦加载
- (void)hl_refreshListWithMainModel:(HLHotMainModel *)mainModel;
//点击进详情
- (void)hl_selectItemWithListModel:(HLHotListModel *)listModel;

@end

@interface HLHotPromoteCollectionCell : HLBaseCollectionCell

@property(nonatomic, strong) HLHotMainModel *mainModel;

@property(nonatomic, weak) id <HLHotPromoteCollectionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
