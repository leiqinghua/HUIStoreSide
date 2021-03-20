//
//  HLInputImagesViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/27.
//

#import "HLBaseInputViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HLInputImagesViewCellDelegate;
@interface HLInputImagesInfo : HLBaseTypeInfo
//只能上传一张
@property(nonatomic, assign) BOOL single;
@property(nonatomic, strong) NSArray *pics;

@end

@interface HLInputImagesViewCell : HLBaseInputViewCell
@property(nonatomic, weak) id<HLInputImagesViewCellDelegate>delegate;
@end

@protocol HLInputImagesViewCellDelegate <NSObject>

- (void)imagesCell:(HLInputImagesViewCell *)cell imagesInfo:(HLInputImagesInfo *)info;

@end

NS_ASSUME_NONNULL_END
