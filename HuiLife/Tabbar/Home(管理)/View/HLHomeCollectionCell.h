//
//  HLHomeCollectionCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import <UIKit/UIKit.h>
#import "HLHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLHomeCollectionCell : UICollectionViewCell

@property(nonatomic,strong)HLHomeModel * itemData;

@property(strong,nonatomic)UIImageView * topImageV;


@end

NS_ASSUME_NONNULL_END
