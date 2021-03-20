//
//  HLTempleteCollectionCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import <UIKit/UIKit.h>
#import "HLTemplateModel.h"

@class HLTempleteCollectionCell;
@protocol HLTempleteCollectionDelegate <NSObject>

-(void)collectionCell:(HLTempleteCollectionCell *)cell deteleWithModel:(HLTemplateModel *)model;

@end


@interface HLTempleteCollectionCell : UICollectionViewCell

@property(nonatomic,strong)HLTemplateModel * model;

@property(nonatomic,weak)id<HLTempleteCollectionDelegate>delegate;

@end

