//
//  HLRightButtonsViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2019/9/19.
//

#import "HLBaseInputViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface HLRightButtonsInfo:HLBaseTypeInfo

@property(nonatomic,strong)NSArray * titles;

@property(nonatomic,copy)NSString * tip;

@property(nonatomic,assign)NSInteger selectIndex;

@end


@protocol HLRightButtonsViewCellDelegate <NSObject>

-(void)hlButtonsCellWithSelectIndex:(NSInteger)index typeInfo:(HLRightButtonsInfo *)info;

@end


@interface HLRightButtonsViewCell : HLBaseInputViewCell

@property(nonatomic,weak)id<HLRightButtonsViewCellDelegate>delegate;

@end



NS_ASSUME_NONNULL_END
