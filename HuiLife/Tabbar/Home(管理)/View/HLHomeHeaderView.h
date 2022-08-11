//
//  HLHomeHeaderView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import <UIKit/UIKit.h>

@protocol HLHomeHeaderViewDelegate;
@class HLReviewModel;
@interface HLHomeHeaderView : UICollectionReusableView

@property(nonatomic,strong)NSDictionary * dataDict;

@property(nonatomic, strong)HLReviewModel *reviewInfo;

@property(nonatomic, weak) id<HLHomeHeaderViewDelegate>delegate;

@end


@protocol HLHomeHeaderViewDelegate <NSObject>

- (void)headerView:(HLHomeHeaderView *)headerView statu:(BOOL)statu;

@end
