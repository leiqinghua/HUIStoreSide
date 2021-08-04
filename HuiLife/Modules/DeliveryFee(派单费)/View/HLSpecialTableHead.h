//
//  HLSpecialTableHead.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLSpecialTableHead;
@protocol HLSpecialTableHeadDelegate <NSObject>

- (void)tableHead:(HLSpecialTableHead *)tableHead open:(BOOL)open;

@end

@interface HLSpecialTableHead : UIView

@property(nonatomic, weak) id<HLSpecialTableHeadDelegate> delegate;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *subTitle;

@property(nonatomic, assign) BOOL on;

@property(nonatomic, assign) BOOL hideLine;

@end

NS_ASSUME_NONNULL_END
