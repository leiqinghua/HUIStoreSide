//
//  HLCardPromotionCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import <UIKit/UIKit.h>

@interface HLCardPromotion : NSObject

@property(nonatomic,copy)NSString * name;

@property(nonatomic,copy)NSString * desc;

@property(nonatomic,copy)NSString * icon;

@property(nonatomic,copy)NSString * iosArdess;

@property(nonatomic,strong)NSDictionary * iosParam;

@end



@class HLCardPromotionCell;
@protocol HLCardPromotionDelegate <NSObject>

-(void)promotionCell:(HLCardPromotionCell *)cell clickWithModel:(HLCardPromotion *)model;

@end

@interface HLCardPromotionCell : UITableViewCell

@property(nonatomic,strong) HLCardPromotion * model;

@property(nonatomic,weak)id<HLCardPromotionDelegate>delegate;

@end

