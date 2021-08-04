//
//  HLBillHeaderView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLBillHeaderView : UIView

-(instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@property(strong,nonatomic)NSDictionary *info;

@property(copy,nonatomic)NSString *date;
@end

NS_ASSUME_NONNULL_END
