//
//  HLImageCollectionCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import <UIKit/UIKit.h>


typedef void(^HLDeleteImageBlock)(void);

@interface HLImageCollectionCell : UICollectionViewCell

@property(nonatomic,strong)NSString * imageStr;

@property(nonatomic,strong)UIImage * image;

@property(nonatomic,assign)BOOL showDelete;

@property(nonatomic,copy)HLDeleteImageBlock deleteBlock;

@end

