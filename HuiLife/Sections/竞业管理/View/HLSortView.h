//
//  HLSortView.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/11.
// 分类

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HLSortViewTypeNormal
} HLSortViewType;


@protocol HLSortViewDelegate;

@interface HLSortView : UIView

@property(nonatomic, assign) HLSortViewType type;

@property(nonatomic, strong) UIColor *itemBackgroundColor;

@property(nonatomic, strong) UIColor *normalTitleColor;

@property(nonatomic, strong) UIColor *selectTitleColor;

@property(nonatomic, strong) UIColor *normalBorderColor;

@property(nonatomic, strong) UIColor *selectBorderColor;

@property(nonatomic, assign) CGFloat normalFont;

@property(nonatomic, assign) CGFloat selectFont;
//默认0
@property(nonatomic, assign) CGFloat normalBorderWidth;
//自适应宽度
@property(nonatomic, assign) BOOL autoWidth;

@property(nonatomic, assign) CGFloat height;
//autoWidth 为NO 可用
@property(nonatomic, assign) CGFloat width;
//内边距 autoWidth 为YES 可用
@property(nonatomic, assign) CGFloat inspacing;
//间距
@property(nonatomic, assign) CGFloat itemGap;

@property(nonatomic, strong) NSArray *datasource;

@property(nonatomic, weak) id <HLSortViewDelegate>delegate;

- (void)sortViewSelectIndex:(NSInteger)index;

@end


@protocol HLSortViewDelegate <NSObject>

- (void)sortView:(HLSortView *)sortView selectAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
