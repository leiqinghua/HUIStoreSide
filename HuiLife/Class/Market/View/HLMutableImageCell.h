//
//  HLMutableImageCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import <UIKit/UIKit.h>


#define HLDeleteImageNotifi @"HLDeleteImageNotifi"

@class HLMutableImageCell;
@protocol HLPickerImageDelegate <NSObject>

-(void)imageCell:(HLMutableImageCell *)cell pickerWithSingle:(BOOL)single;

-(void)deleteImageWithIndex:(NSInteger)index single:(BOOL)single;

@end


@interface HLMutableImageCell : UITableViewCell

@property(assign,nonatomic)BOOL single;

@property(nonatomic,strong)NSMutableArray * images;

@property(nonatomic,weak)id<HLPickerImageDelegate>delegate;

@end

