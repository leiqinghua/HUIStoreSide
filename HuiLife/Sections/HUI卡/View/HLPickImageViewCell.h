//
//  HLPickImageViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HLPickImageViewCellDelegate ;
@interface HLPickImageViewCell : UICollectionViewCell

@property(nonatomic, copy) NSString *pic;

@property(nonatomic, weak) id<HLPickImageViewCellDelegate> delegate;

@end

@interface HLImageAddViewCell : UICollectionViewCell

@end


@protocol HLPickImageViewCellDelegate <NSObject>

- (void)deleteWithImage:(NSString *)pic;

@end

NS_ASSUME_NONNULL_END
